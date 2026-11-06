#ifndef MI_CUSTOM_BLOCK_CPP
#define MI_CUSTOM_BLOCK_CPP

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/custom.h>

#include <new>
#include <utility>

// An OCaml custom block containing a C++ object of type T. Anything the
// object allocates lives outside the OCaml heap, and is freed when the
// GC finalizes the block.

// Get an lvalue for the object from an OCaml value
template <typename T>
static T &mi_custom_block_val(value v) {
  return *static_cast<T *>(Data_custom_val(v));
}

template <typename T>
static void mi_custom_block_finalize(value v) {
  // Pairs with the placement new in mi_custom_block_alloc
  mi_custom_block_val<T>(v).~T();
}

template <typename T>
static struct custom_operations mi_custom_block_ops {
  "mi_custom_block",
  mi_custom_block_finalize<T>,
  custom_compare_default,
  custom_hash_default,
  custom_serialize_default,
  custom_deserialize_default
};

// Moves `object` into a new custom block, telling the GC how many bytes
// the object keeps alive outside the OCaml heap, so that it accounts for
// them when deciding when to collect.
template <typename T>
static value mi_custom_block_alloc(T object, mlsize_t off_heap_size) {
  value v = caml_alloc_custom_mem(&mi_custom_block_ops<T>, sizeof(T), off_heap_size);
  new (Data_custom_val(v)) T(std::move(object));
  return v;
}

template <typename T>
static value mi_custom_block_alloc_container(T container) {
  mlsize_t elements_size = container.size() * sizeof(typename T::value_type);
  return mi_custom_block_alloc<T>(std::move(container), elements_size);
}

#endif
