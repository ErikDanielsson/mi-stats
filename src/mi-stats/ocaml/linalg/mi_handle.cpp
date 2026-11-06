#ifndef MI_HANDLE_CPP
#define MI_HANDLE_CPP

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/custom.h>

#include <new>
#include <utility>

// A handle is an OCaml custom block containing a C++ container of type
// T. The elements of T live outside the OCaml heap, and are freed when
// the GC finalizes the block.

// Get an lvalue for the container from an OCaml value
template <typename T>
static T &mi_handle_val(value v) {
  return *static_cast<T *>(Data_custom_val(v));
}

template <typename T>
static void mi_handle_finalize(value v) {
  // Pairs with the placement new in mi_handle_alloc
  mi_handle_val<T>(v).~T();
}

template <typename T>
static struct custom_operations mi_handle_ops {
  "mi_handle",
  mi_handle_finalize<T>,
  custom_compare_default,
  custom_hash_default,
  custom_serialize_default,
  custom_deserialize_default
};

// Moves `container` into a new handle, telling the GC the size of the
// elements so that it accounts for them when deciding when to collect.
template <typename T>
static value mi_handle_alloc(T container) {
  mlsize_t elements_size = container.size() * sizeof(typename T::value_type);
  value v = caml_alloc_custom_mem(&mi_handle_ops<T>, sizeof(T), elements_size);
  new (Data_custom_val(v)) T(std::move(container));
  return v;
}

#endif
