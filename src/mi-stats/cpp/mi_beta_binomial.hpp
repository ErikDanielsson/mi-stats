#ifndef MI_BETA_BINOMIAL_HPP
#define MI_BETA_BINOMIAL_HPP

#include <stan/math/prim/prob/beta_binomial_lpmf.hpp>
#include <stan/math/prim/prob/beta_binomial_rng.hpp>

#include "./mi_rng.hpp"

// Parameterized by the number of trials N and shape parameters alpha and
// beta, as in Stan.
inline double mi_beta_binomial_lpmf(int n, int N, double alpha, double beta) {
  return stan::math::beta_binomial_lpmf(n, N, alpha, beta);
}

inline int mi_beta_binomial_rng(int N, double alpha, double beta, mi_rng &rng) {
  return stan::math::beta_binomial_rng(N, alpha, beta, rng);
}

#endif
