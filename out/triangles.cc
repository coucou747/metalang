#include <cstdlib>
#include <cstdio>
#include <iostream>
#include <vector>
/* Ce code a été généré par metalang
   Il gère les entrées sorties pour un programme dynamique classique
   dans les épreuves de prologin
*/
int find0(int len, std::vector<std::vector<int > >& tab, std::vector<std::vector<int > >& cache, int x, int y){
  /*
	Cette fonction est récursive
	*/
  if (y == (len - 1))
  {
    return tab.at(y).at(x);
  }
  else if (x > y)
  {
    return 100000;
  }
  else if (cache.at(y).at(x) != 0)
  {
    return cache.at(y).at(x);
  }
  int result = 0;
  int out0 = find0(len, tab, cache, x, y + 1);
  int out1 = find0(len, tab, cache, x + 1, y + 1);
  if (out0 < out1)
  {
    result = out0 + tab.at(y).at(x);
  }
  else
  {
    result = out1 + tab.at(y).at(x);
  }
  cache.at(y).at(y) = result;
  return result;
}

int find(int len, std::vector<std::vector<int > >& tab){
  std::vector<std::vector<int > > tab2( len );
  for (int i = 0 ; i <= len - 1; i ++)
  {
    int s = i + 1;
    std::vector<int > tab3( s );
    for (int j = 0 ; j <= s - 1; j ++)
    {
      tab3.at(j) = 0;
    }
    tab2.at(i) = tab3;
  }
  return find0(len, tab, tab2, 0, 0);
}


int main(void){
  int len = 0;
  scanf("%d", &len);
  scanf("%*[ \t\r\n]c", 0);
  std::vector<std::vector<int > > tab( len );
  for (int i = 0 ; i <= len - 1; i ++)
  {
    int t = i + 1;
    std::vector<int > tab2( t );
    for (int j = 0 ; j <= t - 1; j ++)
    {
      int tmp = 0;
      scanf("%d", &tmp);
      scanf("%*[ \t\r\n]c", 0);
      tab2.at(j) = tmp;
    }
    tab.at(i) = tab2;
  }
  int u = find(len, tab);
  printf("%d", u);
  for (int v = 0 ; v <= (tab.size()) - 1; v ++)
  {
    std::vector<int > w = tab.at(v);
    for (int z = 0 ; z <= (w.size()) - 1; z ++)
    {
      printf("%d", w.at(z));
    }
  }
  return 0;
}
