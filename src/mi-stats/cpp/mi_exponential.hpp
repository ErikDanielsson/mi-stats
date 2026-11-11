#ifndef MI_EXPONENTIAL_HPP
#define MI_EXPONENTIAL_HPP

#include <stan/math/prim/prob/exponential_lpdf.hpp>
#include <stan/math/prim/prob/exponential_rng.hpp>

#include "./mi_rng.hpp"

// Parameterized by the rate beta, as in Stan (mean 1 / beta).
inline double mi_exponential_lpdf(double x, double beta) {
  return stan::math::exponential_lpdf(x, beta);
}

inline double mi_exponential_rng(double beta, mi_rng &rng) {
  return stan::math::exponential_rng(beta, rng);
}

#endif
