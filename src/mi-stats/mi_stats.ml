type mi_rng

external create_rng : int -> mi_rng = "mi_rng_create"

let global_rng = ref (create_rng 0)

let mi_set_seed : int -> unit = fun seed -> global_rng := create_rng seed

external mi_normal_lpdf : (float [@unboxed]) -> (float [@unboxed]) -> (float [@unboxed]) -> (float [@unboxed])
  = "mi_normal_lpdf_wrapped" "mi_normal_lpdf_unwrapped" [@@noalloc]
external mi_normal_rng : (float [@unboxed]) -> (float [@unboxed]) -> mi_rng -> (float [@unboxed])
  = "mi_normal_rng_wrapped" "mi_normal_rng_unwrapped" [@@noalloc]
let mi_normal_rng_ : float -> float -> float = fun a b -> mi_normal_rng a b !global_rng

external mi_bernoulli_lpmf : bool -> (float [@unboxed]) -> (float [@unboxed])
  = "mi_bernoulli_lpmf_wrapped" "mi_bernoulli_lpmf_unwrapped" [@@noalloc]
external mi_bernoulli_rng : (float [@unboxed]) -> mi_rng -> bool
  = "mi_bernoulli_rng_wrapped" "mi_bernoulli_rng_unwrapped" [@@noalloc]
let mi_bernoulli_rng_ : float -> bool = fun p -> mi_bernoulli_rng p !global_rng

type mi_matrix

external mi_matrix_of_rows : float array array -> mi_matrix = "mi_matrix_of_rows_stub"
external mi_matrix_to_rows : mi_matrix -> float array array = "mi_matrix_to_rows_stub"

type mi_vector

external mi_vector_of_float_array : float array -> mi_vector = "mi_vector_of_float_array_stub"
external mi_vector_to_float_array : mi_vector -> float array = "mi_vector_to_float_array_stub"

type mi_int_array

external mi_int_array_of_ocaml_array : int array -> mi_int_array = "mi_int_array_of_ocaml_array_stub"
external mi_int_array_to_ocaml_array : mi_int_array -> int array = "mi_int_array_to_ocaml_array_stub"
