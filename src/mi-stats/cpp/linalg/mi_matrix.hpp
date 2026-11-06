#ifndef MI_MATRIX_HPP
#define MI_MATRIX_HPP

#include <stan/math/prim/fun/Eigen.hpp>
#include <stan/math/prim/fun/to_array_2d.hpp>
#include <stan/math/prim/fun/to_matrix.hpp>

#include <vector>

using mi_matrix = Eigen::MatrixXd;

inline mi_matrix mi_matrix_of_rows(const std::vector<std::vector<double>> &rows) {
  return stan::math::to_matrix(rows);
}

inline std::vector<std::vector<double>> mi_matrix_to_rows(const mi_matrix &m) {
  return stan::math::to_array_2d(m);
}

#endif
