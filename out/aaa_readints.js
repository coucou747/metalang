var util = require("util");
var fs = require("fs");
var current_char = null;
function read_char0(){
    return fs.readSync(process.stdin.fd, 1)[0];
}
function stdinsep(){
    if (current_char == null) current_char = read_char0();
    while (current_char.match(/[\n\t\s]/g))
        current_char = read_char0();
}
function read_int_(){
  if (current_char == null) current_char = read_char0();
  var sign = 1;
  if (current_char == '-'){
     current_char = read_char0();
     sign = -1;
  }
  var out = 0;
  while (true){
    if (current_char.match(/[0-9]/g)){
      out = out * 10 + current_char.charCodeAt(0) - '0'.charCodeAt(0);
      current_char = read_char0();
    }else{
      return out * sign;
    }
  }
}
len=read_int_();
stdinsep();
util.print(len, "=len\n");
var tab1 = new Array(len);
for (var k = 0 ; k <= len - 1; k++)
{
  tab1[k]=read_int_();
  stdinsep();
}
for (var i = 0 ; i <= len - 1; i++)
{
  util.print(i, "=>", tab1[i], "\n");
}
len=read_int_();
stdinsep();
var tab2 = new Array(len - 1);
for (var s = 0 ; s <= len - 1 - 1; s++)
{
  var ba = new Array(len);
  for (var v = 0 ; v <= len - 1; v++)
  {
    ba[v]=read_int_();
    stdinsep();
  }
  tab2[s] = ba;
}
for (var i = 0 ; i <= len - 2; i++)
{
  for (var j = 0 ; j <= len - 1; j++)
  {
    util.print(tab2[i][j], " ");
  }
  util.print("\n");
}

