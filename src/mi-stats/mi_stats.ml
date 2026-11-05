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

external mi_matrix_of_column : float array -> mi_matrix = "mi_matrix_of_column_stub"
external mi_matrix_of_rows : float array array -> mi_matrix = "mi_matrix_of_rows_stub"
external mi_matrix_to_column : mi_matrix -> float array = "mi_matrix_to_column_stub"
external mi_matrix_to_rows : mi_matrix -> float array array = "mi_matrix_to_rows_stub"
external mi_matrix_mul : mi_matrix -> mi_matrix -> mi_matrix = "mi_matrix_mul_stub"
external mi_matrix_exp : mi_matrix -> mi_matrix = "mi_matrix_exp_stub"
