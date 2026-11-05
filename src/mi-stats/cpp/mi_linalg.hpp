#ifndef MI_LINALG_HPP
#define MI_LINALG_HPP

#include <stan/math/prim/fun/Eigen.hpp>
#include <stan/math/prim/fun/multiply.hpp>
#include <stan/math/prim/fun/to_array_1d.hpp>
#include <stan/math/prim/fun/to_array_2d.hpp>
#include <stan/math/prim/fun/to_matrix.hpp>
#include <stan/math/prim/fun/to_vector.hpp>
#include <stan/math/prim/fun/matrix_exp.hpp>

#include <vector>

// Both matrices and vectors are represented by this type. A vector is
// always stored as a single column.
using mi_matrix = Eigen::MatrixXd;

inline mi_matrix mi_matrix_of_column(const std::vector<double> &column) {
  return stan::math::to_vector(column);
}

inline mi_matrix mi_matrix_of_rows(const std::vector<std::vector<double>> &rows) {
  return stan::math::to_matrix(rows);
}

inline std::vector<double> mi_matrix_to_column(const mi_matrix &m) {
  return stan::math::to_array_1d(m);
}

inline std::vector<std::vector<double>> mi_matrix_to_rows(const mi_matrix &m) {
  return stan::math::to_array_2d(m);
}

inline mi_matrix mi_matrix_mul(const mi_matrix &a, const mi_matrix &b) {
  return stan::math::multiply(a, b);
}

inline mi_matrix mi_matrix_exp(const mi_matrix &a) {
  return stan::math::matrix_exp(a);
}

#endif
