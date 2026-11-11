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

-- Binomial, with N trials and success probability theta (as in Stan)
external externalBinomialLogPmf : Int -> Int -> Float -> Float
external externalBinomialSample ! : Int -> Float -> Int
let binomialPmf = lam n:Int. lam theta:Float. lam x:Int.
  exp (externalBinomialLogPmf x n theta)
let binomialLogPmf = lam n:Int. lam theta:Float. lam x:Int.
  externalBinomialLogPmf x n theta
let binomialSample = lam n:Int. lam theta:Float.
  externalBinomialSample n theta

-- Beta, with shape parameters alpha and beta (as in Stan)
external externalBetaLogPdf : Float -> Float -> Float -> Float
external externalBetaSample ! : Float -> Float -> Float
let betaPdf = lam alpha:Float. lam beta:Float. lam x:Float.
  exp (externalBetaLogPdf x alpha beta)
let betaLogPdf = lam alpha:Float. lam beta:Float. lam x:Float.
  externalBetaLogPdf x alpha beta
let betaSample = lam alpha:Float. lam beta:Float.
  externalBetaSample alpha beta

-- Beta-binomial, with N trials and shape parameters alpha and beta (as in Stan)
external externalBetaBinomialLogPmf : Int -> Int -> Float -> Float -> Float
external externalBetaBinomialSample ! : Int -> Float -> Float -> Int
let betaBinomialPmf : Int -> Float -> Float -> Int -> Float = lam n. lam alpha. lam beta. lam x.
  exp (externalBetaBinomialLogPmf x n alpha beta)
let betaBinomialLogPmf : Int -> Float -> Float -> Int -> Float = lam n. lam alpha. lam beta. lam x.
  externalBetaBinomialLogPmf x n alpha beta
let betaBinomialSample : Int -> Float -> Float -> Int = lam n. lam alpha. lam beta.
  externalBetaBinomialSample n alpha beta

-- Chi-square, with degrees of freedom nu (as in Stan)
external externalChiSquareLogPdf : Float -> Float -> Float
external externalChiSquareCdf : Float -> Float -> Float
external externalChiSquareSample ! : Float -> Float
let chiSquarePdf : Float -> Float -> Float = lam nu. lam x.
  exp (externalChiSquareLogPdf x nu)
let chiSquareLogPdf : Float -> Float -> Float = lam nu. lam x.
  externalChiSquareLogPdf x nu
let chiSquareCdf : Float -> Float -> Float = lam nu. lam x.
  externalChiSquareCdf x nu
let chiSquareSample : Float -> Float = lam nu.
  externalChiSquareSample nu

-- Exponential, with rate beta (as in Stan, mean 1 / beta)
external externalExponentialLogPdf : Float -> Float -> Float
external externalExponentialSample ! : Float -> Float
let exponentialPdf : Float -> Float -> Float = lam beta. lam x.
  exp (externalExponentialLogPdf x beta)
let exponentialLogPdf : Float -> Float -> Float = lam beta. lam x.
  externalExponentialLogPdf x beta
let exponentialSample : Float -> Float = lam beta.
  externalExponentialSample beta

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

-- Negative binomial, with shape alpha and inverse scale beta (as in Stan, mean alpha / beta)
external externalNegBinomialLogPmf : Int -> Float -> Float -> Float
external externalNegBinomialSample ! : Float -> Float -> Int
let negBinomialPmf : Float -> Float -> Int -> Float = lam alpha. lam beta. lam x.
  exp (externalNegBinomialLogPmf x alpha beta)
let negBinomialLogPmf : Float -> Float -> Int -> Float = lam alpha. lam beta. lam x.
  externalNegBinomialLogPmf x alpha beta
let negBinomialSample : Float -> Float -> Int = lam alpha. lam beta.
  externalNegBinomialSample alpha beta

-- Normal
external externalNormalLogPdf : Float -> Float -> Float -> Float
external externalNormalSample ! : Float -> Float -> Float
let normalPdf = lam mu:Float. lam sigma:Float. lam x:Float.
  exp (externalNormalLogPdf x mu sigma)
let normalLogPdf = lam mu:Float. lam sigma:Float. lam x:Float.
  externalNormalLogPdf x mu sigma
let normalSample = lam mu:Float. lam sigma:Float.
  externalNormalSample mu sigma

-- Poisson, with rate lambda (as in Stan, mean lambda)
external externalPoissonLogPmf : Int -> Float -> Float
external externalPoissonSample ! : Float -> Int
let poissonPmf : Float -> Int -> Float = lam lambda. lam x.
  exp (externalPoissonLogPmf x lambda)
let poissonLogPmf : Float -> Int -> Float = lam lambda. lam x.
  externalPoissonLogPmf x lambda
let poissonSample : Float -> Int = lam lambda.
  externalPoissonSample lambda

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

-- Testing Binomial (the values distinguish N and theta, and theta from 1 - theta)
utest binomialPmf 10 0.3 4 with 0.200120949 using _eqf in
utest binomialPmf 10 0.7 4 with 0.036756909 using _eqf in
utest binomialPmf 5 0.5 2 with 0.3125 using _eqf in
utest exp (binomialLogPmf 20 0.5 10) with 0.176197052001953 using _eqf in
utest binomialPmf 1 0.3 1 with 0.3 using _eqf in

-- Testing Beta (the values distinguish alpha and beta)
utest betaPdf 2. 3. 0.2 with 1.536 using _eqf in
utest betaPdf 2. 3. 0.8 with 0.384 using _eqf in
utest exp (betaLogPdf 3. 5. 0.4) with 2.17728 using _eqf in
utest betaPdf 0.5 0.5 0.5 with 0.636619772368 using _eqf in
utest betaSample 2. 2. with 0. using lam a. lam b. and (geqf a 0.) (leqf a 1.) in

-- Testing Beta-binomial (the values distinguish N, alpha and beta)
utest betaBinomialPmf 5 2. 3. 1 with 0.238095238095 using _eqf in
utest betaBinomialPmf 5 3. 2. 1 with 0.119047619048 using _eqf in
utest exp (betaBinomialLogPmf 4 2. 1. 0) with 0.066666666667 using _eqf in
utest betaBinomialPmf 4 1. 2. 0 with 0.333333333333 using _eqf in
utest exp (betaBinomialLogPmf 5 1. 1. 2) with 0.166666666667 using _eqf in
utest betaBinomialSample 3 2. 3. with 0 using lam a. lam b. and (geqi a 0) (leqi a 3) in

-- Testing Chi-square (the values distinguish nu from other degrees of freedom)
utest chiSquarePdf 2. 1. with 0.303265329856 using _eqf in
utest chiSquarePdf 4. 1. with 0.151632664928 using _eqf in
utest chiSquarePdf 6. 2. with 0.091969860293 using _eqf in
utest exp (chiSquareLogPdf 4. 2.) with 0.183939720586 using _eqf in
utest chiSquareCdf 2. 1. with 0.393469340287 using _eqf in
utest chiSquareCdf 4. 2. with 0.264241117657 using _eqf in
utest chiSquareSample 2. with 0. using lam a. lam b. geqf a 0. in

-- Testing Exponential (the values distinguish beta from 1 / beta)
utest exponentialPdf 2. 1. with 0.270670566473 using _eqf in
utest exponentialPdf 0.5 1. with 0.303265329856 using _eqf in
utest exponentialPdf 1. 2. with 0.135335283237 using _eqf in
utest exponentialLogPdf 3. 0. with 1.098612288668 using _eqf in
utest exponentialPdf 4. 0.25 with 1.471517764686 using _eqf in
utest exponentialSample 1. with 0. using lam a. lam b. geqf a 0. in

-- Testing Gamma (the values distinguish shape and rate from shape and scale)
utest gammaPdf 2. 3. 1. with 0.448083615311 using _eqf in
utest gammaLogPdf 3. 2. 0.5 with -1. using _eqf in
utest gammaCdf 2. 3. 1. with 0.800851726529 using _eqf in
utest gammaCdf 1. 2. 0.5 with 0.632120558829 using _eqf in
utest gammaSample 1. 1000000. with 0. using lam a. lam b. and (geqf a 0.) (ltf a 0.01) in

-- Testing Negative binomial (the values distinguish alpha and beta, and beta from 1 / beta)
utest negBinomialPmf 2. 3. 1 with 0.281250000000 using _eqf in
utest negBinomialPmf 3. 2. 1 with 0.296296296296 using _eqf in
utest negBinomialPmf 2. (divf 1. 3.) 1 with 0.09375 using _eqf in
utest negBinomialPmf 0.5 3. 1 with 0.108253175473 using _eqf in
utest negBinomialPmf 3. 3. 2 with 0.158203125 using _eqf in
utest negBinomialLogPmf 2. 3. 0 with -0.575364144904 using _eqf in
utest negBinomialSample 2. 3. with 0 using lam a. lam b. geqi a 0 in

-- Testing Normal (the values distinguish mu and sigma, and sigma from the variance)
utest normalPdf 0. 0.4472 0. with 0.8920891779996 using _eqf in
utest exp (normalLogPdf 2. 1. 2.) with 0.3989422804 using _eqf in
utest exp (normalLogPdf 1. 2. 3.) with 0.12098536226 using _eqf in
utest normalPdf 2. 3. 1. with 0.125794409231 using _eqf in
utest normalSample 0. 0.2 with 0. using lam a. lam b. or (leqf a b) (geqf a b) in

-- Testing Poisson (the values distinguish lambda from 1 / lambda)
utest poissonPmf 3. 2 with 0.224041807655 using _eqf in
utest poissonPmf 0.5 3 with 0.012636055411 using _eqf in
utest poissonPmf 0.5 5 with 0.000157950693 using _eqf in
utest poissonPmf 2. 0 with 0.135335283237 using _eqf in
utest poissonPmf 0.5 2 with 0.075816332464 using _eqf in
utest poissonPmf 2.5 4 with 0.133601885781 using _eqf in
utest poissonPmf 0.4 4 with 0.000715008049 using _eqf in
utest poissonLogPmf 4. 10 with -5.241468961877 using _eqf in
utest poissonSample 2. with 0 using lam a. lam b. geqi a 0 in

-- Testing seed
utest miStatsSetSeed 0; normalSample 0. 1.; normalSample 0. 1.
with  miStatsSetSeed 0; normalSample 0. 1.; normalSample 0. 1. in
utest miStatsSetSeed 0; bernoulliSample 0.5; normalSample 0. 1.
with  miStatsSetSeed 0; bernoulliSample 0.5; normalSample 0. 1. in

()
