#!/usr/bin/env python

import time, re, socket, struct

__all__ = ["monotonic_time"]

import ctypes, os

import ctypes.util

if_nametoindex = (ctypes.cdll.LoadLibrary(ctypes.util.find_library(u"c")).if_nametoindex)

CLOCK_MONOTONIC = 1 # see <linux/time.h>

class timespec(ctypes.Structure):
    _fields_ = [
        ('tv_sec', ctypes.c_long),
        ('tv_nsec', ctypes.c_long)
    ]

librt = ctypes.CDLL('librt.so.1', use_errno=True)
clock_gettime = librt.clock_gettime
clock_gettime.argtypes = [ctypes.c_int, ctypes.POINTER(timespec)]

def monotonic_time():
    t = timespec()
    if clock_gettime(CLOCK_MONOTONIC, ctypes.pointer(t)) != 0:
        errno_ = ctypes.get_errno()
        raise OSError(errno_, os.strerror(errno_))
    return t.tv_sec + t.tv_nsec * 1e-9

IF="eth0"

s = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
ifn = if_nametoindex("meutenetz")
ifn = struct.pack("I", ifn)
s.setsockopt(socket.IPPROTO_IPV6, socket.IPV6_MULTICAST_IF, ifn)

dst = ("paul.meute.ffhl", 4444)

last_time = monotonic_time()
last_rx = 0
last_tx = 0

while True:
  with open('/proc/net/dev', 'r') as dev:
    new_time = monotonic_time()
    for line in dev.readlines():
        match = re.match("\s+(\w+):\D+(\d+)\D+\d+\D+\d+\D+\d+\D+\d+\D+\d+\D+\d+\D+\d+\D+(\d+)\D+", line)
        if match:
          if match.group(1) == IF:
            rx = int(match.group(2))
            tx = int(match.group(3))
            drx = rx - last_rx
            dtx = tx - last_tx
            dtime = new_time - last_time

            if last_rx != 0 and last_tx != 0:
              s.sendto("traffic/rx:" + str(drx/dtime/1024), dst)
              s.sendto("traffic/tx:" + str(dtx/dtime/1024), dst)

            last_rx = rx
            last_tx = tx


  last_time = new_time
  time.sleep(0.1)
