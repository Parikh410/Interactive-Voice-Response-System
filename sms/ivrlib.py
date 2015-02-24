#!/usr/bin/python

from starpy import fastagi

from twisted.internet import reactor
from twisted.internet import defer
from twisted.protocols.policies import TimeoutMixin
from twisted.application import internet, service

import logging
log = logging.getLogger("ivrlib")
from ConfigParser import ConfigParser

class ivrlib(TimeoutMixin):
    '''This is a utility class for comonly used routines of IVRs'''
    def __init__(self):
        self.callerid = self.agi.variables['agi_callerid']
        self.uniqueid = self.agi.variables["agi_uniqueid"]        
        self.setTimeout(1200)
        
    def initLogger(self):
        self.log = logging.getLogger("SMS:%s"%self.callerid)
        self.log.setLevel(logging.DEBUG)
    
    def hangup(self,*args):
        self.agi.hangup()
    def finish(self,*args):
        self.agi.finish()
    def noService(self, *args):
        '''s = fastagi.InSequence()
        s.append(self.agi.streamFile,"service")
        s.append(self.agi.streamFile,"unavailable")
        s.append(self.agi.streamFile,"at")
        s.append(self.agi.streamFile,"this")
        s.append(self.agi.streamFile,"time")
        return s().addCallbacks(self.hangup,self.hangup)'''
        df = self.agi.streamFile(soundsdir+'i_am_sorry_we_are_unable_to_process_your_request_at_this_time_please_call_later_or_visit_our_webite_thank_you')
        df.addCallbacks(self.hangup, self.hangup)
    def getWord(self,res=None,cb=None):  
        print cb      
        def onWord(word):
            if word.strip() == 'NOSERVICE':
                return self.noService()
            else:
                self.word = word
            if cb:
                return cb()
        self.agi.getVariable("SPEECHREC").addCallbacks(onWord,self.hangup)
    def noInput(self, *args):
        df = self.agi.streamFile(soundsdir+'no_input_received_please_call_later')
        df.addCallbacks(self.hangup, self.hangup)
    def cantDetect(self):
        return self.agi.streamFile(soundsdir+'i_am_sorry_the_channel_seems_to_be_quite_bad_at_the_moment_please_call_later_or_visit_our_website_thank_you').addCallbacks(self.hangup,self.hangup)

    def notFollowed(self, *args):
        df = self.agi.streamFile(soundsdir+'sorry_no_sound_was_recorded')
        log.info("playing did not follow")
        return df 
        
    def lowerWord(self):
        log.debug('returning detected word in lower case ->'+self.word)
        return self.word.lower()
    def maxTriesExceeded(self):
        self.agi.streamFile("sorryexceededmaxtries").addCallbacks(self.hangup,self.hangup)
    def startMusic(self, *args):
        log.info('starting music on hold')
        return self.agi.setMusic()
    def stopMusic(self,*args):
        self.log.info('stopping music on hold')        
        return self.agi.setMusic(False)
        
    def runQuery(self, dbpool, sql, data=()):
        self.dbtries = 0
        return dbpool.runQuery(sql,data)
        
    def checkLost(self, err, cb):
        #Used for calling database if connection fails, tries thrice and then hangup 
        if self.dbtries > 3:
            self.dbtries = 0
            log.error("Failed to communicate with DB. Exceeded maximum tries.")
            return self.hangup()
        self.dbtries += 1
        print err
        cb()
        
        
class CollectDigits(ivrlib):
    prompt = None
    timeout = 3.0
    maxTries= 3
    tries = 0
    expected = []
    maxDigits = ''
    def __init__(self, agi, ):
        self.agi = agi
    def __call__(self, *args):
        self.df = defer.Deferred()
        self._startLoop()
        return self.df
    def playPrompt(self):
        df = self.agi.getData(self.prompt, self.timeout, maxDigits = self.maxDigits)
        df.addCallback(self._startLoop)
        df.addErrback(self.hangup)
    def _startLoop(self, res=None):
        print res
        try:
            digits = int(res[0])
            #return self.df.callback(digits)
            return reactor.callLater(1, self.df.callback, digits)
        except:
            pass
        if self.tries == self.maxTries:
            log.debug('Exceeded maximum number of tries')
            return self.noInput()
        else:
            self.tries += 1
            return self.playPrompt()
            
class CollectOption(ivrlib):
    prompt = ''    
    options = ''
    maxTries = 3
    timeout = None
    tries = 0
    def __init__(self, agi):
        self.agi = agi
    def __call__(self,*args):
        self.optionlist = []
        for o in self.options:
            self.optionlist.append(o)
        self.df = defer.Deferred()
        self._startLoop()
        return self.df
    def playPrompt(self):
        df = self.agi.getOption(self.prompt,self.options,self.timeout)
        df.addCallback(self._startLoop)
        df.addErrback(self.hangup)
    def _startLoop(self, *res):    
        print res
        if res:
            option = res[0][0]
        else:
            option = res
        if option in self.optionlist:
            return reactor.callLater(1, self.df.callback, option)            

        if self.tries == self.maxTries:
            log.debug("Exceeded maximum number of tries")
            return self.noInput()
        else:
            self.tries += 1
            return self.playPrompt()
            
class OptionOnPlaylist(CollectOption):    
    playlist = []    
    index = 0
    def __call__(self):
        self.maxTries = self.maxTries * len(self.playlist)
        self._timeout = self.timeout
        return CollectOption.__call__(self)
    def _startLoop(self, *res):
        print res
        if self.tries == self.maxTries:
            log.debug("Exceeded maximum number of tries")
            return self.hangup()
        if res:
            option = res[0][0]
        else:
            option = ''
        if option != '':            
            return reactor.callLater(1, self.df.callback, option)
        else:            
            self.tries+=1
            try:
                self.prompt = self.playlist[self.index]
                self.index+=1                
            except IndexError:                
                self.prompt = self.playlist[0]
                self.index = 1
            if self.index == len(self.playlist) :
                    self.timeout =  self._timeout
            else:
                self.timeout =  0
            self.playPrompt()
            
            
class CollectAudio(ivrlib):
    prompt = ''
    maxTries = 3
    tries = 0
    escapeDigits = '#'
    format = 'wav'
    silence_duration = 5        
    filename = ''
    
    def __init__(self, agi):
        self.agi = agi       
        
    def __call__(self):
        self.finalDF = defer.Deferred()
        self._startLoop()
        return self.finalDF
        
    def collectAudio(self):    
        s = fastagi.InSequence()
        s.append(self.agi.streamFile, self.prompt)
        #s.append(self.agi.recordFile, self.filename, self.format, self.escapeDigits, silence = self.silence_duration)
        s.append(self.agi.execute, "Record", self.filename+".wav")
        df = s()
        df.addCallback(self._startLoop)
        df.addErrback(noop)
    def _startLoop(self, *res):
        print res
        if res:
            #code, typeofExit, timeout = res[0][1]            
            code = res[0][1]
            if code == '0':
                return reactor.callLater(1, self.finalDF.callback, self.escapeDigits)
            else:
                reactor.callLater(1, self.finalDF.errback, Exception)
        """else:
            code, typeofExit, timeout = '', '', ''        
        if typeofExit == 'dtmf':
            code = int(code)
            if chr(code) in self.escapeDigits:
                return reactor.callLater(1, self.finalDF.callback, self.escapeDigits)
        elif typeofExit == 'hangup':
            self.hangup()    
         """
        if self.maxTries == self.tries:            
            log.debug("Exceeded maximum no of tries")
            self.hangup()
        else:
            self.tries = self.tries+1
            return self.collectAudio()
            
        
  


                                
class MyConfigParser(ConfigParser):
    def get(self, section, option, default=''):
        try:
            return ConfigParser.get(self, section, option)
        except:
            return default
            
def noop(*args):
    log.debug("Noop called with "+str(args))
    
def getApp(name, cb):
    f= fastagi.FastAGIFactory(cb)

    #logging.basicConfig()
    
    log.setLevel(logging.DEBUG)
    fastagi.log.setLevel(logging.INFO)

    ivrservice = internet.TCPServer(4575,f,500,)
    application = service.Application(name)
    ivrservice.setServiceParent(application)    
    return application
