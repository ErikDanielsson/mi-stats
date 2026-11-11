#ifndef MI_BINOMIAL_CPP
#define MI_BINOMIAL_CPP

#include "../cpp/mi_binomial.hpp"
#include "./mi_error.cpp"
#include "./mi_rng.cpp"

extern "C" CAMLprim double mi_binomial_lpmf_unwrapped(value n, value N, double theta) {
  return mi_catch([&] { return mi_binomial_lpmf(Long_val(n), Long_val(N), theta); });
}

extern "C" CAMLprim value mi_binomial_lpmf_wrapped(value n, value N, value theta) {
  CAMLparam3(n, N, theta);
  CAMLreturn(caml_copy_double(mi_catch([&] {
    return mi_binomial_lpmf(Long_val(n), Long_val(N), Double_val(theta));
  })));
}

extern "C" CAMLprim value mi_binomial_rng_unwrapped(value N, double theta, value mt) {
  return Val_long(mi_catch([&] { return mi_binomial_rng(Long_val(N), theta, Mi_rng_val(mt)); }));
}

extern "C" CAMLprim value mi_binomial_rng_wrapped(value N, value theta, value mt) {
  CAMLparam3(N, theta, mt);
  CAMLreturn(Val_long(mi_catch([&] {
    return mi_binomial_rng(Long_val(N), Double_val(theta), Mi_rng_val(mt));
  })));
}

#endif
