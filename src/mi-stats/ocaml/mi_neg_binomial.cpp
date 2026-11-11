#ifndef MI_NEG_BINOMIAL_CPP
#define MI_NEG_BINOMIAL_CPP

#include "../cpp/mi_neg_binomial.hpp"
#include "./mi_error.cpp"
#include "./mi_rng.cpp"

extern "C" CAMLprim double mi_neg_binomial_lpmf_unwrapped(value n, double alpha, double beta) {
  return mi_catch([&] { return mi_neg_binomial_lpmf(Long_val(n), alpha, beta); });
}

extern "C" CAMLprim value mi_neg_binomial_lpmf_wrapped(value n, value alpha, value beta) {
  CAMLparam3(n, alpha, beta);
  CAMLreturn(caml_copy_double(mi_catch([&] {
    return mi_neg_binomial_lpmf(Long_val(n), Double_val(alpha), Double_val(beta));
  })));
}

extern "C" CAMLprim value mi_neg_binomial_rng_unwrapped(double alpha, double beta, value mt) {
  return Val_long(mi_catch([&] { return mi_neg_binomial_rng(alpha, beta, Mi_rng_val(mt)); }));
}

extern "C" CAMLprim value mi_neg_binomial_rng_wrapped(value alpha, value beta, value mt) {
  CAMLparam3(alpha, beta, mt);
  CAMLreturn(Val_long(mi_catch([&] {
    return mi_neg_binomial_rng(Double_val(alpha), Double_val(beta), Mi_rng_val(mt));
  })));
}

#endif
