#ifndef MI_CHI_SQUARE_HPP
#define MI_CHI_SQUARE_HPP

#include <stan/math/prim/prob/chi_square_lpdf.hpp>
#include <stan/math/prim/prob/chi_square_cdf.hpp>
#include <stan/math/prim/prob/chi_square_rng.hpp>

#include "./mi_rng.hpp"

// Parameterized by degrees of freedom nu, as in Stan.
inline double mi_chi_square_lpdf(double x, double nu) {
  return stan::math::chi_square_lpdf(x, nu);
}

inline double mi_chi_square_cdf(double x, double nu) {
  return stan::math::chi_square_cdf(x, nu);
}

inline double mi_chi_square_rng(double nu, mi_rng &rng) {
  return stan::math::chi_square_rng(nu, rng);
}

#endif
