#include <iostream>
#include <vector>
std::vector<char> getline(){
  if (std::cin.flags() & std::ios_base::skipws){
    std::cin.ignore();
    std::cin.unsetf(std::ios::skipws);
  }
  std::string line;
  std::getline(std::cin, line);
  std::vector<char> c(line.begin(), line.end());
  return c;
}
int read_int(){
  int out_ = 0;
  std::cin >> out_ >> std::skipws;
  return out_;
}

std::vector<char > read_char_line(int n){
  return getline();
}

int programme_candidat(std::vector<char >& tableau, int taille){
  int out_ = 0;
  for (int i = 0 ; i < taille; i++)
  {
    out_ += tableau.at(i) * i;
    char a = tableau.at(i);
    std::cout << a;
  }
  std::cout << "--\n";
  return out_;
}


int main(){
  int taille = read_int();
  std::vector<char > tableau = read_char_line(taille);
  int b = programme_candidat(tableau, taille);
  std::cout << b << "\n";
  return 0;
}

