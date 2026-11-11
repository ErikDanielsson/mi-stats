#ifndef MI_BETA_BINOMIAL_CPP
#define MI_BETA_BINOMIAL_CPP

#include "../cpp/mi_beta_binomial.hpp"
#include "./mi_error.cpp"
#include "./mi_rng.cpp"

extern "C" CAMLprim double mi_beta_binomial_lpmf_unwrapped(value n, value N, double alpha, double beta) {
  return mi_catch([&] { return mi_beta_binomial_lpmf(Long_val(n), Long_val(N), alpha, beta); });
}

extern "C" CAMLprim value mi_beta_binomial_lpmf_wrapped(value n, value N, value alpha, value beta) {
  CAMLparam4(n, N, alpha, beta);
  CAMLreturn(caml_copy_double(mi_catch([&] {
    return mi_beta_binomial_lpmf(Long_val(n), Long_val(N), Double_val(alpha), Double_val(beta));
  })));
}

extern "C" CAMLprim value mi_beta_binomial_rng_unwrapped(value N, double alpha, double beta, value mt) {
  return Val_long(mi_catch([&] { return mi_beta_binomial_rng(Long_val(N), alpha, beta, Mi_rng_val(mt)); }));
}

extern "C" CAMLprim value mi_beta_binomial_rng_wrapped(value N, value alpha, value beta, value mt) {
  CAMLparam4(N, alpha, beta, mt);
  CAMLreturn(Val_long(mi_catch([&] {
    return mi_beta_binomial_rng(Long_val(N), Double_val(alpha), Double_val(beta), Mi_rng_val(mt));
  })));
}

#endif
