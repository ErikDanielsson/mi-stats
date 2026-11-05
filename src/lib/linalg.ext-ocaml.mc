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
  let tyColumn = otyarray_ tyfloat_ in
  let tyRows = otyarray_ tyColumn in
  mapFromSeq cmpString
  [
    ("externalMiStatsEigenMatrixOfColumn", [
      { expr = "Mi_stats.mi_matrix_of_column",
        ty = tyarrows_ [tyColumn, tyMatrix],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalMiStatsEigenMatrixOfRows", [
      { expr = "Mi_stats.mi_matrix_of_rows",
        ty = tyarrows_ [tyRows, tyMatrix],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ]),
    ("externalMiStatsEigenMatrixToColumn", [
      { expr = "Mi_stats.mi_matrix_to_column",
        ty = tyarrows_ [tyMatrix, tyColumn],
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
    ("externalMiStatsEigenMatrixMul", [
      { expr = "Mi_stats.mi_matrix_mul",
        ty = tyarrows_ [tyMatrix, tyMatrix, tyMatrix],
        libraries = ["mi_stats"],
        cLibraries = []
      }
    ])
  ]
