#ifndef MI_POISSON_CPP
#define MI_POISSON_CPP

#include "../cpp/mi_poisson.hpp"
#include "./mi_error.cpp"
#include "./mi_rng.cpp"

extern "C" CAMLprim double mi_poisson_lpmf_unwrapped(value n, double lambda) {
  return mi_catch([&] { return mi_poisson_lpmf(Long_val(n), lambda); });
}

extern "C" CAMLprim value mi_poisson_lpmf_wrapped(value n, value lambda) {
  CAMLparam2(n, lambda);
  CAMLreturn(caml_copy_double(mi_catch([&] {
    return mi_poisson_lpmf(Long_val(n), Double_val(lambda));
  })));
}

extern "C" CAMLprim value mi_poisson_rng_unwrapped(double lambda, value mt) {
  return Val_long(mi_catch([&] { return mi_poisson_rng(lambda, Mi_rng_val(mt)); }));
}

extern "C" CAMLprim value mi_poisson_rng_wrapped(value lambda, value mt) {
  CAMLparam2(lambda, mt);
  CAMLreturn(Val_long(mi_catch([&] {
    return mi_poisson_rng(Double_val(lambda), Mi_rng_val(mt));
  })));
}

#endif
