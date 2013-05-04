#include <cstdlib>
#include <cstdio>
#include <iostream>
#include <vector>


/*
Ce test effectue un rot13 sur une chaine lue en entrée
*/

int main(void){
  int strlen = 0;
  scanf("%d", &strlen);
  scanf("%*[ \t\r\n]c", 0);
  std::vector<char > tab4( strlen );
  for (int toto = 0 ; toto < strlen; toto++)
  {
    char tmpc = '_';
    scanf("%c", &tmpc);
    int c = tmpc;
    if (tmpc != ' ')
      c = ((c - 'a') + 13) % 26 + 'a';
    tab4.at(toto) = c;
  }
  for (int j = 0 ; j < strlen; j++)
  {
    char d = tab4.at(j);
    printf("%c", d);
  }
  return 0;
}
