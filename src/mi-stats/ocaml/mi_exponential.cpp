#ifndef MI_EXPONENTIAL_CPP
#define MI_EXPONENTIAL_CPP

#include "../cpp/mi_exponential.hpp"
#include "./mi_error.cpp"
#include "./mi_rng.cpp"

extern "C" CAMLprim double mi_exponential_lpdf_unwrapped(double x, double beta) {
  return mi_catch([&] { return mi_exponential_lpdf(x, beta); });
}

extern "C" CAMLprim value mi_exponential_lpdf_wrapped(value x, value beta) {
  CAMLparam2(x, beta);
  CAMLreturn(caml_copy_double(mi_catch([&] {
    return mi_exponential_lpdf(Double_val(x), Double_val(beta));
  })));
}

extern "C" CAMLprim double mi_exponential_rng_unwrapped(double beta, value mt) {
  return mi_catch([&] { return mi_exponential_rng(beta, Mi_rng_val(mt)); });
}

extern "C" CAMLprim value mi_exponential_rng_wrapped(value beta, value mt) {
  CAMLparam2(beta, mt);
  CAMLreturn(caml_copy_double(mi_catch([&] {
    return mi_exponential_rng(Double_val(beta), Mi_rng_val(mt));
  })));
}

#endif
