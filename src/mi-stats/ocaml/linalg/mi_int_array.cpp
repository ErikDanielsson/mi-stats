#ifndef MI_INT_ARRAY_CPP
#define MI_INT_ARRAY_CPP

#include "../../cpp/linalg/mi_int_array.hpp"
#include "./mi_handle.cpp"

extern "C" CAMLprim value mi_int_array_of_ocaml_array_stub(value elements) {
  CAMLparam1(elements);
  mi_int_array result(Wosize_val(elements));
  for (size_t i = 0; i < result.size(); i++) {
    result[i] = Int_val(Field(elements, i));
  }
  CAMLreturn(mi_handle_alloc<mi_int_array>(std::move(result)));
}

extern "C" CAMLprim value mi_int_array_to_ocaml_array_stub(value a) {
  CAMLparam1(a);
  CAMLlocal1(result);
  result = caml_alloc(mi_handle_val<mi_int_array>(a).size(), 0);
  // Taken after the allocation above, since that can move the block.
  const mi_int_array &elements = mi_handle_val<mi_int_array>(a);
  for (size_t i = 0; i < elements.size(); i++) {
    Store_field(result, i, Val_int(elements[i]));
  }
  CAMLreturn(result);
}

#endif
