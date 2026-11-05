#ifndef MI_LINALG_CPP
#define MI_LINALG_CPP

#include "../cpp/mi_linalg.hpp"

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/custom.h>

#include <new>
#include <utility>
#include <vector>

// Get an lvalue for a matrix from an OCaml value
#define Mi_matrix_val(v) (*(mi_matrix*)Data_custom_val(v))

static void mi_matrix_finalize(value mi_matrix_v) {
  // Pairs with the placement new in mi_matrix_alloc; the destructor
  // frees the elements, which Eigen keeps outside the OCaml heap.
  Mi_matrix_val(mi_matrix_v).~mi_matrix();
}

static struct custom_operations mi_matrix_ops {
  "mi_matrix_handle",
  mi_matrix_finalize,
  custom_compare_default,
  custom_hash_default,
  custom_serialize_default,
  custom_deserialize_default
};

// Moves `m` into a new OCaml value, telling the GC the size of the
// elements so that it accounts for them when deciding when to collect.
static value mi_matrix_alloc(mi_matrix &&m) {
  mlsize_t elements_size = m.size() * sizeof(double);
  value v = caml_alloc_custom_mem(&mi_matrix_ops, sizeof(mi_matrix), elements_size);
  new (Data_custom_val(v)) mi_matrix(std::move(m));
  return v;
}

static std::vector<double> mi_float_array_to_vector(value array) {
  mlsize_t size = Wosize_val(array) / Double_wosize;
  std::vector<double> result(size);
  for (mlsize_t i = 0; i < size; i++) {
    result[i] = Double_flat_field(array, i);
  }
  return result;
}

static value mi_vector_to_float_array(const std::vector<double> &elements) {
  value array = caml_alloc_float_array(elements.size());
  for (size_t i = 0; i < elements.size(); i++) {
    Store_double_flat_field(array, i, elements[i]);
  }
  return array;
}

extern "C" CAMLprim value mi_matrix_of_column_stub(value column) {
  CAMLparam1(column);
  CAMLreturn(mi_matrix_alloc(mi_matrix_of_column(mi_float_array_to_vector(column))));
}

extern "C" CAMLprim value mi_matrix_of_rows_stub(value rows) {
  CAMLparam1(rows);
  std::vector<std::vector<double>> rows_vector(Wosize_val(rows));
  for (size_t i = 0; i < rows_vector.size(); i++) {
    rows_vector[i] = mi_float_array_to_vector(Field(rows, i));
  }
  CAMLreturn(mi_matrix_alloc(mi_matrix_of_rows(rows_vector)));
}

extern "C" CAMLprim value mi_matrix_to_column_stub(value m) {
  CAMLparam1(m);
  CAMLreturn(mi_vector_to_float_array(mi_matrix_to_column(Mi_matrix_val(m))));
}

extern "C" CAMLprim value mi_matrix_to_rows_stub(value m) {
  CAMLparam1(m);
  CAMLlocal2(result, row);
  std::vector<std::vector<double>> rows = mi_matrix_to_rows(Mi_matrix_val(m));
  result = caml_alloc(rows.size(), 0);
  for (size_t i = 0; i < rows.size(); i++) {
    row = mi_vector_to_float_array(rows[i]);
    Store_field(result, i, row);
  }
  CAMLreturn(result);
}

extern "C" CAMLprim value mi_matrix_mul_stub(value a, value b) {
  CAMLparam2(a, b);
  CAMLreturn(mi_matrix_alloc(mi_matrix_mul(Mi_matrix_val(a), Mi_matrix_val(b))));
}

extern "C" CAMLprim value mi_matrix_exp_stub(value a) {
  CAMLparam1(a);
  CAMLreturn(mi_matrix_alloc(mi_matrix_exp(Mi_matrix_val(a))));
}

#endif
