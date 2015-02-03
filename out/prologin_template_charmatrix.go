package main
import "fmt"
import "os"
import "bufio"
var reader *bufio.Reader

func skip() {
  var c byte
  fmt.Fscanf(reader, "%c", &c)
  if c == '\n' || c == ' ' {
    skip()
  } else {
    reader.UnreadByte()
  }
}

func programme_candidat(tableau [][]byte, taille_x int, taille_y int) int{
  var out0 int = 0
  for i := 0 ; i <= taille_y - 1; i++ {
    for j := 0 ; j <= taille_x - 1; j++ {
        out0 += (int)(tableau[i][j]) * (i + j * 2);
          fmt.Printf("%c", tableau[i][j]);
      }
      fmt.Printf("--\n");
  }
  return out0
}

func main() {
  reader = bufio.NewReader(os.Stdin)
  var taille_x int
  fmt.Fscanf(reader, "%d", &taille_x)
  skip()
  var taille_y int
  fmt.Fscanf(reader, "%d", &taille_y)
  skip()
  var l [][]byte = make([][]byte, taille_y)
  for m := 0 ; m <= taille_y - 1; m++ {
    var r []byte = make([]byte, taille_x)
      for p := 0 ; p <= taille_x - 1; p++ {
        fmt.Fscanf(reader, "%c", &r[p])
      }
      skip()
      l[m] = r;
  }
  var tableau [][]byte = l
  fmt.Printf("%d\n", programme_candidat(tableau, taille_x, taille_y));
}

