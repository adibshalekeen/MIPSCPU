int fact(int n);
int comb(int n, int k);
/* 
int fib(int n)
{
    if (n <= 1)
        return n;
    else
        return fib(n-1) + fib(n-2);
}
*/

int main() {

    return comb(10, 2);
}

int fact(int n)
{
    int i, f = 1;
    for (i = n; i > 1; i--)
        f = f * i;
    return f;
}

int comb(int n, int k)
{
    return fact(n) / fact(k) / fact(n-k);
}


