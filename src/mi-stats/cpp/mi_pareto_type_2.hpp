#ifndef MI_PARETO_TYPE_2_HPP
#define MI_PARETO_TYPE_2_HPP

#include <stan/math/prim/prob/pareto_type_2_lpdf.hpp>
#include <stan/math/prim/prob/pareto_type_2_rng.hpp>

#include "./mi_rng.hpp"

// Parameterized by location mu, scale lambda and shape alpha, as in Stan.
inline double mi_pareto_type_2_lpdf(double x, double mu, double lambda, double alpha) {
  return stan::math::pareto_type_2_lpdf(x, mu, lambda, alpha);
}

inline double mi_pareto_type_2_rng(double mu, double lambda, double alpha, mi_rng &rng) {
  return stan::math::pareto_type_2_rng(mu, lambda, alpha, rng);
}

#endif
