#ifndef MI_VECTOR_HPP
#define MI_VECTOR_HPP

#include <stan/math/prim/fun/Eigen.hpp>
#include <stan/math/prim/fun/to_array_1d.hpp>
#include <stan/math/prim/fun/to_vector.hpp>

#include <vector>

using mi_vector = Eigen::VectorXd;

inline mi_vector mi_vector_of_elements(const std::vector<double> &elements) {
  return stan::math::to_vector(elements);
}

inline std::vector<double> mi_vector_to_elements(const mi_vector &v) {
  return stan::math::to_array_1d(v);
}

#endif
