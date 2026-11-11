#ifndef MI_NEG_BINOMIAL_HPP
#define MI_NEG_BINOMIAL_HPP

#include <stan/math/prim/prob/neg_binomial_lpmf.hpp>
#include <stan/math/prim/prob/neg_binomial_rng.hpp>

#include "./mi_rng.hpp"

// Parameterized by the shape alpha and the inverse scale beta, as in Stan
// (mean alpha / beta).
inline double mi_neg_binomial_lpmf(int n, double alpha, double beta) {
  return stan::math::neg_binomial_lpmf(n, alpha, beta);
}

inline int mi_neg_binomial_rng(double alpha, double beta, mi_rng &rng) {
  return stan::math::neg_binomial_rng(alpha, beta, rng);
}

#endif
