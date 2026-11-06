#ifndef MI_VECTOR_CPP
#define MI_VECTOR_CPP

#include "../../cpp/linalg/mi_vector.hpp"
#include "./mi_float_array.cpp"
#include "./mi_handle.cpp"

extern "C" CAMLprim value mi_vector_of_float_array_stub(value elements) {
  CAMLparam1(elements);
  CAMLreturn(mi_handle_alloc<mi_vector>(
      mi_vector_of_elements(mi_float_array_to_std_vector(elements))));
}

extern "C" CAMLprim value mi_vector_to_float_array_stub(value v) {
  CAMLparam1(v);
  CAMLreturn(mi_float_array_of_std_vector(
      mi_vector_to_elements(mi_handle_val<mi_vector>(v))));
}

#endif
