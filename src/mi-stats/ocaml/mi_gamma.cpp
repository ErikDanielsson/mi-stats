#ifndef MI_GAMMA_CPP
#define MI_GAMMA_CPP

#include "../cpp/mi_gamma.hpp"
#include "./mi_error.cpp"
#include "./mi_rng.cpp"

extern "C" CAMLprim double mi_gamma_lpdf_unwrapped(double x, double alpha, double beta) {
  return mi_catch([&] { return mi_gamma_lpdf(x, alpha, beta); });
}

extern "C" CAMLprim value mi_gamma_lpdf_wrapped(value x, value alpha, value beta) {
  CAMLparam3(x, alpha, beta);
  CAMLreturn(caml_copy_double(mi_catch([&] {
    return mi_gamma_lpdf(Double_val(x), Double_val(alpha), Double_val(beta));
  })));
}

extern "C" CAMLprim double mi_gamma_cdf_unwrapped(double x, double alpha, double beta) {
  return mi_catch([&] { return mi_gamma_cdf(x, alpha, beta); });
}

extern "C" CAMLprim value mi_gamma_cdf_wrapped(value x, value alpha, value beta) {
  CAMLparam3(x, alpha, beta);
  CAMLreturn(caml_copy_double(mi_catch([&] {
    return mi_gamma_cdf(Double_val(x), Double_val(alpha), Double_val(beta));
  })));
}

extern "C" CAMLprim double mi_gamma_rng_unwrapped(double alpha, double beta, value mt) {
  return mi_catch([&] { return mi_gamma_rng(alpha, beta, Mi_rng_val(mt)); });
}

extern "C" CAMLprim value mi_gamma_rng_wrapped(value alpha, value beta, value mt) {
  CAMLparam3(alpha, beta, mt);
  CAMLreturn(caml_copy_double(mi_catch([&] {
    return mi_gamma_rng(Double_val(alpha), Double_val(beta), Mi_rng_val(mt));
  })));
}

#endif
