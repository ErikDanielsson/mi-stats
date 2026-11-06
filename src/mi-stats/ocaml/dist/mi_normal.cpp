#ifndef MI_NORMAL_CPP
#define MI_NORMAL_CPP

#include "../../cpp/dist/mi_normal.hpp"
#include "../mi_rng.cpp"

extern "C" CAMLprim double mi_normal_lpdf_unwrapped(double x, double mu, double sigma) {
  return mi_normal_lpdf(x, mu, sigma);
}

extern "C" CAMLprim value mi_normal_lpdf_wrapped(value x, value mu, value sigma) {
  CAMLparam3(x, mu, sigma);
  CAMLreturn(caml_copy_double(mi_normal_lpdf(Double_val(x), Double_val(mu), Double_val(sigma))));
}

extern "C" CAMLprim double mi_normal_rng_unwrapped(double mu, double sigma, value mt) {
  return mi_normal_rng(mu, sigma, mi_custom_block_val<mi_rng>(mt));
}

extern "C" CAMLprim value mi_normal_rng_wrapped(value mu, value sigma, value mt) {
  CAMLparam3(mu, sigma, mt);
  CAMLreturn(caml_copy_double(mi_normal_rng(Double_val(mu), Double_val(sigma), mi_custom_block_val<mi_rng>(mt))));
}

#endif
