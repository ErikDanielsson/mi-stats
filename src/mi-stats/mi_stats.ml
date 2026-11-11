type mi_rng

external create_rng : int -> mi_rng = "mi_rng_create"

let global_rng = ref (create_rng 0)

let mi_set_seed : int -> unit = fun seed -> global_rng := create_rng seed

external mi_normal_lpdf : (float [@unboxed]) -> (float [@unboxed]) -> (float [@unboxed]) -> (float [@unboxed])
  = "mi_normal_lpdf_wrapped" "mi_normal_lpdf_unwrapped" [@@noalloc]
external mi_normal_rng : (float [@unboxed]) -> (float [@unboxed]) -> mi_rng -> (float [@unboxed])
  = "mi_normal_rng_wrapped" "mi_normal_rng_unwrapped" [@@noalloc]
let mi_normal_rng_ : float -> float -> float = fun a b -> mi_normal_rng a b !global_rng

external mi_gamma_lpdf : (float [@unboxed]) -> (float [@unboxed]) -> (float [@unboxed]) -> (float [@unboxed])
  = "mi_gamma_lpdf_wrapped" "mi_gamma_lpdf_unwrapped" [@@noalloc]
external mi_gamma_cdf : (float [@unboxed]) -> (float [@unboxed]) -> (float [@unboxed]) -> (float [@unboxed])
  = "mi_gamma_cdf_wrapped" "mi_gamma_cdf_unwrapped" [@@noalloc]
external mi_gamma_rng : (float [@unboxed]) -> (float [@unboxed]) -> mi_rng -> (float [@unboxed])
  = "mi_gamma_rng_wrapped" "mi_gamma_rng_unwrapped" [@@noalloc]
let mi_gamma_rng_ : float -> float -> float = fun a b -> mi_gamma_rng a b !global_rng

external mi_beta_lpdf : (float [@unboxed]) -> (float [@unboxed]) -> (float [@unboxed]) -> (float [@unboxed])
  = "mi_beta_lpdf_wrapped" "mi_beta_lpdf_unwrapped" [@@noalloc]
external mi_beta_rng : (float [@unboxed]) -> (float [@unboxed]) -> mi_rng -> (float [@unboxed])
  = "mi_beta_rng_wrapped" "mi_beta_rng_unwrapped" [@@noalloc]
let mi_beta_rng_ : float -> float -> float = fun a b -> mi_beta_rng a b !global_rng

external mi_bernoulli_lpmf : bool -> (float [@unboxed]) -> (float [@unboxed])
  = "mi_bernoulli_lpmf_wrapped" "mi_bernoulli_lpmf_unwrapped" [@@noalloc]
external mi_bernoulli_rng : (float [@unboxed]) -> mi_rng -> bool
  = "mi_bernoulli_rng_wrapped" "mi_bernoulli_rng_unwrapped" [@@noalloc]
let mi_bernoulli_rng_ : float -> bool = fun p -> mi_bernoulli_rng p !global_rng

external mi_binomial_lpmf : int -> int -> (float [@unboxed]) -> (float [@unboxed])
  = "mi_binomial_lpmf_wrapped" "mi_binomial_lpmf_unwrapped" [@@noalloc]
external mi_binomial_rng : int -> (float [@unboxed]) -> mi_rng -> int
  = "mi_binomial_rng_wrapped" "mi_binomial_rng_unwrapped" [@@noalloc]
let mi_binomial_rng_ : int -> float -> int = fun n p -> mi_binomial_rng n p !global_rng

external mi_beta_binomial_lpmf : int -> int -> (float [@unboxed]) -> (float [@unboxed]) -> (float [@unboxed])
  = "mi_beta_binomial_lpmf_wrapped" "mi_beta_binomial_lpmf_unwrapped" [@@noalloc]
external mi_beta_binomial_rng : int -> (float [@unboxed]) -> (float [@unboxed]) -> mi_rng -> int
  = "mi_beta_binomial_rng_wrapped" "mi_beta_binomial_rng_unwrapped" [@@noalloc]
let mi_beta_binomial_rng_ : int -> float -> float -> int = fun n a b -> mi_beta_binomial_rng n a b !global_rng

external mi_chi_square_lpdf : (float [@unboxed]) -> (float [@unboxed]) -> (float [@unboxed])
  = "mi_chi_square_lpdf_wrapped" "mi_chi_square_lpdf_unwrapped" [@@noalloc]
external mi_chi_square_cdf : (float [@unboxed]) -> (float [@unboxed]) -> (float [@unboxed])
  = "mi_chi_square_cdf_wrapped" "mi_chi_square_cdf_unwrapped" [@@noalloc]
external mi_chi_square_rng : (float [@unboxed]) -> mi_rng -> (float [@unboxed])
  = "mi_chi_square_rng_wrapped" "mi_chi_square_rng_unwrapped" [@@noalloc]
let mi_chi_square_rng_ : float -> float = fun nu -> mi_chi_square_rng nu !global_rng

external mi_exponential_lpdf : (float [@unboxed]) -> (float [@unboxed]) -> (float [@unboxed])
  = "mi_exponential_lpdf_wrapped" "mi_exponential_lpdf_unwrapped" [@@noalloc]
external mi_exponential_rng : (float [@unboxed]) -> mi_rng -> (float [@unboxed])
  = "mi_exponential_rng_wrapped" "mi_exponential_rng_unwrapped" [@@noalloc]
let mi_exponential_rng_ : float -> float = fun beta -> mi_exponential_rng beta !global_rng

external mi_neg_binomial_lpmf : int -> (float [@unboxed]) -> (float [@unboxed]) -> (float [@unboxed])
  = "mi_neg_binomial_lpmf_wrapped" "mi_neg_binomial_lpmf_unwrapped" [@@noalloc]
external mi_neg_binomial_rng : (float [@unboxed]) -> (float [@unboxed]) -> mi_rng -> int
  = "mi_neg_binomial_rng_wrapped" "mi_neg_binomial_rng_unwrapped" [@@noalloc]
let mi_neg_binomial_rng_ : float -> float -> int = fun alpha beta -> mi_neg_binomial_rng alpha beta !global_rng

external mi_poisson_lpmf : int -> (float [@unboxed]) -> (float [@unboxed])
  = "mi_poisson_lpmf_wrapped" "mi_poisson_lpmf_unwrapped" [@@noalloc]
external mi_poisson_rng : (float [@unboxed]) -> mi_rng -> int
  = "mi_poisson_rng_wrapped" "mi_poisson_rng_unwrapped" [@@noalloc]
let mi_poisson_rng_ : float -> int = fun lambda -> mi_poisson_rng lambda !global_rng
external mi_uniform_lpdf : (float [@unboxed]) -> (float [@unboxed]) -> (float [@unboxed]) -> (float [@unboxed])
  = "mi_uniform_lpdf_wrapped" "mi_uniform_lpdf_unwrapped" [@@noalloc]
external mi_uniform_rng : (float [@unboxed]) -> (float [@unboxed]) -> mi_rng -> (float [@unboxed])
  = "mi_uniform_rng_wrapped" "mi_uniform_rng_unwrapped" [@@noalloc]
let mi_uniform_rng_ : float -> float -> float = fun alpha beta -> mi_uniform_rng alpha beta !global_rng

external mi_discrete_range_lpmf : int -> int -> int -> (float [@unboxed])
  = "mi_discrete_range_lpmf_wrapped" "mi_discrete_range_lpmf_unwrapped" [@@noalloc]
external mi_discrete_range_rng : int -> int -> mi_rng -> int
  = "mi_discrete_range_rng_wrapped" "mi_discrete_range_rng_unwrapped" [@@noalloc]
let mi_discrete_range_rng_ : int -> int -> int = fun lower upper -> mi_discrete_range_rng lower upper !global_rng

external mi_pareto_type_2_lpdf : (float [@unboxed]) -> (float [@unboxed]) -> (float [@unboxed]) -> (float [@unboxed]) -> (float [@unboxed])
  = "mi_pareto_type_2_lpdf_wrapped" "mi_pareto_type_2_lpdf_unwrapped" [@@noalloc]
external mi_pareto_type_2_rng : (float [@unboxed]) -> (float [@unboxed]) -> (float [@unboxed]) -> mi_rng -> (float [@unboxed])
  = "mi_pareto_type_2_rng_wrapped" "mi_pareto_type_2_rng_unwrapped" [@@noalloc]
let mi_pareto_type_2_rng_ : float -> float -> float -> float = fun mu lambda alpha -> mi_pareto_type_2_rng mu lambda alpha !global_rng
