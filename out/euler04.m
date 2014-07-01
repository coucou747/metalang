#import <Foundation/Foundation.h>
#include<stdio.h>
#include<stdlib.h>

int max2(int a, int b){
  if (a > b)
    return a;
  return b;
}

/*

(a + b * 10 + c * 100) * (d + e * 10 + f * 100) =
a * d + a * e * 10 + a * f * 100 +
10 * (b * d + b * e * 10 + b * f * 100)+
100 * (c * d + c * e * 10 + c * f * 100) =

a * d       + a * e * 10   + a * f * 100 +
b * d * 10  + b * e * 100  + b * f * 1000 +
c * d * 100 + c * e * 1000 + c * f * 10000 =

a * d +
10 * ( a * e + b * d) +
100 * (a * f + b * e + c * d) +
(c * e + b * f) * 1000 +
c * f * 10000

*/
int chiffre(int c, int m){
  if (c == 0)
    return m % 10;
  else
    return chiffre(c - 1, m / 10);
}

int main(void){
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  int m = 1;
  {
    int a;
    for (a = 0 ; a <= 9; a++)
      {
      int f;
      for (f = 1 ; f <= 9; f++)
        {
        int d;
        for (d = 0 ; d <= 9; d++)
          {
          int c;
          for (c = 1 ; c <= 9; c++)
            {
            int b;
            for (b = 0 ; b <= 9; b++)
              {
              int e;
              for (e = 0 ; e <= 9; e++)
              {
                int mul = a * d + 10 * (a * e + b * d) + 100 * (a * f + b * e + c * d) + 1000 * (c * e + b * f) + 10000 * c * f;
                if (chiffre(0, mul) == chiffre(5, mul) && chiffre(1, mul) == chiffre(4, mul) && chiffre(2, mul) == chiffre(3, mul))
                  m = max2(mul, m);
              }
            }
          }
        }
      }
    }
  }
  printf("%d\n", m);
  [pool drain];
  return 0;
}

