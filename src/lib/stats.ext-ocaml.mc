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
    ("externalMiStatsSetSeed", [
      { expr = "Mi_stats.mi_set_seed",
        ty = tyarrows_ [tyint_, otyunit_],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ])
  ]
