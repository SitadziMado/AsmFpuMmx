#include "stdafx.h"

#include "Func.h"

double f(double x);

int main()
{
    auto a = f(6.0);
    return 0;
}

double f(double x)
{
    auto exp = calc_explicit(x);
    auto it = calc_iterative(x, 16);

    return std::log(1.0 / (2 + 2 * x + x * x));
}