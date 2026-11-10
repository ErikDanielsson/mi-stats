#ifndef MI_GAMMA_HPP
#define MI_GAMMA_HPP

#include <stan/math/prim/prob/gamma_lpdf.hpp>
#include <stan/math/prim/prob/gamma_cdf.hpp>
#include <stan/math/prim/prob/gamma_rng.hpp>

#include "./mi_rng.hpp"

// Parameterized by shape alpha and rate beta, as in Stan.
inline double mi_gamma_lpdf(double x, double alpha, double beta) {
  return stan::math::gamma_lpdf(x, alpha, beta);
}

inline double mi_gamma_cdf(double x, double alpha, double beta) {
  return stan::math::gamma_cdf(x, alpha, beta);
}

inline double mi_gamma_rng(double alpha, double beta, mi_rng &rng) {
  return stan::math::gamma_rng(alpha, beta, rng);
}

#endif
