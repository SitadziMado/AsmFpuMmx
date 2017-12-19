#pragma once

#include <cstdint>

using std::uint8_t;

extern "C" {
    extern double calc_explicit(double x);

    extern double calc_iterative(double x, int n);

    extern double calc_epsilon(double x, double eps);

    extern uint8_t* mmx_add_bytes(
        uint8_t* dst, 
        const uint8_t* src, 
        size_t len
    );

    extern uint8_t* mmx_sub_bytes(
        uint8_t* dst,
        const uint8_t* src, 
        size_t len
    );

    extern uint16_t* mmx_mul_words_by_power_of_two(
        uint16_t* array,
        size_t len, 
        size_t power_of_two
    );

    extern uint8_t* mmx_div_words_by_power_of_two(
        uint16_t* array,
        size_t len, 
        size_t power_of_two
    );

    extern bool mmx_are_bytes_eq(
        uint8_t* dst,
        const uint8_t* src,
        size_t len
    );

    extern bool mmx_are_bytes_gt(
        uint8_t* dst, 
        const uint8_t* src, 
        size_t len
    );
}