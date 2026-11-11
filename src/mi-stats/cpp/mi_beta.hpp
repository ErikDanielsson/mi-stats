#ifndef MI_BETA_HPP
#define MI_BETA_HPP

#include <stan/math/prim/prob/beta_lpdf.hpp>
#include <stan/math/prim/prob/beta_rng.hpp>

#include "./mi_rng.hpp"

// Parameterized by alpha and beta, as in Stan.
inline double mi_beta_lpdf(double x, double alpha, double beta) {
  return stan::math::beta_lpdf(x, alpha, beta);
}

inline double mi_beta_rng(double alpha, double beta, mi_rng &rng) {
  return stan::math::beta_rng(alpha, beta, rng);
}

#endif
