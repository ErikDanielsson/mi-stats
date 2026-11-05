-- Linear algebra implemented by the `mi_stats` OCaml library.
--
-- Note that the externals declared here are not part of the standard
-- Miking compiler's set of externals; a program using them must be
-- compiled by a compiler that includes `miStatsLinalgExtMap` (see
-- `linalg.ext-ocaml.mc`).

include "bool.mc"
include "float.mc"
include "seq.mc"
include "string.mc"

-- Handle to an Eigen matrix owned by the `mi_stats` OCaml library.
type MiStatsEigenMatrix

-- `data` is a single column with `length` rows.
type MiStatsVector = {length : Int, data : MiStatsEigenMatrix}

type MiStatsMatrix = {rows : Int, cols : Int, data : MiStatsEigenMatrix}


external externalMiStatsEigenMatrixOfColumn : [Float] -> MiStatsEigenMatrix
let miStatsVectorOfSeq : [Float] -> MiStatsVector = lam elements.
  { length = length elements
  , data = externalMiStatsEigenMatrixOfColumn elements
  }

external externalMiStatsEigenMatrixToColumn : MiStatsEigenMatrix -> [Float]
let miStatsVectorToSeq : MiStatsVector -> [Float] = lam v.
  externalMiStatsEigenMatrixToColumn v.data

-- Creates a matrix from its rows. Errors if the rows differ in length.
external externalMiStatsEigenMatrixOfRows : [[Float]] -> MiStatsEigenMatrix
let miStatsMatrixOfSeqExn : [[Float]] -> MiStatsMatrix = lam rows.
  let cols = if null rows then 0 else length (head rows) in
  let hasExpectedLength = lam row. eqi (length row) cols in
  if forAll hasExpectedLength rows then
    { rows = length rows
    , cols = cols
    , data = externalMiStatsEigenMatrixOfRows rows
    }
  else
    error "miStatsMatrixOfSeqExn: the rows differ in length"

-- Returns the rows of the matrix.
external externalMiStatsEigenMatrixToRows : MiStatsEigenMatrix -> [[Float]]
let miStatsMatrixToSeq : MiStatsMatrix -> [[Float]] = lam m.
  externalMiStatsEigenMatrixToRows m.data

-- Computes `a * x`. Errors if `a` does not have one column per element of `x`.
external externalMiStatsEigenMatrixMul : MiStatsEigenMatrix -> MiStatsEigenMatrix -> MiStatsEigenMatrix
let miStatsMatrixVectorMulExn : MiStatsMatrix -> MiStatsVector -> MiStatsVector =
  lam a. lam x.
    if eqi a.cols x.length then
      { length = a.rows
      , data = externalMiStatsEigenMatrixMul a.data x.data
      }
    else
      error (join
        [ "miStatsMatrixVectorMulExn: a matrix with ", int2string a.cols
        , " columns cannot multiply a vector of length ", int2string x.length
        ])

mexpr

let _eqVector = eqSeq eqf in
let _eqMatrix = eqSeq _eqVector in

-- Testing vector conversions
utest miStatsVectorToSeq (miStatsVectorOfSeq [1., 2., 3.]) with [1., 2., 3.] using _eqVector in
utest miStatsVectorToSeq (miStatsVectorOfSeq []) with [] using _eqVector in
utest (miStatsVectorOfSeq [1., 2., 3.]).length with 3 in
utest (miStatsVectorOfSeq []).length with 0 in

-- Testing matrix conversions
let m23 = miStatsMatrixOfSeqExn [[1., 2., 3.], [4., 5., 6.]] in
utest miStatsMatrixToSeq m23 with [[1., 2., 3.], [4., 5., 6.]] using _eqMatrix in
utest m23.rows with 2 in
utest m23.cols with 3 in

let m00 = miStatsMatrixOfSeqExn [] in
utest miStatsMatrixToSeq m00 with [] using _eqMatrix in
utest m00.rows with 0 in
utest m00.cols with 0 in

let m20 = miStatsMatrixOfSeqExn [[], []] in
utest miStatsMatrixToSeq m20 with [[], []] using _eqMatrix in
utest m20.rows with 2 in
utest m20.cols with 0 in

-- Testing the matrix-vector product
let product = miStatsMatrixVectorMulExn m23 (miStatsVectorOfSeq [1., 2., 3.]) in
utest miStatsVectorToSeq product with [14., 32.] using _eqVector in
utest product.length with 2 in

let identity = miStatsMatrixOfSeqExn [[1., 0.], [0., 1.]] in
let identityProduct = miStatsMatrixVectorMulExn identity (miStatsVectorOfSeq [7., 8.]) in
utest miStatsVectorToSeq identityProduct with [7., 8.] using _eqVector in

()
