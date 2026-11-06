#ifndef MI_FLOAT_ARRAY_CPP
#define MI_FLOAT_ARRAY_CPP

#include <caml/mlvalues.h>
#include <caml/alloc.h>

#include <vector>

static std::vector<double> mi_float_array_to_std_vector(value array) {
  mlsize_t size = Wosize_val(array) / Double_wosize;
  std::vector<double> result(size);
  for (mlsize_t i = 0; i < size; i++) {
    result[i] = Double_flat_field(array, i);
  }
  return result;
}

static value mi_float_array_of_std_vector(const std::vector<double> &elements) {
  value array = caml_alloc_float_array(elements.size());
  for (size_t i = 0; i < elements.size(); i++) {
    Store_double_flat_field(array, i, elements[i]);
  }
  return array;
}

#endif
