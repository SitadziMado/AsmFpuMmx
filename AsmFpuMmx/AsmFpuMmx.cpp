#include "stdafx.h"

#include "Func.h"
#include "Utils\io.h"

bool fpu();
bool mmx();
void filler();
void cls();

int main()
{
    std::vector<std::pair<std::string, std::function<bool()>>> procs{
        { "1. Calculate function (FPU)", fpu },
        { "2. Process arrays (MMX)", mmx },
    };

    auto help = [&procs] {
        print("0. Exit");

        for (const auto& a : procs)
            print(a.first);

        filler();
    };

    help();

    int command;

    while ((command = input<int>("Enter a command:", 0, 2, "Enter a valid command")) != 0)
    {
        if (procs[command - 1].second())
        {
            std::system("pause");
            cls();
        }
        else
        {
            cls();
            print("Something went wrong, try once more...");
            std::system("pause");
        }

        help();
    }

    return 0;
}

bool fpu()
{
    std::cout << std::setprecision(10);

    constexpr auto dmax = std::numeric_limits<double>::max();

    auto x = input<double>("Enter an argument:", -dmax, dmax);
    auto n = input<double>("Enter a number of iterations:", -dmax, dmax);
    auto e = input<double>("Enter an epsilon:", -dmax, dmax);

    auto exp = calc_explicit(x);
    auto it = calc_iterative(x, n);
    auto eps = calc_epsilon(x, e);

    filler();
    print("Explicit function result:", exp);
    print("Iterative function result:", it);
    print("Epsilon function result:", eps);

    return true;
}

bool mmx()
{
    auto fillVec = [](const std::string& prompt, auto& vec, size_t n) {
        while (vec.size() < n)
        {
            std::stringstream ss{ input(prompt) };

            while (!ss.eof() && vec.size() < n)
            {
                int8_t t;
                ss >> t;
                vec.push_back(t);
            }
        }
    };

    auto nub = input<int>(
        "Enter a number of unsigned bytes:",
        8,
        std::numeric_limits<int>::max(),
        "Enter a natural number."
    );

    auto nw = input<int>(
        "Enter a number of signed words:",
        8,
        std::numeric_limits<int>::max(),
        "Enter a natural number."
    );

    nub >>= 3;
    nub <<= 3;
    nw >>= 3;
    nw <<= 3;

    print("Numbers are set so they are 8 * n.");

    std::vector<int8_t> firstUChars;
    std::vector<int8_t> secondUChars;
    std::vector<int16_t> firstWords;
    std::vector<int16_t> secondWords;

    std::string inp;

    fillVec("Input first unsigned bytes array:", firstUChars, nub);
    fillVec("Input second unsigned bytes array:", secondUChars, nub);
    fillVec("Input first signed words array:", firstWords, nw);
    fillVec("Input second signed words array:", secondWords, nw);



    return true;
}

void cls()
{
    std::system("cls");
}

void filler()
{
    print("***************");
}