
var util = require("util");
var fs = require("fs");
var current_char = null;
var read_char0 = function(){
    return fs.readSync(process.stdin.fd, 1)[0];
}
var read_char_ = function(){
    if (current_char == null) current_char = read_char0();
    var out = current_char;
    current_char = read_char0();
    return out;
}
var stdinsep = function(){
    if (current_char == null) current_char = read_char0();
    while (current_char == '\n' || current_char == ' ' || current_char == '\t')
        current_char = read_char0();
}
var read_int_ = function(){
    if (current_char == null) current_char = read_char0();
    var sign = 1;
    if (current_char == '-'){
        current_char = read_char0();
        sign = -1;
    }
    var out = 0;
    while (true){
        if (current_char.charCodeAt(0) >= '0'.charCodeAt(0) && current_char.charCodeAt(0) <= '9'.charCodeAt(0)){
            out = out * 10 + current_char.charCodeAt(0) - '0'.charCodeAt(0);
            current_char = read_char0();
        }else{
            return out * sign;
        }
    }
}



function mktoto(v1){
  var c = {
             foo : v1,
             bar : 0,
             blah : 0
  };
  var t = c;
  return t;
}

function result(t){
  t.blah ++;
  return t.foo + t.blah * t.bar + t.bar * t.foo;
}

var t = mktoto(4);
t.bar=read_int_();
stdinsep();
t.blah=read_int_();
var a = result(t);
util.print(a);
var b = t.blah;
util.print(b);


