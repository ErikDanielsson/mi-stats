-- OCaml implementations of the externals declared in `linalg.mc`.
--
-- A compiler that wants to support these externals should add
-- `miStatsLinalgExtMap` to the external implementations it passes to
-- `compileMCore`. This map is independent of `miStatsExtMap`, so
-- each can be added without the other.
--
-- The generated OCaml code depends on the `mi_stats` OCaml library,
-- which must thus be findable by `ocamlfind` (e.g., via `OCAMLPATH`).

include "map.mc"
include "string.mc"
include "ocaml/ast.mc"
include "mexpr/ast-builder.mc"

let miStatsLinalgExtMap =
  use OCamlTypeAst in
  let tyMatrix = otyvarext_ "Mi_stats.mi_matrix" [] in
  let tyVector = otyvarext_ "Mi_stats.mi_vector" [] in
  let tyIntArray = otyvarext_ "Mi_stats.mi_int_array" [] in
  let tyFloats = otyarray_ tyfloat_ in
  let tyRows = otyarray_ tyFloats in
  let tyInts = otyarray_ tyint_ in
  mapFromSeq cmpString
  [
    ("externalMiStatsEigenMatrixOfRows", [
      { expr = "Mi_stats.mi_matrix_of_rows",
        ty = tyarrows_ [tyRows, tyMatrix],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalMiStatsEigenMatrixToRows", [
      { expr = "Mi_stats.mi_matrix_to_rows",
        ty = tyarrows_ [tyMatrix, tyRows],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalMiStatsEigenVectorOfSeq", [
      { expr = "Mi_stats.mi_vector_of_float_array",
        ty = tyarrows_ [tyFloats, tyVector],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalMiStatsEigenVectorToSeq", [
      { expr = "Mi_stats.mi_vector_to_float_array",
        ty = tyarrows_ [tyVector, tyFloats],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalMiStatsStdVectorIntOfSeq", [
      { expr = "Mi_stats.mi_int_array_of_ocaml_array",
        ty = tyarrows_ [tyInts, tyIntArray],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalMiStatsStdVectorIntToSeq", [
      { expr = "Mi_stats.mi_int_array_to_ocaml_array",
        ty = tyarrows_ [tyIntArray, tyInts],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ])
  ]
