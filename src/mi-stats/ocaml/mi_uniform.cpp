#ifndef MI_UNIFORM_CPP
#define MI_UNIFORM_CPP

#include "../cpp/mi_uniform.hpp"
#include "./mi_error.cpp"
#include "./mi_rng.cpp"

extern "C" CAMLprim double mi_uniform_lpdf_unwrapped(double x, double alpha, double beta) {
  return mi_catch([&] { return mi_uniform_lpdf(x, alpha, beta); });
}

extern "C" CAMLprim value mi_uniform_lpdf_wrapped(value x, value alpha, value beta) {
  CAMLparam3(x, alpha, beta);
  CAMLreturn(caml_copy_double(mi_catch([&] {
    return mi_uniform_lpdf(Double_val(x), Double_val(alpha), Double_val(beta));
  })));
}

extern "C" CAMLprim double mi_uniform_rng_unwrapped(double alpha, double beta, value mt) {
  return mi_catch([&] { return mi_uniform_rng(alpha, beta, Mi_rng_val(mt)); });
}

extern "C" CAMLprim value mi_uniform_rng_wrapped(value alpha, value beta, value mt) {
  CAMLparam3(alpha, beta, mt);
  CAMLreturn(caml_copy_double(mi_catch([&] {
    return mi_uniform_rng(Double_val(alpha), Double_val(beta), Mi_rng_val(mt));
  })));
}

#endif
