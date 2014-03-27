import sys
char=None
def readchar_():
  global char
  if char == None:
    char = sys.stdin.read(1)
  return char

def skipchar():
  global char
  char = None
  return
def stdinsep():
  while True:
    c = readchar_()
    if c == '\n' or c == '\t' or c == '\r' or c == ' ':
      skipchar()
    else:
      return
def readint():
  c = readchar_()
  if c == '-':
    sign = -1
    skipchar()
  else:
    sign = 1
  out = 0
  while True:
    c = readchar_()
    if c <= '9' and c >= '0' :
      out = out * 10 + int(c)
      skipchar()
    else:
      return out * sign

def mktoto( v1 ):
    d = {"foo":v1, "bar":0, "blah":0}
    t = d;
    return t;

def result( t, len ):
    out_ = 0;
    for j in range(0, len):
      t[j]["blah"] = t[j]["blah"] + 1;
      out_ = out_ + t[j]["foo"] + t[j]["blah"] * t[j]["bar"] + t[j]["bar"] * t[j]["foo"];
    return out_;

a = 4;
t = [None] * a
for i in range(0, a):
  t[i] = mktoto(i);
t[0]["bar"]=readint()
stdinsep()
t[1]["blah"]=readint()
b = result(t, 4);
print("%d" % b, end='')
c = t[2]["blah"];
print("%d" % c, end='')

