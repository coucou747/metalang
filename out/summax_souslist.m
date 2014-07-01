#import <Foundation/Foundation.h>
#include<stdio.h>
#include<stdlib.h>

int summax(int* lst, int len){
  int current = 0;
  int max_ = 0;
  {
    int i;
    for (i = 0 ; i < len; i++)
    {
      current += lst[i];
      if (current < 0)
        current = 0;
      if (max_ < current)
        max_ = current;
    }
  }
  return max_;
}

int main(void){
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  int len = 0;
  scanf("%d ", &len);
  int *tab = malloc( len * sizeof(int));
  {
    int i;
    for (i = 0 ; i < len; i++)
    {
      int tmp = 0;
      scanf("%d ", &tmp);
      tab[i] = tmp;
    }
  }
  int result = summax(tab, len);
  printf("%d", result);
  [pool drain];
  return 0;
}

