#include<stdio.h>
#include<stdlib.h>

int programme_candidat(char* tableau, int taille){
  int out_ = 0;
  {
    int i;
    for (i = 0 ; i < taille; i++)
    {
      out_ += (int)(tableau[i]) * i;
      printf("%c", tableau[i]);
    }
  }
  printf("--\n");
  return out_;
}

int main(void){
  int b = 0;
  scanf("%d ", &b);
  int taille = b;
  char *d = malloc( taille * sizeof(char));
  {
    int e;
    for (e = 0 ; e < taille; e++)
    {
      char f = '_';
      scanf("%c", &f);
      d[e] = f;
    }
  }
  scanf(" ");
  char* tableau = d;
  printf("%d\n", programme_candidat(tableau, taille));
  return 0;
}


