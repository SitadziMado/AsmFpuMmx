#pragma once

#include <iostream>
#include <limits>
#include <string>
#include <utility>
#include <vector>

template<typename TTrue, typename TFalse, bool Value> struct SwitchImpl;

template<typename TTrue, typename TFalse>
struct SwitchImpl<TTrue, TFalse, false>
{
    using Type = TFalse;
};

template<typename TTrue, typename TFalse>
struct SwitchImpl<TTrue, TFalse, true>
{
    using Type = TTrue;
};

template<typename T>
using NumericOrDefault_t = typename SwitchImpl<T, int, std::is_arithmetic<T>::value>::Type;

template<typename T, typename = std::enable_if<std::is_arithmetic<T>::value>>
inline bool check(
    T value,
    T lowerConstraint,
    T higherConstraint
)
{
    return lowerConstraint <= value && value <= higherConstraint;
}

template<typename T>
inline typename std::enable_if<!(std::is_arithmetic<T>::value), bool>::type check(T, NumericOrDefault_t<T>, NumericOrDefault_t<T>)
{
    return true;
}

template<typename T = std::string>
inline T input(
    const std::string& prompt = "",
    NumericOrDefault_t<T> lowerConstraint = std::numeric_limits<NumericOrDefault_t<T>>::min(),
    NumericOrDefault_t<T> higherConstraint = std::numeric_limits<NumericOrDefault_t<T>>::max(),
    const std::string& failed = "Error occured while parsing. Try again...."
)
{
    if (prompt.size())
        std::cout << prompt << " ";

    T result;

    while (!(std::cin >> result) || !check(result, lowerConstraint, higherConstraint))
    {
        std::cout << failed << std::endl;

        std::cin.clear();
        std::cin.ignore(std::numeric_limits<size_t>::max(), '\n');
    }

    std::cin.ignore(std::numeric_limits<size_t>::max(), '\n');

    return result;
}

inline std::string input(const std::string& prompt)
{
    if (prompt.size())
        std::cout << prompt << " ";

    std::string result;

    std::getline(std::cin, result);

    return result;
}

template<typename T, typename... Ts> struct Printer;

template<typename T>
struct Printer<T>
{
    inline void operator()(T&& arg)
    {
        std::cout << std::forward<T>(arg) << " ";
    }
};

template<typename T, typename... Ts>
struct Printer
{
    inline void operator()(T&& first, Ts&&... rest)
    {
        Printer<T>()(std::forward<T>(first));
        Printer<Ts...>()(std::forward<Ts>(rest)...);
    }
};

inline void print()
{
    std::cout << std::endl;
}

template<typename... Ts>
inline void print(Ts&&... args)
{
    Printer<Ts...>()(std::forward<Ts>(args)...);
    print();
}

template<typename T>
inline std::ostream& operator<<(std::ostream& stream, const std::vector<T>& vec)
{
    stream << "[ ";

    for (auto a : vec)
        stream << a << "; ";

    stream << "]";

    return stream;
}
