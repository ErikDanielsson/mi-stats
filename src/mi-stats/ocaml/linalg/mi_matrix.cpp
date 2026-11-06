#ifndef MI_MATRIX_CPP
#define MI_MATRIX_CPP

#include "../../cpp/linalg/mi_matrix.hpp"
#include "./mi_float_array.cpp"
#include "../mi_custom_block.cpp"

extern "C" CAMLprim value mi_matrix_of_rows_stub(value rows) {
  CAMLparam1(rows);
  std::vector<std::vector<double>> rows_vector(Wosize_val(rows));
  for (size_t i = 0; i < rows_vector.size(); i++) {
    rows_vector[i] = mi_float_array_to_std_vector(Field(rows, i));
  }
  CAMLreturn(mi_custom_block_alloc_container<mi_matrix>(mi_matrix_of_rows(rows_vector)));
}

extern "C" CAMLprim value mi_matrix_to_rows_stub(value m) {
  CAMLparam1(m);
  CAMLlocal2(result, row);
  std::vector<std::vector<double>> rows = mi_matrix_to_rows(mi_custom_block_val<mi_matrix>(m));
  result = caml_alloc(rows.size(), 0);
  for (size_t i = 0; i < rows.size(); i++) {
    row = mi_float_array_of_std_vector(rows[i]);
    Store_field(result, i, row);
  }
  CAMLreturn(result);
}

#endif
