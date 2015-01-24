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
func main() {
  reader = bufio.NewReader(os.Stdin)
  var c []int = make([]int, 2)
  for d := 0 ; d <= 2 - 1; d++ {
    fmt.Fscanf(reader, "%d", &c[d])
      skip()
  }
  fmt.Printf("%d - %d\n", c[0], c[1]);
}

