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

sub programme_candidat{
  my($tableau,
  $taille) = @_;
  my $out_ = 0;
  foreach my $i (0 .. $taille - 1) {
    $out_ = $out_ + ord($tableau->[$i])
    *
    $i;
    print($tableau->[$i]);
    }
  print("--\n");
  return $out_;
}

my $b = 0;
$b = readint();
readspaces();
my $taille = $b;
my $d = [];
foreach my $e (0 .. $taille - 1) {
  my $f = '_';
  $f = readchar();
  $d->[$e] = $f;
  }
readspaces();
my $tableau = $d;
print(programme_candidat($tableau, $taille), "\n");

