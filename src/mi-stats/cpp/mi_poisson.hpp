#ifndef MI_POISSON_HPP
#define MI_POISSON_HPP

#include <stan/math/prim/prob/poisson_lpmf.hpp>
#include <stan/math/prim/prob/poisson_rng.hpp>

#include "./mi_rng.hpp"

// Parameterized by the rate lambda (the mean), as in Stan.
inline double mi_poisson_lpmf(int n, double lambda) {
  return stan::math::poisson_lpmf(n, lambda);
}

inline int mi_poisson_rng(double lambda, mi_rng &rng) {
  return stan::math::poisson_rng(lambda, rng);
}

#endif
