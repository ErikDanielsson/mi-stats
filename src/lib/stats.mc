-- Statistics functions implemented by the `mi_stats` OCaml library.
--
-- Note that the externals declared here are not part of the standard
-- Miking compiler's set of externals; a program using them must be
-- compiled by a compiler that includes `miStatsExtMap` (see
-- `stats.ext-ocaml.mc`).

include "math.mc"
include "bool.mc"
include "float.mc"
include "ext/math-ext.mc"

-- Bernoulli
external externalBernoulliLogPmf : Bool -> Float -> Float
external externalBernoulliSample ! : Float -> Bool
let bernoulliPmf = lam p:Float. lam x:Bool.
  exp (externalBernoulliLogPmf x p)
let bernoulliLogPmf = lam p:Float. lam x:Bool.
  externalBernoulliLogPmf x p
let bernoulliSample = lam p:Float.
  externalBernoulliSample p

-- Gamma, with shape alpha and rate beta (as in Stan)
external externalGammaLogPdf : Float -> Float -> Float -> Float
external externalGammaCdf : Float -> Float -> Float -> Float
external externalGammaSample ! : Float -> Float -> Float
let gammaPdf = lam alpha:Float. lam beta:Float. lam x:Float.
  exp (externalGammaLogPdf x alpha beta)
let gammaLogPdf = lam alpha:Float. lam beta:Float. lam x:Float.
  externalGammaLogPdf x alpha beta
let gammaCdf = lam alpha:Float. lam beta:Float. lam x:Float.
  externalGammaCdf x alpha beta
let gammaSample = lam alpha:Float. lam beta:Float.
  externalGammaSample alpha beta

-- Normal
external externalNormalLogPdf : Float -> Float -> Float -> Float
external externalNormalSample ! : Float -> Float -> Float
let normalPdf = lam mu:Float. lam sigma:Float. lam x:Float.
  exp (externalNormalLogPdf x mu sigma)
let normalLogPdf = lam mu:Float. lam sigma:Float. lam x:Float.
  externalNormalLogPdf x mu sigma
let normalSample = lam mu:Float. lam sigma:Float.
  externalNormalSample mu sigma

-- Seed
external externalMiStatsSetSeed ! : Int -> ()
-- Sets the seed used by the sampling functions in this file. Note
-- that this is independent of the seed set by `setSeed` in
-- `ext/dist-ext.mc` in the standard library.
let miStatsSetSeed : Int -> () = lam seed.
  externalMiStatsSetSeed seed

mexpr

-- Functions for testing floats. Should perhaps be in another library.
let maxf = lam r. lam l. if gtf r l then r else l in
let absf = lam f. maxf f (negf f) in
let eqfApprox = lam epsilon. lam r. lam l.
  if leqf (absf (subf r l)) epsilon then true else false in
let _eqf = eqfApprox 1e-11 in

-- Testing Bernoulli
utest bernoulliPmf 0.3 false with 0.7 using _eqf in
utest bernoulliPmf 0.3 true with 0.3 using _eqf in
utest exp (bernoulliLogPmf 0.6 true) with 0.6 using _eqf in
utest exp (bernoulliLogPmf 0.6 false) with 0.4 using _eqf in
utest bernoulliPmf 0. false with 1. using _eqf in
utest bernoulliLogPmf 0. true with negf inf using eqf in
utest bernoulliPmf 1. true with 1. using _eqf in
utest bernoulliLogPmf 1. false with negf inf using eqf in
utest bernoulliSample 0. with false in
utest bernoulliSample 1. with true in
utest bernoulliSample 0.6 with false using lam. lam. true in

-- Testing Gamma (the values distinguish shape and rate from shape and scale)
utest gammaPdf 2. 3. 1. with 0.448083615311 using _eqf in
utest gammaLogPdf 3. 2. 0.5 with -1. using _eqf in
utest gammaCdf 2. 3. 1. with 0.800851726529 using _eqf in
utest gammaCdf 1. 2. 0.5 with 0.632120558829 using _eqf in
utest gammaSample 1. 1000000. with 0. using lam a. lam b. and (geqf a 0.) (ltf a 0.01) in

-- Testing Normal (the values distinguish mu and sigma, and sigma from the variance)
utest normalPdf 0. 0.4472 0. with 0.8920891779996 using _eqf in
utest exp (normalLogPdf 2. 1. 2.) with 0.3989422804 using _eqf in
utest exp (normalLogPdf 1. 2. 3.) with 0.12098536226 using _eqf in
utest normalPdf 2. 3. 1. with 0.125794409231 using _eqf in
utest normalSample 0. 0.2 with 0. using lam a. lam b. or (leqf a b) (geqf a b) in

-- Testing seed
utest miStatsSetSeed 0; normalSample 0. 1.; normalSample 0. 1.
with  miStatsSetSeed 0; normalSample 0. 1.; normalSample 0. 1. in
utest miStatsSetSeed 0; bernoulliSample 0.5; normalSample 0. 1.
with  miStatsSetSeed 0; bernoulliSample 0.5; normalSample 0. 1. in

()
