#include<stdio.h>
#include<stdlib.h>

/*
  Ce test a été généré par Metalang.
*/
int result(int len, int* tab){
  int *tab2 = malloc( len * sizeof(int));
  {
    int i;
    for (i = 0 ; i < len; i++)
      tab2[i] = 0;
  }
  {
    int i1;
    for (i1 = 0 ; i1 < len; i1++)
      tab2[tab[i1]] = 1;
  }
  {
    int i2;
    for (i2 = 0 ; i2 < len; i2++)
      if (!tab2[i2])
      return i2;
  }
  return -1;
}

int main(void){
  int b = 0;
  scanf("%d ", &b);
  int len = b;
  printf("%d\n", len);
  int *d = malloc( len * sizeof(int));
  {
    int e;
    for (e = 0 ; e < len; e++)
    {
      int f = 0;
      scanf("%d ", &f);
      d[e] = f;
    }
  }
  int* tab = d;
  printf("%d", result(len, tab));
  return 0;
}


