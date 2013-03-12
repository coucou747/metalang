#include <cstdlib>
#include <cstdio>
#include <iostream>
#include <vector>
int pathfind_aux(std::vector<int >& cache, std::vector<int >& tab, int len, int pos){
  if (pos >= (len - 1))
  {
    return 0;
  }
  else if (cache.at(pos) != (-1))
  {
    return cache.at(pos);
  }
  else
  {
    cache.at(pos) = len * 2;
    int posval = pathfind_aux(cache, tab, len, tab.at(pos));
    int oneval = pathfind_aux(cache, tab, len, pos + 1);
    int out_ = 0;
    if (posval < oneval)
    {
      out_ = 1 + posval;
    }
    else
    {
      out_ = 1 + oneval;
    }
    cache.at(pos) = out_;
    return out_;
  }
}

int pathfind(std::vector<int >& tab, int len){
  std::vector<int > cache( len );
  for (int i = 0 ; i <= len - 1; i ++)
  {
    cache.at(i) = -1;
  }
  return pathfind_aux(cache, tab, len, 0);
}


int main(void){
  int len = 0;
  scanf("%d", &len);
  scanf("%*[ \t\r\n]c", 0);
  std::vector<int > tab( len );
  for (int i = 0 ; i <= len - 1; i ++)
  {
    int tmp = 0;
    scanf("%d", &tmp);
    scanf("%*[ \t\r\n]c", 0);
    tab.at(i) = tmp;
  }
  int result = pathfind(tab, len);
  printf("%d", result);
  return 0;
}
