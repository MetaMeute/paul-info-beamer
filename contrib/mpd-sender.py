# -*- coding: utf-8 -*-

import mpd
import socket
import struct
from time import sleep

import ctypes
import ctypes.util

if_nametoindex = (ctypes.cdll.LoadLibrary(ctypes.util.find_library(u"c")).if_nametoindex)

s = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)

client = mpd.MPDClient()           # create client object
client.timeout = 10                # network timeout in seconds (floats allowed), default: None
client.idletimeout = None          # timeout for fetching the result of the idle command is handled seperately, default: None

old_song = None
state = None

host = "::1"
port = 6600

ifn = if_nametoindex("meutenetz")
ifn = struct.pack("I", ifn)
s.setsockopt(socket.IPPROTO_IPV6, socket.IPV6_MULTICAST_IF, ifn)

dst = ("ff02::1", 4444)

count = 0

while True:
  try:
    song = client.currentsong()
    status = client.status()
  except mpd.ConnectionError as e:
    if client._sock != None:
      client.disconnect()

    try:
      client.connect(host, port)
    except:
      sleep(1)

    continue

  except socket.error as e:
    client.disconnect()

    sleep(1)
    continue

  count = count + 1

  try:
    if count > 50 or song['id'] != old_song or old_state != status['state']:
      count = 0
      state = status['state']
      title = song['title'].decode("utf-8")
      artist = None
      try:
        artist = song['artist'].decode("utf-8")
      except AttributeError:
        artist = ", ".join(map(lambda x: x.decode("utf-8"), song['artist']))

      if state == "pause":
        title = "[paused] " + title
      elif state == "stop":
        title = "[stopped]"
        artist = ""


      s.sendto("mpd-status/title:" + title.encode("utf-8"), dst)
      s.sendto("mpd-status/artist:" + artist.encode("utf-8"), dst)

      old_song = song['id']
      old_state = status['state']
  except KeyError:
    pass

  sleep(0.1)
