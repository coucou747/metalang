#import <Foundation/Foundation.h>
#include<stdio.h>
#include<stdlib.h>


int max2_(int a, int b) {
    if (a > b)
        return a;
    else
        return b;
}


int min2_(int a, int b) {
    if (a < b)
        return a;
    else
        return b;
}

@interface bigint : NSObject
{
  @public int bigint_sign;
  @public int bigint_len;
  @public int* bigint_chiffres;
}
@end
@implementation bigint 
@end


bigint * read_bigint(int len) {
    int i, j;
    char c;
    int *chiffres = calloc(len, sizeof(int));
    for (j = 0; j < len; j++)
    {
        scanf("%c", &c);
        chiffres[j] = (int)(c);
    }
    for (i = 0; i <= (len - 1) / 2; i++)
    {
        int tmp = chiffres[i];
        chiffres[i] = chiffres[len - 1 - i];
        chiffres[len - 1 - i] = tmp;
    }
    bigint * e = [bigint alloc];
    e->bigint_sign = 1;
    e->bigint_len = len;
    e->bigint_chiffres = chiffres;
    return e;
}


void print_bigint(bigint * a) {
    int i;
    if (!a->bigint_sign)
        printf("%c", '-');
    for (i = 0; i < a->bigint_len; i++)
        printf("%d", a->bigint_chiffres[a->bigint_len - 1 - i]);
}


int bigint_eq(bigint * a, bigint * b) {
    int i;
    /* Renvoie vrai si a = b */
    if (a->bigint_sign != b->bigint_sign)
        return 0;
    else if (a->bigint_len != b->bigint_len)
        return 0;
    else
    {
        for (i = 0; i < a->bigint_len; i++)
            if (a->bigint_chiffres[i] != b->bigint_chiffres[i])
                return 0;
        return 1;
    }
}


int bigint_gt(bigint * a, bigint * b) {
    int i;
    /* Renvoie vrai si a > b */
    if (a->bigint_sign && !b->bigint_sign)
        return 1;
    else if (!a->bigint_sign && b->bigint_sign)
        return 0;
    else
    {
        if (a->bigint_len > b->bigint_len)
            return a->bigint_sign;
        else if (a->bigint_len < b->bigint_len)
            return !a->bigint_sign;
        else
            for (i = 0; i < a->bigint_len; i++)
            {
                int j = a->bigint_len - 1 - i;
                if (a->bigint_chiffres[j] > b->bigint_chiffres[j])
                    return a->bigint_sign;
                else if (a->bigint_chiffres[j] < b->bigint_chiffres[j])
                    return !a->bigint_sign;
            }
        return 1;
    }
}


int bigint_lt(bigint * a, bigint * b) {
    return !bigint_gt(a, b);
}


bigint * add_bigint_positif(bigint * a, bigint * b) {
    int i;
    /* Une addition ou on en a rien a faire des signes */
    int len = max2_(a->bigint_len, b->bigint_len) + 1;
    int retenue = 0;
    int *chiffres = calloc(len, sizeof(int));
    for (i = 0; i < len; i++)
    {
        int tmp = retenue;
        if (i < a->bigint_len)
            tmp += a->bigint_chiffres[i];
        if (i < b->bigint_len)
            tmp += b->bigint_chiffres[i];
        retenue = tmp / 10;
        chiffres[i] = tmp % 10;
    }
    while (len > 0 && chiffres[len - 1] == 0)
        len--;
    bigint * f = [bigint alloc];
    f->bigint_sign = 1;
    f->bigint_len = len;
    f->bigint_chiffres = chiffres;
    return f;
}


bigint * sub_bigint_positif(bigint * a, bigint * b) {
    int i;
    /* Une soustraction ou on en a rien a faire des signes
Pr??-requis : a > b
*/
    int len = a->bigint_len;
    int retenue = 0;
    int *chiffres = calloc(len, sizeof(int));
    for (i = 0; i < len; i++)
    {
        int tmp = retenue + a->bigint_chiffres[i];
        if (i < b->bigint_len)
            tmp -= b->bigint_chiffres[i];
        if (tmp < 0)
        {
            tmp += 10;
            retenue = -1;
        }
        else
            retenue = 0;
        chiffres[i] = tmp;
    }
    while (len > 0 && chiffres[len - 1] == 0)
        len--;
    bigint * g = [bigint alloc];
    g->bigint_sign = 1;
    g->bigint_len = len;
    g->bigint_chiffres = chiffres;
    return g;
}


bigint * neg_bigint(bigint * a) {
    bigint * h = [bigint alloc];
    h->bigint_sign = !a->bigint_sign;
    h->bigint_len = a->bigint_len;
    h->bigint_chiffres = a->bigint_chiffres;
    return h;
}


bigint * add_bigint(bigint * a, bigint * b) {
    if (a->bigint_sign == b->bigint_sign)
        if (a->bigint_sign)
            return add_bigint_positif(a, b);
        else
            return neg_bigint(add_bigint_positif(a, b));
    else if (a->bigint_sign)
    {
        /* a positif, b negatif */
        if (bigint_gt(a, neg_bigint(b)))
            return sub_bigint_positif(a, b);
        else
            return neg_bigint(sub_bigint_positif(b, a));
    }
    else
        /* a negatif, b positif */
        if (bigint_gt(neg_bigint(a), b))
            return neg_bigint(sub_bigint_positif(a, b));
        else
            return sub_bigint_positif(b, a);
}


bigint * sub_bigint(bigint * a, bigint * b) {
    return add_bigint(a, neg_bigint(b));
}


bigint * mul_bigint_cp(bigint * a, bigint * b) {
    int l, i, j, k;
    /* Cet algorithm est quadratique.
C'est le m??me que celui qu'on enseigne aux enfants en CP.
D'ou le nom de la fonction. */
    int len = a->bigint_len + b->bigint_len + 1;
    int *chiffres = calloc(len, sizeof(int));
    for (k = 0; k < len; k++)
        chiffres[k] = 0;
    for (i = 0; i < a->bigint_len; i++)
    {
        int retenue = 0;
        for (j = 0; j < b->bigint_len; j++)
        {
            chiffres[i + j] += retenue + b->bigint_chiffres[j] * a->bigint_chiffres[i];
            retenue = chiffres[i + j] / 10;
            chiffres[i + j] = chiffres[i + j] % 10;
        }
        chiffres[i + b->bigint_len] += retenue;
    }
    chiffres[a->bigint_len + b->bigint_len] = chiffres[a->bigint_len + b->bigint_len - 1] / 10;
    chiffres[a->bigint_len + b->bigint_len - 1] = chiffres[a->bigint_len + b->bigint_len - 1] % 10;
    for (l = 0; l < 3; l++)
        if (len != 0 && chiffres[len - 1] == 0)
            len--;
    bigint * m = [bigint alloc];
    m->bigint_sign = a->bigint_sign == b->bigint_sign;
    m->bigint_len = len;
    m->bigint_chiffres = chiffres;
    return m;
}


bigint * bigint_premiers_chiffres(bigint * a, int i) {
    int len = min2_(i, a->bigint_len);
    while (len != 0 && a->bigint_chiffres[len - 1] == 0)
        len--;
    bigint * o = [bigint alloc];
    o->bigint_sign = a->bigint_sign;
    o->bigint_len = len;
    o->bigint_chiffres = a->bigint_chiffres;
    return o;
}


bigint * bigint_shift(bigint * a, int i) {
    int k;
    int *chiffres = calloc(a->bigint_len + i, sizeof(int));
    for (k = 0; k < a->bigint_len + i; k++)
        if (k >= i)
            chiffres[k] = a->bigint_chiffres[k - i];
        else
            chiffres[k] = 0;
    bigint * p = [bigint alloc];
    p->bigint_sign = a->bigint_sign;
    p->bigint_len = a->bigint_len + i;
    p->bigint_chiffres = chiffres;
    return p;
}


bigint * mul_bigint(bigint * aa, bigint * bb) {
    if (aa->bigint_len == 0)
        return aa;
    else if (bb->bigint_len == 0)
        return bb;
    else if (aa->bigint_len < 3 || bb->bigint_len < 3)
        return mul_bigint_cp(aa, bb);
    /* Algorithme de Karatsuba */
    int split = min2_(aa->bigint_len, bb->bigint_len) / 2;
    bigint * a = bigint_shift(aa, -split);
    bigint * b = bigint_premiers_chiffres(aa, split);
    bigint * c = bigint_shift(bb, -split);
    bigint * d = bigint_premiers_chiffres(bb, split);
    bigint * amoinsb = sub_bigint(a, b);
    bigint * cmoinsd = sub_bigint(c, d);
    bigint * ac = mul_bigint(a, c);
    bigint * bd = mul_bigint(b, d);
    bigint * amoinsbcmoinsd = mul_bigint(amoinsb, cmoinsd);
    bigint * acdec = bigint_shift(ac, 2 * split);
    return add_bigint(add_bigint(acdec, bd), bigint_shift(sub_bigint(add_bigint(ac, bd), amoinsbcmoinsd), split));
    /* ac ?? 102k + (ac + bd ??? (a ??? b)(c ??? d)) ?? 10k + bd */
}

/*
Division,
Modulo
*/

int log100(int a) {
    int out0 = 1;
    while (a >= 10)
    {
        a /= 10;
        out0++;
    }
    return out0;
}


bigint * bigint_of_int(int i) {
    int k, j;
    int size = log100(i);
    if (i == 0)
        size = 0;
    int *t = calloc(size, sizeof(int));
    for (j = 0; j < size; j++)
        t[j] = 0;
    for (k = 0; k < size; k++)
    {
        t[k] = i % 10;
        i /= 10;
    }
    bigint * q = [bigint alloc];
    q->bigint_sign = 1;
    q->bigint_len = size;
    q->bigint_chiffres = t;
    return q;
}


bigint * fact_bigint(bigint * a) {
    bigint * one = bigint_of_int(1);
    bigint * out0 = one;
    while (!bigint_eq(a, one))
    {
        out0 = mul_bigint(a, out0);
        a = sub_bigint(a, one);
    }
    return out0;
}


int sum_chiffres_bigint(bigint * a) {
    int i;
    int out0 = 0;
    for (i = 0; i < a->bigint_len; i++)
        out0 += a->bigint_chiffres[i];
    return out0;
}

//  http://projecteuler.net/problem=20 

int euler20() {
    bigint * a = bigint_of_int(15);
    /* normalement c'est 100 */
    a = fact_bigint(a);
    return sum_chiffres_bigint(a);
}


bigint * bigint_exp(bigint * a, int b) {
    if (b == 1)
        return a;
    else if (b % 2 == 0)
        return bigint_exp(mul_bigint(a, a), b / 2);
    else
        return mul_bigint(a, bigint_exp(a, b - 1));
}


bigint * bigint_exp_10chiffres(bigint * a, int b) {
    a = bigint_premiers_chiffres(a, 10);
    if (b == 1)
        return a;
    else if (b % 2 == 0)
        return bigint_exp_10chiffres(mul_bigint(a, a), b / 2);
    else
        return mul_bigint(a, bigint_exp_10chiffres(a, b - 1));
}


void euler48() {
    int i;
    bigint * sum = bigint_of_int(0);
    for (i = 1; i < 101; i++)
    {
        /* 1000 normalement */
        bigint * ib = bigint_of_int(i);
        bigint * ibeib = bigint_exp_10chiffres(ib, i);
        sum = add_bigint(sum, ibeib);
        sum = bigint_premiers_chiffres(sum, 10);
    }
    printf("euler 48 = ");
    print_bigint(sum);
    printf("\n");
}


int euler16() {
    bigint * a = bigint_of_int(2);
    a = bigint_exp(a, 100);
    /* 1000 normalement */
    return sum_chiffres_bigint(a);
}


int euler25() {
    int i = 2;
    bigint * a = bigint_of_int(1);
    bigint * b = bigint_of_int(1);
    while (b->bigint_len < 100)
    {
        /* 1000 normalement */
        bigint * c = add_bigint(a, b);
        a = b;
        b = c;
        i++;
    }
    return i;
}


int euler29() {
    int l, i, k, j2, j;
    int maxA = 5;
    int maxB = 5;
    bigint * *a_bigint = calloc(maxA + 1, sizeof(bigint *));
    for (j = 0; j <= maxA; j++)
        a_bigint[j] = bigint_of_int(j * j);
    bigint * *a0_bigint = calloc(maxA + 1, sizeof(bigint *));
    for (j2 = 0; j2 <= maxA; j2++)
        a0_bigint[j2] = bigint_of_int(j2);
    int *b = calloc(maxA + 1, sizeof(int));
    for (k = 0; k <= maxA; k++)
        b[k] = 2;
    int n = 0;
    int found = 1;
    while (found)
    {
        bigint * min0 = a0_bigint[0];
        found = 0;
        for (i = 2; i <= maxA; i++)
            if (b[i] <= maxB)
                if (found)
                {
                    if (bigint_lt(a_bigint[i], min0))
                        min0 = a_bigint[i];
                }
                else
                {
                    min0 = a_bigint[i];
                    found = 1;
                }
        if (found)
        {
            n++;
            for (l = 2; l <= maxA; l++)
                if (bigint_eq(a_bigint[l], min0) && b[l] <= maxB)
                {
                    b[l]++;
                    a_bigint[l] = mul_bigint(a_bigint[l], a0_bigint[l]);
                }
        }
    }
    return n;
}

int main(void){
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  int i;
  printf("%d\n", euler29());
  bigint * sum = read_bigint(50);
  for (i = 2; i < 101; i++)
  {
      scanf(" ");
      bigint * tmp = read_bigint(50);
      sum = add_bigint(sum, tmp);
  }
  printf("euler13 = ");
  print_bigint(sum);
  printf("\neuler25 = %d\neuler16 = %d\n", euler25(), euler16());
  euler48();
  printf("euler20 = %d\n", euler20());
  bigint * a = bigint_of_int(999999);
  bigint * b = bigint_of_int(9951263);
  print_bigint(a);
  printf(">>1=");
  print_bigint(bigint_shift(a, -1));
  printf("\n");
  print_bigint(a);
  printf("*");
  print_bigint(b);
  printf("=");
  print_bigint(mul_bigint(a, b));
  printf("\n");
  print_bigint(a);
  printf("*");
  print_bigint(b);
  printf("=");
  print_bigint(mul_bigint_cp(a, b));
  printf("\n");
  print_bigint(a);
  printf("+");
  print_bigint(b);
  printf("=");
  print_bigint(add_bigint(a, b));
  printf("\n");
  print_bigint(b);
  printf("-");
  print_bigint(a);
  printf("=");
  print_bigint(sub_bigint(b, a));
  printf("\n");
  print_bigint(a);
  printf("-");
  print_bigint(b);
  printf("=");
  print_bigint(sub_bigint(a, b));
  printf("\n");
  print_bigint(a);
  printf(">");
  print_bigint(b);
  printf("=");
  if (bigint_gt(a, b))
      printf("True");
  else
      printf("False");
  printf("\n");
  [pool drain];
  return 0;
}


