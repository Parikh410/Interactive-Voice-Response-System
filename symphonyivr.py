#!/usr/bin/python


import os, sys
sys.path.insert(0, os.getcwd()) #twistd work around to be able import modules from current di$

from ivrlib import *

import logging
import logging.handlers

from twisted.enterprise import adbapi
from twisted.internet.protocol import Protocol

import MySQLdb,MySQLdb.cursors

import datetime

config = MyConfigParser()
config.read("/opt/lectureInfo/config.conf")

soundsdir = config.get("paths", "sounds", "lectures/")


class Symphony(ivrlib):


    def __init__(self, agi):
        self.agi = agi
        self.agi.status = "NEW"
        ivrlib.__init__(self)
        self.initLogger()
        self.agi.onClose().addErrback(self.onHangup) #Register a callback to clean up when hu$
        self.dbtries = 0
        self.times = None
        #self.logNewCall()
        self.welcome()

    def welcome(self):
        df = self.agi.streamFile(soundsdir+'welcome')
        df.addCallbacks(self.language, self.hangup)
        self.lang = "english"
        self.log.info("Caller chose english")
        self.agi.execute('Set', 'CHANNEL(language)=en').addCallbacks(self.mainMenu, self.hangup)


    def mainMenu(self, option):
        return SymphonyComplain(self.agi, self.uniqueid)

    def onHangup(self, reason):
        self.log.debug("Call hungup cleaning up")
        self.agi.incall = False
        self.logStatus()
        self.dbtries =0



class beginBodyCollection(Protocol):
    def __init__(self, finished):
        self.finished = finished
        self.remaining = 1024 * 10
        self.display = None

    def dataReceived(self, bytes):
        if self.remaining:
            self.display = bytes[:self.remaining]
            self.remaining -= len(display)

    def connectionLost(self, reason):
        self.finished.callback(self.display)

class SymphonyComplain(ivrlib):


    def __init__(self, agi, uniqueid):
        self.agi = agi
        self.agi.pinconfirm = False
        self.agi.crmcompno = "None"
        self.agi.responsecode = "None"
        self.agi.contact = "None"
        self.uniqueid = uniqueid
        self.URLflag = False
        ivrlib.__init__(self)
        self.initLogger()
        self.getLecture()
        #self.service()

    def getLecture(self):
        ltime=datetime.datetime.now().strftime("%H:%M:%S")
        lday= datetime.datetime.now().strftime("%A")
        sql = "SELECT filename from %s WHERE time >= %s AND <= %s"
        df = self.runQuery(dbpool,sql,(lday,ltime))
        df.addCallback(self.playFile)

    def playFile(self,option):
        if option:
            df = self.agi.streamFile(soundsdir+option)
        else:
            df = self.agi.streamFile(soundsdir+'none')
        df.addCallback(self.onHangup)

    def onHangup(self,option):
        s = fastagi.InSequence()
        s.append(self.agi.hangup)
        s()

dbpool = None
host = config.get("db", "host")
db = config.get("db", "db")
user = config.get("db", "user")
passwd = config.get("db","passwd")

def onConnect(*args):
    log.debug("Connected to DB ")

def connectDB(cb):
    global dbpool
    dbpool = adbapi.ConnectionPool('MySQLdb',
                                   host=host,
                                   db=db,
                                   user=user,
                                   passwd = passwd,
                                   cursorclass = MySQLdb.cursors.DictCursor,
                                   cp_reconnect=True,
                                   cp_openfun=cb,
                                   cp_noisy=True)

connectDB(onConnect)

logpath = config.get("paths", "log")
rootlogger = logging.getLogger('')
fmt = logging.Formatter('%(asctime)s-%(name)s-%(levelname)s : %(message)s')
sh = logging.StreamHandler()
sh.setFormatter(fmt)
rootlogger.addHandler(sh)
rfh = logging.handlers.RotatingFileHandler(logpath+"lvm.log", maxBytes=50000, backupCount=5)
rfh.setFormatter(fmt)
rootlogger.addHandler(rfh)


def route(agi):
    Symphony(agi)


application = getApp("Symphony", route)

