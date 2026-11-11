#ifndef MI_UNIFORM_HPP
#define MI_UNIFORM_HPP

#include <stan/math/prim/prob/uniform_lpdf.hpp>
#include <stan/math/prim/prob/uniform_rng.hpp>

#include "./mi_rng.hpp"

// Parameterized by the lower bound alpha and the upper bound beta, as in Stan.
inline double mi_uniform_lpdf(double x, double alpha, double beta) {
  return stan::math::uniform_lpdf(x, alpha, beta);
}

inline double mi_uniform_rng(double alpha, double beta, mi_rng &rng) {
  return stan::math::uniform_rng(alpha, beta, rng);
}

#endif
