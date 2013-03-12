#include<stdio.h>
#include<stdlib.h>

int count(void* a){ return ((int*)a)[-1]; }

/*
Tictactoe : un tictactoe avec une IA
*/
/* La structure de donnée */
struct gamestate;
typedef struct gamestate {
  int** cases;
  int firstToPlay;
  int note;
  int ended;
} gamestate;

/* Un Mouvement */
struct move;
typedef struct move {
  int x;
  int y;
} move;

/* On affiche l'état */
void print_state(struct gamestate * g){
  printf("%s", "\n|");
  {
    int y;
    for (y = 0 ; y <= 2; y++)
    {
      {
        int x;
        for (x = 0 ; x <= 2; x++)
        {
          if (g->cases[x][y] == 0)
          {
            printf("%s", " ");
          }
          else if (g->cases[x][y] == 1)
          {
            printf("%s", "O");
          }
          else
          {
            printf("%s", "X");
          }
          printf("%s", "|");
        }
      }
      if (y != 2)
      {
        printf("%s", "\n|-|-|-|\n|");
      }
    }
  }
  printf("%s", "\n");
}

/* On dit qui gagne (info stoquées dans g.ended et g.note ) */
void eval_(struct gamestate * g){
  int win = 0;
  int freecase = 0;
  {
    int y;
    for (y = 0 ; y <= 2; y++)
    {
      int col = -1;
      int lin = -1;
      {
        int x;
        for (x = 0 ; x <= 2; x++)
        {
          if (g->cases[x][y] == 0)
          {
            freecase = freecase + 1;
          }
          int colv = g->cases[x][y];
          int linv = g->cases[y][x];
          if ((col == (-1)) && (colv != 0))
          {
            col = colv;
          }
          else if (colv != col)
          {
            col = -2;
          }
          if ((lin == (-1)) && (linv != 0))
          {
            lin = linv;
          }
          else if (linv != lin)
          {
            lin = -2;
          }
        }
      }
      if (col >= 0)
      {
        win = col;
      }
      else if (lin >= 0)
      {
        win = lin;
      }
    }
  }
  {
    int x;
    for (x = 1 ; x <= 2; x++)
    {
      if (((g->cases[0][0] == x) && (g->cases[1][1] == x)) && (g->cases[2][2] == x))
      {
        win = x;
      }
      if (((g->cases[0][2] == x) && (g->cases[1][1] == x)) && (g->cases[2][0] == x))
      {
        win = x;
      }
    }
  }
  g->ended = (win != 0) || (freecase == 0);
  if (win == 1)
  {
    g->note = 1000;
  }
  else if (win == 2)
  {
    g->note = -1000;
  }
  else
  {
    g->note = 0;
  }
}

/* On applique un mouvement */
void apply_move_xy(int x, int y, struct gamestate * g){
  int player = 2;
  if (g->firstToPlay)
  {
    player = 1;
  }
  g->cases[x][y] = player;
  g->firstToPlay = !g->firstToPlay;
}

void apply_move(struct move * m, struct gamestate * g){
  apply_move_xy(m->x, m->y, g);
}

void cancel_move_xy(int x, int y, struct gamestate * g){
  g->cases[x][y] = 0;
  g->firstToPlay = !g->firstToPlay;
  g->ended = 0;
}

int can_move_xy(int x, int y, struct gamestate * g){
  return g->cases[x][y] == 0;
}

int minmax(struct gamestate * g){
  eval_(g);
  if (g->ended)
  {
    return g->note;
  }
  int maxNote = -10000;
  if (!g->firstToPlay)
  {
    maxNote = 10000;
  }
  {
    int x;
    for (x = 0 ; x <= 2; x++)
    {
      {
        int y;
        for (y = 0 ; y <= 2; y++)
        {
          if (can_move_xy(x, y, g))
          {
            apply_move_xy(x, y, g);
            int currentNote = minmax(g);
            cancel_move_xy(x, y, g);
            if ((currentNote > maxNote) == g->firstToPlay)
            {
              maxNote = currentNote;
            }
          }
        }
      }
    }
  }
  return maxNote;
}

struct move * play(struct gamestate * g){
  struct move * minMove = malloc (sizeof(minMove) );
  minMove->x=0;
  minMove->y=0;
  int minNote = 10000;
  {
    int x;
    for (x = 0 ; x <= 2; x++)
    {
      {
        int y;
        for (y = 0 ; y <= 2; y++)
        {
          if (can_move_xy(x, y, g))
          {
            apply_move_xy(x, y, g);
            int currentNote = minmax(g);
            printf("%d", x);
            printf("%s", ", ");
            printf("%d", y);
            printf("%s", ", ");
            printf("%d", currentNote);
            printf("%s", "\n");
            cancel_move_xy(x, y, g);
            if (currentNote < minNote)
            {
              minNote = currentNote;
              minMove->x = x;
              minMove->y = y;
            }
          }
        }
      }
    }
  }
  int a = minMove->x;
  printf("%d", a);
  int b = minMove->y;
  printf("%d", b);
  printf("%s", "\n");
  return minMove;
}

struct gamestate * init(){
  int d = 3;
  int* *cases = malloc( (d) * sizeof(int*) + sizeof(int));
  ((int*)cases)[0]=d;
  cases=(int**)( ((int*)cases)+1);
  {
    int i;
    for (i = 0 ; i <= d - 1; i++)
    {
      int c = 3;
      int *tab = malloc( (c) * sizeof(int) + sizeof(int));
      ((int*)tab)[0]=c;
      tab=(int*)( ((int*)tab)+1);
      {
        int j;
        for (j = 0 ; j <= c - 1; j++)
        {
          tab[j] = 0;
        }
      }
      cases[i] = tab;
    }
  }
  struct gamestate * out_ = malloc (sizeof(out_) );
  out_->cases=cases;
  out_->firstToPlay=1;
  out_->note=0;
  out_->ended=0;
  return out_;
}

int main(void){
  {
    int i;
    for (i = 0 ; i <= 1; i++)
    {
      struct gamestate * state = init();
      while (!state->ended)
      {
        print_state(state);
        apply_move(play(state), state);
        eval_(state);
        print_state(state);
        if (!state->ended)
        {
          apply_move(play(state), state);
          eval_(state);
        }
      }
      print_state(state);
      int e = state->note;
      printf("%d", e);
      printf("%s", "\n");
    }
  }
  return 0;
}

