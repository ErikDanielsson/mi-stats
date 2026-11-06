#ifndef MI_RNG_CPP
#define MI_RNG_CPP

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/custom.h>
#include <caml/fail.h>

#include "../cpp/mi_rng.hpp"
#include "./mi_custom_block.cpp"

extern "C" CAMLprim value mi_rng_create(value seed) {
  CAMLparam1(seed);
  // The generator's state is stored inline, so nothing lives off-heap.
  CAMLreturn(mi_custom_block_alloc<mi_rng>(mi_rng(Long_val(seed)), 0));
}

#endif
