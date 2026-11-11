#ifndef MI_CHI_SQUARE_CPP
#define MI_CHI_SQUARE_CPP

#include "../cpp/mi_chi_square.hpp"
#include "./mi_error.cpp"
#include "./mi_rng.cpp"

extern "C" CAMLprim double mi_chi_square_lpdf_unwrapped(double x, double nu) {
  return mi_catch([&] { return mi_chi_square_lpdf(x, nu); });
}

extern "C" CAMLprim value mi_chi_square_lpdf_wrapped(value x, value nu) {
  CAMLparam2(x, nu);
  CAMLreturn(caml_copy_double(mi_catch([&] {
    return mi_chi_square_lpdf(Double_val(x), Double_val(nu));
  })));
}

extern "C" CAMLprim double mi_chi_square_cdf_unwrapped(double x, double nu) {
  return mi_catch([&] { return mi_chi_square_cdf(x, nu); });
}

extern "C" CAMLprim value mi_chi_square_cdf_wrapped(value x, value nu) {
  CAMLparam2(x, nu);
  CAMLreturn(caml_copy_double(mi_catch([&] {
    return mi_chi_square_cdf(Double_val(x), Double_val(nu));
  })));
}

extern "C" CAMLprim double mi_chi_square_rng_unwrapped(double nu, value mt) {
  return mi_catch([&] { return mi_chi_square_rng(nu, Mi_rng_val(mt)); });
}

extern "C" CAMLprim value mi_chi_square_rng_wrapped(value nu, value mt) {
  CAMLparam2(nu, mt);
  CAMLreturn(caml_copy_double(mi_catch([&] {
    return mi_chi_square_rng(Double_val(nu), Mi_rng_val(mt));
  })));
}

#endif
