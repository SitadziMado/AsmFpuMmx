#pragma once

extern "C" {
    extern double calc_explicit(double x);

    extern double calc_iterative(double x, int n);

    extern double calc_epsilon(double x, double eps);
}