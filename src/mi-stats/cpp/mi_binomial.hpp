#ifndef MI_BINOMIAL_HPP
#define MI_BINOMIAL_HPP

#include <stan/math/prim/prob/binomial_lpmf.hpp>
#include <stan/math/prim/prob/binomial_rng.hpp>

#include "./mi_rng.hpp"

// Parameterized by the number of trials N and the success probability theta,
// as in Stan.
inline double mi_binomial_lpmf(int n, int N, double theta) {
  return stan::math::binomial_lpmf(n, N, theta);
}

inline int mi_binomial_rng(int N, double theta, mi_rng &rng) {
  return stan::math::binomial_rng(N, theta, rng);
}

#endif
