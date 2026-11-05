-- A minimal test driver for the mcore files in this repository.
--
-- The externals declared in `src/lib/stats.mc` and `src/lib/linalg.mc`
-- are not known by the standard Miking compiler, thus `mi compile
-- --test` cannot run their tests. This driver compiles and runs each
-- file given on the command line with its utests enabled, using the
-- external implementations of the standard library extended with
-- `miStatsExtMap` and `miStatsLinalgExtMap`.
--
-- It follows (a subset of) the loader-based pipeline used by `mi`
-- (`compileViaLoader` in `src/main/compile.mc` in the miking
-- repository).
--
-- Usage: test-driver FILE...
--
-- Requires `mi-stats` to be present in `MCORE_LIBS` and the `mi_stats`
-- OCaml library to be findable by `ocamlfind` (see the `test` target
-- in the `Makefile`).

include "common.mc"
include "map.mc"
include "seq.mc"
include "string.mc"
include "stdlib.mc"
include "mexpr/ast-builder.mc"
include "mexpr/builtin.mc"
include "mexpr/deadcode.mc"
include "mexpr/generate-eq.mc"
include "mexpr/generate-pprint.mc"
include "mexpr/generate-utest.mc"
include "mexpr/shallow-patterns.mc"
include "mexpr/type-check.mc"
include "mlang/loader.mc"
include "ocaml/compile.mc"
include "ocaml/external-includes.mc"
include "ocaml/mcore.mc"

include "mi-stats::stats.ext-ocaml.mc"
include "mi-stats::linalg.ext-ocaml.mc"

lang MiStatsTestDriver =
  ComposedMCoreLoader + UtestLoader +
  MExprLowerNestedPatterns + MExprDeadcodeElimination +
  MExprGenerateEq + GenerateEqMetaVarError +
  MExprGeneratePprint + GeneratePprintMissingCase +
  MCoreCompileLang
end

-- Compiles the given file with its utests enabled, runs it, and
-- returns whether it succeeded.
let testFile : String -> Bool = lam file.
  use MiStatsTestDriver in
  let file = stdlibMkExplicitPreferLocal file in

  let loader = mkLoader typcheckEnvDefault [] in
  let loader =
    let filename = stdlibResolveFileOr (lam x. error x) "." file in
    let keepUtestIf = lam x.
      if x.static
      then match x.info with Info x
        then eqString x.filename filename
        else true
      else true in
    let loader = enableUtestGeneration keepUtestIf loader in
    registerCustomEqFunction (mapFindExn "Symbol" builtinTypeNames) (uconst_ (CEqsym ())) loader in

  let loader = (includeFileTypeExn (FMCore {includeMExpr = true}) "." file loader).1 in
  let ast = buildFullAst loader in
  let ast = removeMetaVarExpr ast in
  let ast = lowerAll ast in
  let ast = deadcodeElimination ast in
  let ast = forceLazyExpr ast in
  let ast = removeOpaqueExpr ast in

  let compileAndRun = lam libs. lam clibs. lam ocamlProg.
    let options = {defaultCompileOptions with libraries = libs, cLibraries = clibs} in
    let cunit : CompileResult = ocamlCompileWithConfig options ocamlProg in
    let res = cunit.run "" [] in
    cunit.cleanup ();
    res in
  let externalImpls = foldl mapUnion globalExternalImplsMap
    [ miStatsExtMap
    , miStatsLinalgExtMap
    ]
  in
  let hooks = { mkEmptyHooks compileAndRun
    with externalImpls = externalImpls } in
  let res : ExecResult = compileMCore ast hooks in
  print res.stdout;
  printError res.stderr;
  flushStdout ();
  flushStderr ();
  eqi res.returncode 0

mexpr

let files = tail argv in
(if null files then
  printError "Usage: test-driver FILE...\n";
  exit 1
 else ());
let failed = filter (lam file.
  printLn (concat "Testing " file);
  not (testFile file)) files in
if null failed then () else
  printError (join ["Tests failed in: ", strJoin ", " failed, "\n"]);
  exit 1
