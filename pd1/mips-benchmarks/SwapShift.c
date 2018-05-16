//#define DEBUG 0

#ifdef DEBUG
//#include<stdio.h>
#endif

void swap(int *p, int *q);
int main(void)
{
  int a=5;
  int b=9;
#ifdef DEBUG
 // printf("orig: a: %d, b: %d\n", a, b);
#endif

  b = b << 2; //  36
  a = a >> 1; // 2
#ifdef DEBUG
  //printf("shift_orig: a: %d, b: %d\n", a, b);
#endif
  int *p ;
  int *q ;
  p = &a;
  q = &b;
  swap(p,q);
  // v0 should have a = 36
  a = *p;
  // v1 should have b = 2
  b = *q;
  // v0 stores the sum 38
#ifdef DEBUG
  //printf("swap: a: %d, b: %d\n", a, b);
#endif
  return a + b;
}

void swap(int *p, int *q)
{
  int temp;
  temp = *p;
  *p=*q;
  *q=temp;
}
