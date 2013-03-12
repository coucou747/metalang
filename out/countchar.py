
import sys

char=None

def readchar_():
  global char;
  if char == None:
    char = sys.stdin.read(1);
  return char;

def skipchar():
  global char;
  char = None;
  return;

def readchar():
  out = readchar_();
  skipchar();
  return out;

def stdinsep():
  while True:
    c = readchar_();
    if c == '\n' or c == '\t' or c == '\r' or c == ' ':
      skipchar();
    else:
      return;

def readint():
  c = readchar_();
  if c == '-':
    sign = -1;
    skipchar();
  else:
    sign = 1;
  out = 0;
  while True:
    c = readchar_();
    if c <= '9' and c >= '0' :
      out = out * 10 + int(c);
      skipchar();
    else:
      return out * sign;

def nth( tab, tofind, len ):
    out_ = 0;
    for i in range(0, 1 + len - 1):
      if tab[i] == tofind:
        out_ = out_ + 1;
    return out_;

len = 0;
len=readint();
stdinsep();
tofind = '\000';
tofind=readchar();
stdinsep();
tab = [None] * (len);
for i in range(0, 1 + len - 1):
  tmp = '\000';
  tmp=readchar();
  tab[i] = tmp;
result = nth(tab, tofind, len);
print("%d" % result, end='');
