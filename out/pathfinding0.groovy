import groovy.transform.Field
import java.util.*

int pathfind_aux(int[][] cache, char[][] tab, int x, int y, int posX, int posY)
{
  if (posX == x - 1 && posY == y - 1)
    return 0
  else if (posX < 0 || posY < 0 || posX >= x || posY >= y)
    return x * y * 10
  else if (tab[posY][posX] == (char)'#')
    return x * y * 10
  else if (cache[posY][posX] != -1)
    return cache[posY][posX]
  else
  {
    cache[posY][posX] = x * y * 10
    int val1 = pathfind_aux(cache, tab, x, y, posX + 1, posY)
    int val2 = pathfind_aux(cache, tab, x, y, posX - 1, posY)
    int val3 = pathfind_aux(cache, tab, x, y, posX, posY - 1)
    int val4 = pathfind_aux(cache, tab, x, y, posX, posY + 1)
    int out0 = 1 + Math.min(Math.min(Math.min(val1, val2), val3), val4)
    cache[posY][posX] = out0
    return out0
  }
}

int pathfind(char[][] tab, int x, int y)
{
  int[][] cache = new int[y][]
  for (int i = 0 ; i < y; i++)
  {
    int[] tmp = new int[x]
    for (int j = 0 ; j < x; j++)
    {
      print(tab[i][j])
      tmp[j] = -1
    }
    print("\n")
    cache[i] = tmp
  }
  return pathfind_aux(cache, tab, x, y, 0, 0)
}


@Field Scanner scanner = new Scanner(System.in)
int x = Integer.parseInt(scanner.nextLine())
int y = Integer.parseInt(scanner.nextLine())
System.out.printf("%s %s\n", x, y);
char[][] e = new char[y][]
for (int f = 0 ; f < y; f++)
  e[f] = scanner.nextLine().toCharArray()
char[][] tab = e
int result = pathfind(tab, x, y)
print(result)
