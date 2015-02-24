#!/usr/bin/python


import os
import sys

sys.path.insert(0, os.getcwd()) #twistd work around to be able import modules from current di$

from ivrlib import *

import logging
import logging.handlers

from twisted.enterprise import adbapi

import MySQLdb, MySQLdb.cursors

import datetime
import httplib

config = MyConfigParser()
config.read("/opt/jago/config.conf")

message = config.get("msg","message","Sorry, can't send message due to technical fault.")
log = logging.getLogger("Jago")
log.setLevel(logging.DEBUG)



class Jago(ivrlib):
    def __init__(self, agi):
        def timepass(res):
            print "data base insert"
        def checkLost(res):
            print "error"
        self.agi = agi
        ivrlib.__init__(self)
        self.initLogger()
        messagecounter = self.messagecheck()
        if (messagecounter == 0):
            sqlquery="INSERT into CallLog (CallerId,UniqueId,Date,MessageStatus) VALUES(%s,%s,%s,%s)"
            df = self.runQuery(dbpool, sqlquery, (self.callerid[-10:], self.uniqueid, datetime.datetime.now(), "NEW"))
            df.addCallback(timepass)
            message = self.messagefetch()
            print "Message ::"+message[0]
            self.log.debug("Start of Script for number " + self.callerid)
            self.log.debug("sending message to misscaller ::" + self.callerid)
            connection = httplib.HTTPConnection("smsidea.co.in", port=80)
            message = "/sendsms.aspx?mobile=9898396969&pass=100&senderid=LINTEL&to=" + self.callerid + "&msg="+message[0].replace(' ', '%20')
            #log.debug(message)
            #message.request("GET", str(message))
            connection.request("GET", message)
            log.debug(message)
            self.log.debug("Getting SMS response for " + self.callerid)
            reply = connection.getresponse()
            readreply = reply.read()
            sqlquery="UPDATE CallLog SET MessageStatus=%s, ReplyStatus=%s where UniqueId="+self.uniqueid
            df = self.runQuery(dbpool, sqlquery, ("DONE", readreply))
            df.addCallback(timepass)
            df.addErrback(checkLost)
            self.log.debug("Responce for Number " + self.callerid + " :: " + readreply)
        else:
            self.log.debug("Responce for Number " + self.callerid + " :: Message already send in last 24 hours.")
        self.hangup()

    def messagefetch(self):
        conn = MySQLdb.connect (host = "127.0.0.1", user = "root", passwd = "lintel@365", db = "sms")
        cursor = conn.cursor()
        cursor.execute ("SELECT Message FROM Message")
        message = cursor.fetchone()
        cursor.close()
        return message

    def messagecheck(self):
        conn = MySQLdb.connect (host = "127.0.0.1", user = "root", passwd = "lintel@365", db = "sms")
        cursor = conn.cursor()
        diff = datetime.datetime.now() - datetime.timedelta(hours = 24)
        cursor.execute ("SELECT CallerId, Date FROM CallLog WHERE Date >= %s and CallerId=%s",(diff, self.callerid[-10:],))
        a = cursor.fetchall()
        print len(a)
        return len(a)

dbpool = None
host = config.get("db", "host","127.0.0.1")
db = config.get("db", "db","sms")
user = config.get("db", "user","root")
passwd = config.get("db","passwd","lintel@365")

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
rfh = logging.handlers.RotatingFileHandler(logpath+"jagosms.log", maxBytes=50000, backupCount=5)
rfh.setFormatter(fmt)
rootlogger.addHandler(rfh)


def route(agi):
    Jago(agi)

application = getApp("Jago", route)

