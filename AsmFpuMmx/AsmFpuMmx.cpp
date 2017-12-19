#include "stdafx.h"

#include "Func.h"

double f(double x);

int main()
{
    auto a = f(6.0);

    uint8_t bytes1[] = { 1, 2, 3, 4, 5, 6, 7, 8 };
    uint8_t bytes2[] = { 2, 6, 1, 6, 6, 3, 4, 7 };

    constexpr auto BytesSize = std::extent<decltype(bytes1)>();

    mmx_add_bytes(bytes1, bytes2, BytesSize);
    mmx_sub_bytes(bytes1, bytes2, BytesSize);
    bool eq = mmx_are_bytes_eq(bytes1, bytes2, BytesSize);
    bool gt = mmx_are_bytes_gt(bytes1, bytes2, BytesSize);

    uint16_t words1[] = { 157, 24534, 342, 4234, 512, 1236, 127, 31458 };
    uint16_t words2[] = { 2, 6, 1, 6, 6, 3, 4, 7 };

    constexpr auto WordsSize = std::extent<decltype(words1)>();

    mmx_mul_words_by_power_of_two(words1, WordsSize, 4);
    mmx_div_words_by_power_of_two(words2, WordsSize, 3);

    return 0;
}

double f(double x)
{
    auto exp = calc_explicit(x);
    auto it = calc_iterative(x, 256);
    auto eps = calc_epsilon(x, 0.1);

    return std::log(1.0 / (2 + 2 * x + x * x));
}