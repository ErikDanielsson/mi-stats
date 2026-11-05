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
include "ext/math-ext.mc"

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

let miStatsMatrixMulExn : MiStatsMatrix -> MiStatsMatrix -> MiStatsMatrix =
  lam a. lam b.
    if eqi a.cols b.rows then
      { rows = a.rows
      , cols = b.cols
      , data = externalMiStatsEigenMatrixMul a.data b.data
      }
    else
      error (join
        [ "miStatsMatrixMulExn: a matrix with ", int2string a.cols
        , " columns cannot multiply a vector of matrix with ", int2string b.rows
        , "rows"
        ])


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

-- Computes `exp(A)`. Errors if `A` is not square
external externalMiStatsMatrixExp : MiStatsEigenMatrix -> MiStatsEigenMatrix
let miStatsMatrixExp : MiStatsMatrix -> MiStatsMatrix =
  lam a. 
    if eqi a.cols a.rows then
      { cols = a.cols
      , rows = a.rows
      , data = externalMiStatsMatrixExp a.data
      }
    else
      error (join
        [ "externalMiStatsMatrixExp: a matrix with "
        , int2string a.cols
        , "cols and "
        , int2string a.rows
        , "rows is not square and has no exponential"
        ])

mexpr

let eqVector = eqSeq eqf in
let eqMatrix = eqSeq eqVector in

let _eqf = eqfApprox 1e-15 in
let _eqVector = eqSeq _eqf in
let _eqMatrix = eqSeq _eqVector in

-- Testing vector conversions
utest miStatsVectorToSeq (miStatsVectorOfSeq [1., 2., 3.]) with [1., 2., 3.] using eqVector in
utest miStatsVectorToSeq (miStatsVectorOfSeq []) with [] using eqVector in
utest (miStatsVectorOfSeq [1., 2., 3.]).length with 3 in
utest (miStatsVectorOfSeq []).length with 0 in

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

-- 
-- Linear algebra operations
--
let simpleRange = lam n. range 0 n 1 in
let zerosSeq = lam n. lam m. (make n (make m 0. )) in
let zeros = lam n. lam m. miStatsMatrixOfSeqExn (zerosSeq n m) in
let kindaKronDeltaSeq = lam n. lam v. lam i.
  map (lam j. if eqi i j then v else 0.) (simpleRange n)
in
let identitySeq = lam n.
  map (kindaKronDeltaSeq n 1.) (simpleRange n)
in
let identity = lam n.
  miStatsMatrixOfSeqExn (identitySeq n)
in
let diagonalSeq = lam d.
  let n = length d in
  mapi (lam i. lam v. kindaKronDeltaSeq n v i) d
in
let diagonal = lam d. miStatsMatrixOfSeqExn (diagonalSeq d) in

let z22 = zeros 2 2 in
let i2 = identity 2 in
let i4 = identity 4 in
let z1010 = zeros 10 10 in
let i10 = identity 10 in
let d4 = diagonal [1., 2., 4., 0.] in

-- Matrix-vector product
let product = miStatsMatrixVectorMulExn m23 (miStatsVectorOfSeq [1., 2., 3.]) in
utest miStatsVectorToSeq product with [14., 32.] using eqVector in
utest product.length with 2 in

let identityProduct = miStatsMatrixVectorMulExn i2 (miStatsVectorOfSeq [7., 8.]) in
utest miStatsVectorToSeq identityProduct with [7., 8.] using eqVector in

-- Matrix-matrix product
let product = miStatsMatrixMulExn d4 d4 in
let rhs = miStatsMatrixToSeq (diagonal [1., 4., 16., 0.]) in
utest miStatsMatrixToSeq product with rhs using eqMatrix in

let identityProduct = miStatsMatrixMulExn i4 d4  in
utest miStatsMatrixToSeq identityProduct with miStatsMatrixToSeq d4 using eqMatrix in

let identityProduct = miStatsMatrixMulExn d4 i4 in
utest miStatsMatrixToSeq identityProduct with miStatsMatrixToSeq d4 using eqMatrix in

-- Matrix exponential
let zeroExp = miStatsMatrixExp z22 in 
utest miStatsMatrixToSeq zeroExp with miStatsMatrixToSeq i2 using eqMatrix in

let zeroExp = miStatsMatrixExp z1010 in 
utest miStatsMatrixToSeq zeroExp with miStatsMatrixToSeq i10 using eqMatrix in

let diagonalExp = miStatsMatrixExp d4 in 
utest miStatsMatrixToSeq diagonalExp with diagonalSeq (map exp [1., 2., 4., 0.]) using _eqMatrix in

()
