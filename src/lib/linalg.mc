-- Types mirroring the C++ types used by Stan Math, implemented by the
-- `mi_stats` OCaml library.
--
-- Note that the externals declared here are not part of the standard
-- Miking compiler's set of externals; a program using them must be
-- compiled by a compiler that includes `miStatsLinalgExtMap` (see
-- `linalg.ext-ocaml.mc`).

include "bool.mc"
include "float.mc"
include "seq.mc"

-- Handle to an `Eigen::MatrixXd` owned by the `mi_stats` OCaml library.
type MiStatsEigenMatrix
type MiStatsMatrix =
  { rows : Int
  , cols : Int
  , data : MiStatsEigenMatrix
  }

-- Handle to an `Eigen::VectorXd` owned by the `mi_stats` OCaml library.
type MiStatsEigenVector
type MiStatsVector =
  {length : Int
  , data : MiStatsEigenVector
  }

-- Handle to a `std::vector<int>` owned by the `mi_stats` OCaml library.
type MiStatsStdVectorInt
type MiStatsInt32Array =
  { length : Int
  , data : MiStatsStdVectorInt
  }

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

external externalMiStatsEigenVectorOfSeq : [Float] -> MiStatsEigenVector
let miStatsVectorOfSeq : [Float] -> MiStatsVector = lam elements.
  { length = length elements
  , data = externalMiStatsEigenVectorOfSeq elements
  }

external externalMiStatsEigenVectorToSeq : MiStatsEigenVector -> [Float]
let miStatsVectorToSeq : MiStatsVector -> [Float] = lam v.
  externalMiStatsEigenVectorToSeq v.data

-- Creates an integer array. Elements that do not fit in a C++ `int` are truncated.
external externalMiStatsStdVectorIntOfSeq : [Int] -> MiStatsStdVectorInt
let miStatsInt32ArrayOfSeq : [Int] -> MiStatsInt32Array = lam elements.
  { length = length elements
  , data = externalMiStatsStdVectorIntOfSeq elements
  }

external externalMiStatsStdVectorIntToSeq : MiStatsStdVectorInt -> [Int]
let miStatsInt32ArrayToSeq : MiStatsInt32Array -> [Int] = lam a.
  externalMiStatsStdVectorIntToSeq a.data

mexpr

let eqVector = eqSeq eqf in
let eqMatrix = eqSeq eqVector in
let eqIntArray = eqSeq eqi in

-- Testing matrix conversions
let m23 = miStatsMatrixOfSeqExn [[1., 2., 3.], [4., 5., 6.]] in
utest miStatsMatrixToSeq m23 with [[1., 2., 3.], [4., 5., 6.]] using eqMatrix in
utest m23.rows with 2 in
utest m23.cols with 3 in

let m00 = miStatsMatrixOfSeqExn [] in
utest miStatsMatrixToSeq m00 with [] using eqMatrix in
utest m00.rows with 0 in
utest m00.cols with 0 in

let m20 = miStatsMatrixOfSeqExn [[], []] in
utest miStatsMatrixToSeq m20 with [[], []] using eqMatrix in
utest m20.rows with 2 in
utest m20.cols with 0 in

-- Testing vector conversions
let v3 = miStatsVectorOfSeq [1., 2., 3.] in
utest miStatsVectorToSeq v3 with [1., 2., 3.] using eqVector in
utest v3.length with 3 in

let v0 = miStatsVectorOfSeq [] in
utest miStatsVectorToSeq v0 with [] using eqVector in
utest v0.length with 0 in

-- Testing integer array conversions
let a3 = miStatsInt32ArrayOfSeq [2147483647, 0, negi 2147483648] in
utest miStatsInt32ArrayToSeq a3 with [2147483647, 0, negi 2147483648] using eqIntArray in
utest a3.length with 3 in

let a0 = miStatsInt32ArrayOfSeq [] in
utest miStatsInt32ArrayToSeq a0 with [] using eqIntArray in
utest a0.length with 0 in

()
