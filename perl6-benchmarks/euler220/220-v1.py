#!/usr/bin/env python

# The Expat License
#
# Copyright (c) 2018, Shlomi Fish
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from six import print_


class State:
    """docstring for State"""

    def __init__(self):
        self.cur = [0, 0]
        self.dir1 = 0
        self.n = 0

    def dup(self):
        ret = State()
        ret.cur = [x for x in self.cur]
        ret.dir1 = self.dir1
        ret.n = self.n
        return ret

    def delta(self, o):
        ret = self.dup()
        ret.cur[0] -= o.cur[0]
        ret.cur[1] -= o.cur[1]
        ret.dir1 -= o.dir1
        ret.n -= o.n
        return ret

    def apply_delta(self, o):
        ret = self.dup()
        ret.cur[0] += o.cur[0]
        ret.cur[1] += o.cur[1]
        ret.dir1 += o.dir1
        ret.n += o.n
        return ret


s = State()
Cache = {}
dirs = [(0, 1), (1, 0), (0, -1), (-1, 0)]
maxdepth = 10
mn = 500
STEP = 100000000
printed = False


def dragon(depth, seq):
    global Cache, maxdepth, s
    init = s.dup()
    key = (depth, seq, (s.dir1 & 3))
    if key in Cache:
        val = Cache[key]
        if val.n + s.n < mn:
            s = s.apply_delta(val)
            return
    for c in seq:
        if c == 'a':
            if depth < maxdepth:
                dragon(depth+1, 'aRbFR')
        elif c == 'b':
            if depth < maxdepth:
                dragon(depth+1, 'LFaLb')
        elif c == 'R':
            s.dir1 += 1
        elif c == 'L':
            s.dir1 -= 1
        elif c == 'F':
            s.n += 1
            s.cur[0] += dirs[s.dir1 & 3][0]
            s.cur[1] += dirs[s.dir1 & 3][1]
        else:
            raise BaseException("unknown")
        if s.n >= mn:
            if s.n == mn:
                global printed
                if not printed:
                    print_("cur = %d,%d" % (s.cur[0], s.cur[1]))
                    printed = True
            return
    Cache[key] = s.delta(init)


dragon(0, 'Fa')
maxdepth = 50
mn = 1000000000000
s = State()
Cache = {}
printed = False
dragon(0, 'Fa')
