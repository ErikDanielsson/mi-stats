#ifndef MI_DISCRETE_RANGE_HPP
#define MI_DISCRETE_RANGE_HPP

#include <stan/math/prim/prob/discrete_range_lpmf.hpp>
#include <stan/math/prim/prob/discrete_range_rng.hpp>

#include "./mi_rng.hpp"

// Parameterized by the inclusive lower and upper bounds, as in Stan.
inline double mi_discrete_range_lpmf(int y, int lower, int upper) {
  return stan::math::discrete_range_lpmf(y, lower, upper);
}

inline int mi_discrete_range_rng(int lower, int upper, mi_rng &rng) {
  return stan::math::discrete_range_rng(lower, upper, rng);
}

#endif
