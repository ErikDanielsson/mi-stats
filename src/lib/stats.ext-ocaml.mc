-- OCaml implementations of the externals declared in `stats.mc`.
--
-- A compiler that wants to support these externals should add
-- `miStatsExtMap` to the external implementations it passes to
-- `compileMCore`, e.g.:
--
--   { mkEmptyHooks compileOcaml with
--     externalImpls = mapUnion globalExternalImplsMap miStatsExtMap }
--
-- The generated OCaml code depends on the `mi_stats` OCaml library,
-- which must thus be findable by `ocamlfind` (e.g., via `OCAMLPATH`).

include "map.mc"
include "string.mc"
include "ocaml/ast.mc"
include "mexpr/ast-builder.mc"

let miStatsExtMap =
  use OCamlTypeAst in
  mapFromSeq cmpString
  [
    ("externalBernoulliLogPmf", [
      { expr = "Mi_stats.mi_bernoulli_lpmf",
        ty = tyarrows_ [tybool_, tyfloat_, tyfloat_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalBernoulliSample", [
      { expr = "Mi_stats.mi_bernoulli_rng_",
        ty = tyarrows_ [tyfloat_, tybool_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalBinomialLogPmf", [
      { expr = "Mi_stats.mi_binomial_lpmf",
        ty = tyarrows_ [tyint_, tyint_, tyfloat_, tyfloat_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalBinomialSample", [
      { expr = "Mi_stats.mi_binomial_rng_",
        ty = tyarrows_ [tyint_, tyfloat_, tyint_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalBetaLogPdf", [
      { expr = "Mi_stats.mi_beta_lpdf",
        ty = tyarrows_ [tyfloat_, tyfloat_, tyfloat_, tyfloat_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalBetaSample", [
      { expr = "Mi_stats.mi_beta_rng_",
        ty = tyarrows_ [tyfloat_, tyfloat_, tyfloat_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalBetaBinomialLogPmf", [
      { expr = "Mi_stats.mi_beta_binomial_lpmf",
        ty = tyarrows_ [tyint_, tyint_, tyfloat_, tyfloat_, tyfloat_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalBetaBinomialSample", [
      { expr = "Mi_stats.mi_beta_binomial_rng_",
        ty = tyarrows_ [tyint_, tyfloat_, tyfloat_, tyint_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalChiSquareLogPdf", [
      { expr = "Mi_stats.mi_chi_square_lpdf",
        ty = tyarrows_ [tyfloat_, tyfloat_, tyfloat_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalChiSquareCdf", [
      { expr = "Mi_stats.mi_chi_square_cdf",
        ty = tyarrows_ [tyfloat_, tyfloat_, tyfloat_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalChiSquareSample", [
      { expr = "Mi_stats.mi_chi_square_rng_",
        ty = tyarrows_ [tyfloat_, tyfloat_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalDiscreteRangeLogPmf", [
      { expr = "Mi_stats.mi_discrete_range_lpmf",
        ty = tyarrows_ [tyint_, tyint_, tyint_, tyfloat_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalDiscreteRangeSample", [
      { expr = "Mi_stats.mi_discrete_range_rng_",
        ty = tyarrows_ [tyint_, tyint_, tyint_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalExponentialLogPdf", [
      { expr = "Mi_stats.mi_exponential_lpdf",
        ty = tyarrows_ [tyfloat_, tyfloat_, tyfloat_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalExponentialSample", [
      { expr = "Mi_stats.mi_exponential_rng_",
        ty = tyarrows_ [tyfloat_, tyfloat_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalGammaLogPdf", [
      { expr = "Mi_stats.mi_gamma_lpdf",
        ty = tyarrows_ [tyfloat_, tyfloat_, tyfloat_, tyfloat_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalGammaCdf", [
      { expr = "Mi_stats.mi_gamma_cdf",
        ty = tyarrows_ [tyfloat_, tyfloat_, tyfloat_, tyfloat_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalGammaSample", [
      { expr = "Mi_stats.mi_gamma_rng_",
        ty = tyarrows_ [tyfloat_, tyfloat_, tyfloat_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalNegBinomialLogPmf", [
      { expr = "Mi_stats.mi_neg_binomial_lpmf",
        ty = tyarrows_ [tyint_, tyfloat_, tyfloat_, tyfloat_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalNegBinomialSample", [
      { expr = "Mi_stats.mi_neg_binomial_rng_",
        ty = tyarrows_ [tyfloat_, tyfloat_, tyint_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalPoissonLogPmf", [
      { expr = "Mi_stats.mi_poisson_lpmf",
        ty = tyarrows_ [tyint_, tyfloat_, tyfloat_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalPoissonSample", [
      { expr = "Mi_stats.mi_poisson_rng_",
        ty = tyarrows_ [tyfloat_, tyint_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalNormalLogPdf", [
      { expr = "Mi_stats.mi_normal_lpdf",
        ty = tyarrows_ [tyfloat_, tyfloat_, tyfloat_, tyfloat_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalNormalSample", [
      { expr = "Mi_stats.mi_normal_rng_",
        ty = tyarrows_ [tyfloat_, tyfloat_, tyfloat_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalParetoType2LogPdf", [
      { expr = "Mi_stats.mi_pareto_type_2_lpdf",
        ty = tyarrows_ [tyfloat_, tyfloat_, tyfloat_, tyfloat_, tyfloat_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalParetoType2Sample", [
      { expr = "Mi_stats.mi_pareto_type_2_rng_",
        ty = tyarrows_ [tyfloat_, tyfloat_, tyfloat_, tyfloat_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalUniformLogPdf", [
      { expr = "Mi_stats.mi_uniform_lpdf",
        ty = tyarrows_ [tyfloat_, tyfloat_, tyfloat_, tyfloat_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalUniformSample", [
      { expr = "Mi_stats.mi_uniform_rng_",
        ty = tyarrows_ [tyfloat_, tyfloat_, tyfloat_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalMiStatsSetSeed", [
      { expr = "Mi_stats.mi_set_seed",
        ty = tyarrows_ [tyint_, otyunit_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ])
  ]
