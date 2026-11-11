#ifndef MI_PARETO_TYPE_2_CPP
#define MI_PARETO_TYPE_2_CPP

#include "../cpp/mi_pareto_type_2.hpp"
#include "./mi_error.cpp"
#include "./mi_rng.cpp"

extern "C" CAMLprim double mi_pareto_type_2_lpdf_unwrapped(double x, double mu, double lambda, double alpha) {
  return mi_catch([&] { return mi_pareto_type_2_lpdf(x, mu, lambda, alpha); });
}

extern "C" CAMLprim value mi_pareto_type_2_lpdf_wrapped(value x, value mu, value lambda, value alpha) {
  CAMLparam4(x, mu, lambda, alpha);
  CAMLreturn(caml_copy_double(mi_catch([&] {
    return mi_pareto_type_2_lpdf(Double_val(x), Double_val(mu), Double_val(lambda), Double_val(alpha));
  })));
}

extern "C" CAMLprim double mi_pareto_type_2_rng_unwrapped(double mu, double lambda, double alpha, value mt) {
  return mi_catch([&] { return mi_pareto_type_2_rng(mu, lambda, alpha, Mi_rng_val(mt)); });
}

extern "C" CAMLprim value mi_pareto_type_2_rng_wrapped(value mu, value lambda, value alpha, value mt) {
  CAMLparam4(mu, lambda, alpha, mt);
  CAMLreturn(caml_copy_double(mi_catch([&] {
    return mi_pareto_type_2_rng(Double_val(mu), Double_val(lambda), Double_val(alpha), Mi_rng_val(mt));
  })));
}

#endif
