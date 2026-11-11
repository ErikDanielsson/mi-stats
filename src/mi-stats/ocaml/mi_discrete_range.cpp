#ifndef MI_DISCRETE_RANGE_CPP
#define MI_DISCRETE_RANGE_CPP

#include "../cpp/mi_discrete_range.hpp"
#include "./mi_error.cpp"
#include "./mi_rng.cpp"

extern "C" CAMLprim double mi_discrete_range_lpmf_unwrapped(value y, value lower, value upper) {
  return mi_catch([&] { return mi_discrete_range_lpmf(Long_val(y), Long_val(lower), Long_val(upper)); });
}

extern "C" CAMLprim value mi_discrete_range_lpmf_wrapped(value y, value lower, value upper) {
  CAMLparam3(y, lower, upper);
  CAMLreturn(caml_copy_double(mi_catch([&] {
    return mi_discrete_range_lpmf(Long_val(y), Long_val(lower), Long_val(upper));
  })));
}

extern "C" CAMLprim value mi_discrete_range_rng_unwrapped(value lower, value upper, value mt) {
  return Val_long(mi_catch([&] { return mi_discrete_range_rng(Long_val(lower), Long_val(upper), Mi_rng_val(mt)); }));
}

extern "C" CAMLprim value mi_discrete_range_rng_wrapped(value lower, value upper, value mt) {
  CAMLparam3(lower, upper, mt);
  CAMLreturn(Val_long(mi_catch([&] {
    return mi_discrete_range_rng(Long_val(lower), Long_val(upper), Mi_rng_val(mt));
  })));
}

#endif
