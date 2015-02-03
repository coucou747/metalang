#include <iostream>
#include <vector>
std::vector<char> *getline(){
  if (std::cin.flags() & std::ios_base::skipws){
    char c = std::cin.peek();
    if (c == '\n' || c == ' ') std::cin.ignore();
    std::cin.unsetf(std::ios::skipws);
  }
  std::string line;
  std::getline(std::cin, line);
  std::vector<char> *c = new std::vector<char>(line.begin(), line.end());
  return c;
}
/*
Ce test permet de vérifier si les différents backends pour les langages implémentent bien
read int, read char et skip
*/

int main(){
  int strlen, len;
  std::cin >> len >> std::skipws;
  std::cout << len << "=len\n";
  std::vector<int > *tab = new std::vector<int>( len );
  for (int f = 0 ; f < len; f++)
  {
    std::cin >> tab->at(f) >> std::skipws;
  }
  for (int i = 0 ; i < len; i++)
  {
    std::cout << i << "=>" << tab->at(i) << " ";
  }
  std::cout << "\n";
  std::vector<int > *tab2 = new std::vector<int>( len );
  for (int l = 0 ; l < len; l++)
  {
    std::cin >> tab2->at(l) >> std::skipws;
  }
  for (int i_ = 0 ; i_ < len; i_++)
  {
    std::cout << i_ << "==>" << tab2->at(i_) << " ";
  }
  std::cin >> strlen >> std::skipws;
  std::cout << strlen << "=strlen\n";
  std::vector<char> * tab4 = getline();
  for (int i3 = 0 ; i3 < strlen; i3++)
  {
    char tmpc = tab4->at(i3);
    int c = (int)(tmpc);
    std::cout << tmpc << ":" << c << " ";
    if (tmpc != ' ')
      c = ((c - (int)('a')) + 13) % 26 + (int)('a');
    tab4->at(i3) = (char)(c);
  }
  for (int j = 0 ; j < strlen; j++)
    std::cout << tab4->at(j);
  return 0;
}

