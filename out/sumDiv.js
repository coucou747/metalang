
var util = require("util");
var fs = require("fs");
var current_char = null;
var read_char0 = function(){
    return fs.readSync(process.stdin.fd, 1)[0];
}
var read_char = function(){
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
var read_int = function(){
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


function foo(){
  var a = 0;
  /* test */
  a ++;
  /* test 2 */
}

function foo2(){
  
}

function foo3(){
  if (1 == 1)
  {
    
  }
}

function sumdiv(n){
  /* On désire renvoyer la somme des diviseurs */
  var out_ = 0;
  /* On déclare un entier qui contiendra la somme */
  for (var i = 1 ; i <= n; i++)
  {
    /* La boucle : i est le diviseur potentiel*/
    if ((n % i) == 0)
    {
      /* Si i divise */
      out_ += i;
      /* On incrémente */
    }
    else
    {
      /* nop */
    }
  }
  return out_;
  /*On renvoie out*/
}

/* Programme principal */
var n = 0;
n=read_int();
/* Lecture de l'entier */
var b = sumdiv(n);
util.print(b);


