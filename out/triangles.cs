using System;

public class triangles
{
static bool eof;
static String buffer;
public static char readChar_(){
  if (buffer == null){
    buffer = Console.ReadLine();
  }
  if (buffer.Length == 0){
    String tmp = Console.ReadLine();
    eof = tmp == null;
    buffer = "\n"+tmp;
  }
  char c = buffer[0];
  return c;
}
public static void consommeChar(){
       readChar_();
  buffer = buffer.Substring(1);
}
public static void stdin_sep(){
  do{
    if (eof) return;
    char c = readChar_();
    if (c == ' ' || c == '\n' || c == '\t' || c == '\r'){
      consommeChar();
    }else{
      return;
    }
  } while(true);
}
public static int readInt(){
  int i = 0;
  char s = readChar_();
  int sign = 1;
  if (s == '-'){
    sign = -1;
    consommeChar();
  }
  do{
    char c = readChar_();
    if (c <= '9' && c >= '0'){
      i = i * 10 + c - '0';
      consommeChar();
    }else{
      return i * sign;
    }
  } while(true);
} 
  /* Ce code a été généré par metalang
   Il gère les entrées sorties pour un programme dynamique classique
   dans les épreuves de prologin
on le retrouve ici : http://projecteuler.net/problem=18
*/
  public static int find0(int len, int[][] tab, int[][] cache, int x, int y)
  {
    /*
	Cette fonction est récursive
	*/
    if (y == len - 1)
      return tab[y][x];
    else if (x > y)
      return -10000;
    else if (cache[y][x] != 0)
      return cache[y][x];
    int result = 0;
    int out0 = find0(len, tab, cache, x, y + 1);
    int out1 = find0(len, tab, cache, x + 1, y + 1);
    if (out0 > out1)
      result = out0 + tab[y][x];
    else
      result = out1 + tab[y][x];
    cache[y][x] = result;
    return result;
  }
  
  public static int find(int len, int[][] tab)
  {
    int[][] tab2 = new int[len][];
    for (int i = 0 ; i < len; i++)
    {
      int a = i + 1;
      int[] tab3 = new int[a];
      for (int j = 0 ; j < a; j++)
        tab3[j] = 0;
      tab2[i] = tab3;
    }
    return find0(len, tab, tab2, 0, 0);
  }
  
  
  public static void Main(String[] args)
  {
    int len = 0;
    len = readInt();
    stdin_sep();
    int[][] tab = new int[len][];
    for (int i = 0 ; i < len; i++)
    {
      int b = i + 1;
      int[] tab2 = new int[b];
      for (int j = 0 ; j < b; j++)
      {
        int tmp = 0;
        tmp = readInt();
        stdin_sep();
        tab2[j] = tmp;
      }
      tab[i] = tab2;
    }
    int c = find(len, tab);
    Console.Write(c);
    Console.Write("\n");
    for (int k = 0 ; k < len; k++)
    {
      for (int l = 0 ; l <= k; l ++)
      {
        int d = tab[k][l];
        Console.Write(d);
        Console.Write(" ");
      }
      Console.Write("\n");
    }
  }
  
}

