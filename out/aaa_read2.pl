#!/usr/bin/perl
sub nextchar{ sysread STDIN, $currentchar, 1; }
sub readchar{
  if (!defined $currentchar){ nextchar() ; }
  my $o = $currentchar;
  nextchar();
  return $o;
}
sub readint {
  if (!defined $currentchar){
     nextchar();
  }
  my $o = 0;
  my $sign = 1;
  if ($currentchar eq '-') {
    $sign = -1;
    nextchar();
  }
  while ($currentchar =~ /\d/){
    $o = $o * 10 + $currentchar;
    nextchar();
  }
  return $o * $sign;
}sub readspaces {
  while ($currentchar eq ' ' || $currentchar eq "\r" || $currentchar eq "\n"){ nextchar() ; }
}
sub remainder {
    my ($a, $b) = @_;
    return 0 unless $b && $a;
    return $a - int($a / $b) * $b;
}

#
#Ce test permet de vérifier si les différents backends pour les langages implémentent bien
#read int, read char et skip
#

my $b = 0;
$b = readint();
readspaces();
my $len = $b;
print($len, "=len\n");
my $e = [];
foreach my $f (0 .. $len - 1) {
  my $g = 0;
  $g = readint();
  readspaces();
  $e->[$f] = $g;
  }
my $tab = $e;
foreach my $i (0 .. $len - 1) {
  print($i, "=>", $tab->[$i], " ");
  }
print("\n");
my $k = [];
foreach my $l (0 .. $len - 1) {
  my $m = 0;
  $m = readint();
  readspaces();
  $k->[$l] = $m;
  }
my $tab2 = $k;
foreach my $i_ (0 .. $len - 1) {
  print($i_, "==>", $tab2->[$i_], " ");
  }
my $p = 0;
$p = readint();
readspaces();
my $strlen = $p;
print($strlen, "=strlen\n");
my $r = [];
foreach my $s (0 .. $strlen - 1) {
  my $u = '_';
  $u = readchar();
  $r->[$s] = $u;
  }
readspaces();
my $tab4 = $r;
foreach my $i3 (0 .. $strlen - 1) {
  my $tmpc = $tab4->[$i3];
  my $c = ord($tmpc);
  print($tmpc, ":", $c, " ");
  if ($tmpc ne ' ') {
  $c = remainder(($c - ord('a')) + 13, 26) + ord('a');
  }else{
  
  }
  $tab4->[$i3] = chr($c);
  }
foreach my $j (0 .. $strlen - 1) {
  print($tab4->[$j]);
  }

