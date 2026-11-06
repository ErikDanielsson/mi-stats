#ifndef MI_INT_ARRAY_HPP
#define MI_INT_ARRAY_HPP

#include <vector>

static_assert(sizeof(int) == 4, "MiStatsInt32Array assumes a 32-bit int");

using mi_int_array = std::vector<int>;

#endif
