#include <iostream>
#include <vector>

template <typename T> std::vector<std::vector<T>> read_matrix(int l, int c) {
    std::vector<std::vector<T>> matrix(l, std::vector<T>(c));
    for (std::vector<T>& line : matrix)
        for (T& elem : line)
            std::cin >> elem;
    return matrix;
}

int main(void) {
    int len;
    std::cin >> len;
    std::cout << len << "=len\n";
    std::vector<int> tab1( len );
    for (int a = 0; a < len; a += 1)
    {
        std::cin >> tab1[a];
    }
    for (int i = 0; i < len; i += 1)
        std::cout << i << "=>" << tab1[i] << "\n";
    std::cin >> len;
    std::vector<std::vector<int>> tab2 = read_matrix<int>(len - 1, len);
    for (int i = 0; i < len - 1; i += 1)
    {
        for (int j = 0; j < len; j += 1)
            std::cout << tab2[i][j] << " ";
        std::cout << "\n";
    }
    return 0;
}
