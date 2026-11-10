#ifndef MI_ERROR_CPP
#define MI_ERROR_CPP

#include <cstdio>
#include <cstdlib>
#include <exception>

// Error handler for C++ exceptions from Stan
//
// If errors raised in C++ reach OCaml we get an opaque abort of the program.
// We instead catch the error on the C++ side, print the error message and
// terminate the program with exit code 1. Note that this early termination
// means that OCaml stdio might not be flushed

[[noreturn]] inline void mi_exit_with_error(const char *msg) noexcept {
  std::fprintf(stderr, "ERROR(mi-stats): %s\n", msg);
  std::fflush(stderr);
  std::_Exit(1);
}

template <typename F>
inline auto mi_catch(F &&f) -> decltype(f()) {
  try {
    return f();
  } catch (const std::exception &e) {
    mi_exit_with_error(e.what());
  } catch (...) {
    mi_exit_with_error("unknown error");
  }
}

#endif
