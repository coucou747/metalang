#include <iostream>
#include <vector>
/* lit un sudoku sur l'entrée standard */

std::vector<int> * read_sudoku() {
  int k;
  std::vector<int> *out0 = new std::vector<int>( 9 * 9 );
  for (int i = 0; i < 9 * 9; i++)
  {
    std::cin >> k >> std::skipws;
    out0->at(i) = k;
  }
  return out0;
}

/* affiche un sudoku */

void print_sudoku(std::vector<int> * sudoku0) {
  for (int y = 0; y <= 8; y ++)
  {
    for (int x = 0; x <= 8; x ++)
    {
      std::cout << sudoku0->at(x + y * 9) << " ";
      if (x % 3 == 2)
        std::cout << " ";
    }
    std::cout << "\n";
    if (y % 3 == 2)
      std::cout << "\n";
  }
  std::cout << "\n";
}

/* dit si les variables sont toutes différentes */
/* dit si les variables sont toutes différentes */
/* dit si le sudoku est terminé de remplir */

bool sudoku_done(std::vector<int> * s) {
  for (int i = 0; i <= 80; i ++)
    if (s->at(i) == 0)
    return false;
  return true;
}

/* dit si il y a une erreur dans le sudoku */

bool sudoku_error(std::vector<int> * s) {
  bool out1 = false;
  for (int x = 0; x <= 8; x ++)
    out1 =
    out1 || s->at(x) != 0 && s->at(x) == s->at(x + 9) || s->at(x) != 0 && s->at(x) == s->at(x + 9 * 2) || s->at(x + 9) != 0 && s->at(x + 9) == s->at(x + 9 * 2) || s->at(x) != 0 && s->at(x) == s->at(x + 9 * 3) || s->at(x + 9) != 0 && s->at(x + 9) == s->at(x + 9 * 3) || s->at(x + 9 * 2) != 0 && s->at(x + 9 * 2) == s->at(x + 9 * 3) || s->at(x) != 0 && s->at(x) == s->at(x + 9 * 4) || s->at(x + 9) != 0 && s->at(x + 9) == s->at(x + 9 * 4) || s->at(x + 9 * 2) != 0 && s->at(x + 9 * 2) == s->at(x + 9 * 4) || s->at(x + 9 * 3) != 0 && s->at(x + 9 * 3) == s->at(x + 9 * 4) || s->at(x) != 0 && s->at(x) == s->at(x + 9 * 5) || s->at(x + 9) != 0 && s->at(x + 9) == s->at(x + 9 * 5) || s->at(x + 9 * 2) != 0 && s->at(x + 9 * 2) == s->at(x + 9 * 5) || s->at(x + 9 * 3) != 0 && s->at(x + 9 * 3) == s->at(x + 9 * 5) || s->at(x + 9 * 4) != 0 && s->at(x + 9 * 4) == s->at(x + 9 * 5) || s->at(x) != 0 && s->at(x) == s->at(x + 9 * 6) || s->at(x + 9) != 0 && s->at(x + 9) == s->at(x + 9 * 6) || s->at(x + 9 * 2) != 0 && s->at(x + 9 * 2) == s->at(x + 9 * 6) || s->at(x + 9 * 3) != 0 && s->at(x + 9 * 3) == s->at(x + 9 * 6) || s->at(x + 9 * 4) != 0 && s->at(x + 9 * 4) == s->at(x + 9 * 6) || s->at(x + 9 * 5) != 0 && s->at(x + 9 * 5) == s->at(x + 9 * 6) || s->at(x) != 0 && s->at(x) == s->at(x + 9 * 7) || s->at(x + 9) != 0 && s->at(x + 9) == s->at(x + 9 * 7) || s->at(x + 9 * 2) != 0 && s->at(x + 9 * 2) == s->at(x + 9 * 7) || s->at(x + 9 * 3) != 0 && s->at(x + 9 * 3) == s->at(x + 9 * 7) || s->at(x + 9 * 4) != 0 && s->at(x + 9 * 4) == s->at(x + 9 * 7) || s->at(x + 9 * 5) != 0 && s->at(x + 9 * 5) == s->at(x + 9 * 7) || s->at(x + 9 * 6) != 0 && s->at(x + 9 * 6) == s->at(x + 9 * 7) || s->at(x) != 0 && s->at(x) == s->at(x + 9 * 8) || s->at(x + 9) != 0 && s->at(x + 9) == s->at(x + 9 * 8) || s->at(x + 9 * 2) != 0 && s->at(x + 9 * 2) == s->at(x + 9 * 8) || s->at(x + 9 * 3) != 0 && s->at(x + 9 * 3) == s->at(x + 9 * 8) || s->at(x + 9 * 4) != 0 && s->at(x + 9 * 4) == s->at(x + 9 * 8) || s->at(x + 9 * 5) != 0 && s->at(x + 9 * 5) == s->at(x + 9 * 8) || s->at(x + 9 * 6) != 0 && s->at(x + 9 * 6) == s->at(x + 9 * 8) || s->at(x + 9 * 7) != 0 && s->at(x + 9 * 7) == s->at(x + 9 * 8);
  bool out2 = false;
  for (int x = 0; x <= 8; x ++)
    out2 =
    out2 || s->at(x * 9) != 0 && s->at(x * 9) == s->at(x * 9 + 1) || s->at(x * 9) != 0 && s->at(x * 9) == s->at(x * 9 + 2) || s->at(x * 9 + 1) != 0 && s->at(x * 9 + 1) == s->at(x * 9 + 2) || s->at(x * 9) != 0 && s->at(x * 9) == s->at(x * 9 + 3) || s->at(x * 9 + 1) != 0 && s->at(x * 9 + 1) == s->at(x * 9 + 3) || s->at(x * 9 + 2) != 0 && s->at(x * 9 + 2) == s->at(x * 9 + 3) || s->at(x * 9) != 0 && s->at(x * 9) == s->at(x * 9 + 4) || s->at(x * 9 + 1) != 0 && s->at(x * 9 + 1) == s->at(x * 9 + 4) || s->at(x * 9 + 2) != 0 && s->at(x * 9 + 2) == s->at(x * 9 + 4) || s->at(x * 9 + 3) != 0 && s->at(x * 9 + 3) == s->at(x * 9 + 4) || s->at(x * 9) != 0 && s->at(x * 9) == s->at(x * 9 + 5) || s->at(x * 9 + 1) != 0 && s->at(x * 9 + 1) == s->at(x * 9 + 5) || s->at(x * 9 + 2) != 0 && s->at(x * 9 + 2) == s->at(x * 9 + 5) || s->at(x * 9 + 3) != 0 && s->at(x * 9 + 3) == s->at(x * 9 + 5) || s->at(x * 9 + 4) != 0 && s->at(x * 9 + 4) == s->at(x * 9 + 5) || s->at(x * 9) != 0 && s->at(x * 9) == s->at(x * 9 + 6) || s->at(x * 9 + 1) != 0 && s->at(x * 9 + 1) == s->at(x * 9 + 6) || s->at(x * 9 + 2) != 0 && s->at(x * 9 + 2) == s->at(x * 9 + 6) || s->at(x * 9 + 3) != 0 && s->at(x * 9 + 3) == s->at(x * 9 + 6) || s->at(x * 9 + 4) != 0 && s->at(x * 9 + 4) == s->at(x * 9 + 6) || s->at(x * 9 + 5) != 0 && s->at(x * 9 + 5) == s->at(x * 9 + 6) || s->at(x * 9) != 0 && s->at(x * 9) == s->at(x * 9 + 7) || s->at(x * 9 + 1) != 0 && s->at(x * 9 + 1) == s->at(x * 9 + 7) || s->at(x * 9 + 2) != 0 && s->at(x * 9 + 2) == s->at(x * 9 + 7) || s->at(x * 9 + 3) != 0 && s->at(x * 9 + 3) == s->at(x * 9 + 7) || s->at(x * 9 + 4) != 0 && s->at(x * 9 + 4) == s->at(x * 9 + 7) || s->at(x * 9 + 5) != 0 && s->at(x * 9 + 5) == s->at(x * 9 + 7) || s->at(x * 9 + 6) != 0 && s->at(x * 9 + 6) == s->at(x * 9 + 7) || s->at(x * 9) != 0 && s->at(x * 9) == s->at(x * 9 + 8) || s->at(x * 9 + 1) != 0 && s->at(x * 9 + 1) == s->at(x * 9 + 8) || s->at(x * 9 + 2) != 0 && s->at(x * 9 + 2) == s->at(x * 9 + 8) || s->at(x * 9 + 3) != 0 && s->at(x * 9 + 3) == s->at(x * 9 + 8) || s->at(x * 9 + 4) != 0 && s->at(x * 9 + 4) == s->at(x * 9 + 8) || s->at(x * 9 + 5) != 0 && s->at(x * 9 + 5) == s->at(x * 9 + 8) || s->at(x * 9 + 6) != 0 && s->at(x * 9 + 6) == s->at(x * 9 + 8) || s->at(x * 9 + 7) != 0 && s->at(x * 9 + 7) == s->at(x * 9 + 8);
  bool out3 = false;
  for (int x = 0; x <= 8; x ++)
    out3 =
    out3 || s->at((x % 3) * 3 * 9 + (x / 3) * 3) != 0 && s->at((x % 3) * 3 * 9 + (x / 3) * 3) == s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 1) || s->at((x % 3) * 3 * 9 + (x / 3) * 3) != 0 && s->at((x % 3) * 3 * 9 + (x / 3) * 3) == s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 2) || s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 1) != 0 && s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 1) == s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 2) || s->at((x % 3) * 3 * 9 + (x / 3) * 3) != 0 && s->at((x % 3) * 3 * 9 + (x / 3) * 3) == s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3) || s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 1) != 0 && s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 1) == s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3) || s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 2) != 0 && s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 2) == s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3) || s->at((x % 3) * 3 * 9 + (x / 3) * 3) != 0 && s->at((x % 3) * 3 * 9 + (x / 3) * 3) == s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3 + 1) || s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 1) != 0 && s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 1) == s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3 + 1) || s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 2) != 0 && s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 2) == s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3 + 1) || s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3) != 0 && s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3) == s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3 + 1) || s->at((x % 3) * 3 * 9 + (x / 3) * 3) != 0 && s->at((x % 3) * 3 * 9 + (x / 3) * 3) == s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3 + 2) || s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 1) != 0 && s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 1) == s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3 + 2) || s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 2) != 0 && s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 2) == s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3 + 2) || s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3) != 0 && s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3) == s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3 + 2) || s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3 + 1) != 0 && s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3 + 1) == s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3 + 2) || s->at((x % 3) * 3 * 9 + (x / 3) * 3) != 0 && s->at((x % 3) * 3 * 9 + (x / 3) * 3) == s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3) || s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 1) != 0 && s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 1) == s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3) || s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 2) != 0 && s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 2) == s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3) || s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3) != 0 && s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3) == s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3) || s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3 + 1) != 0 && s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3 + 1) == s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3) || s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3 + 2) != 0 && s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3 + 2) == s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3) || s->at((x % 3) * 3 * 9 + (x / 3) * 3) != 0 && s->at((x % 3) * 3 * 9 + (x / 3) * 3) == s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3 + 1) || s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 1) != 0 && s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 1) == s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3 + 1) || s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 2) != 0 && s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 2) == s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3 + 1) || s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3) != 0 && s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3) == s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3 + 1) || s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3 + 1) != 0 && s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3 + 1) == s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3 + 1) || s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3 + 2) != 0 && s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3 + 2) == s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3 + 1) || s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3) != 0 && s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3) == s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3 + 1) || s->at((x % 3) * 3 * 9 + (x / 3) * 3) != 0 && s->at((x % 3) * 3 * 9 + (x / 3) * 3) == s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3 + 2) || s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 1) != 0 && s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 1) == s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3 + 2) || s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 2) != 0 && s->at((x % 3) * 3 * 9 + (x / 3) * 3 + 2) == s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3 + 2) || s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3) != 0 && s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3) == s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3 + 2) || s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3 + 1) != 0 && s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3 + 1) == s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3 + 2) || s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3 + 2) != 0 && s->at(((x % 3) * 3 + 1) * 9 + (x / 3) * 3 + 2) == s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3 + 2) || s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3) != 0 && s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3) == s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3 + 2) || s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3 + 1) != 0 && s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3 + 1) == s->at(((x % 3) * 3 + 2) * 9 + (x / 3) * 3 + 2);
  return out1 || out2 || out3;
}

/* résout le sudoku*/

bool solve(std::vector<int> * sudoku0) {
  if (sudoku_error(sudoku0))
    return false;
  if (sudoku_done(sudoku0))
    return true;
  for (int i = 0; i <= 80; i ++)
    if (sudoku0->at(i) == 0)
  {
    for (int p = 1; p <= 9; p ++)
    {
      sudoku0->at(i) = p;
      if (solve(sudoku0))
        return true;
    }
    sudoku0->at(i) = 0;
    return false;
  }
  return false;
}


int main() {
  std::vector<int> * sudoku0 = read_sudoku();
  print_sudoku(sudoku0);
  if (solve(sudoku0))
    print_sudoku(sudoku0);
  else
    std::cout << "no solution\n";
}

