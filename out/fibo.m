#import <Foundation/Foundation.h>
#include<stdio.h>
#include<stdlib.h>

/*
La suite de fibonaci
*/
int fibo_(int a, int b, int i){
  int out_ = 0;
  int a2 = a;
  int b2 = b;
  {
    int j;
    for (j = 0 ; j <= i + 1; j++)
    {
      out_ += a2;
      int tmp = b2;
      b2 += a2;
      a2 = tmp;
    }
  }
  return out_;
}

int main(void){
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  int a = 0;
  int b = 0;
  int i = 0;
  scanf("%d %d %d", &a, &b, &i);
  int c = fibo_(a, b, i);
  printf("%d", c);
  [pool drain];
  return 0;
}

