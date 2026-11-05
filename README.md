# mi-stats

Statistics functions for [Miking](https://miking.org), implemented by
wrapping parts of the [Stan Math](https://github.com/stan-dev/math)
library.

The repository contains:

- `src/mi-stats/`: the `mi_stats` OCaml library, with the needed parts
  of Stan Math (and its dependencies Eigen and Boost) vendored under
  `vendor/`. Their licenses are in `licenses/`.
- `src/lib/stats.mc`: `external` declarations exposing the library to
  MCore, along with wrapper functions (`normalSample`,
  `bernoulliLogPmf`, `miStatsSetSeed`, etc.).
- `src/lib/stats.ext-ocaml.mc`: `miStatsExtMap`, the OCaml
  implementations of those externals.
- `src/lib/linalg.mc`: vectors and matrices (`MiStatsVector`,
  `MiStatsMatrix`), conversions to and from sequences, and the
  matrix-vector product.
- `src/lib/linalg.ext-ocaml.mc`: `miStatsLinalgExtMap`, the OCaml
  implementations of the externals in `linalg.mc`.

## Using mi-stats from a compiler

The externals in `stats.mc` and `linalg.mc` are not known by the
standard Miking compiler (`mi`). A compiler that wants to support them
adds `miStatsExtMap` and/or `miStatsLinalgExtMap` to the external
implementations it passes to `compileMCore`. The two maps are
independent, so a compiler adds only the ones it needs:

```
include "ocaml/mcore.mc"
include "ocaml/external-includes.mc"
include "mi-stats::stats.ext-ocaml.mc"
include "mi-stats::linalg.ext-ocaml.mc"

let externalImpls =
  mapUnion (mapUnion globalExternalImplsMap miStatsExtMap) miStatsLinalgExtMap in
let hooks = { mkEmptyHooks compileOcaml with externalImpls = externalImpls } in
compileMCore ast hooks
```

Programs compiled this way can then include `mi-stats::stats.mc` and
`mi-stats::linalg.mc`, respectively.
This requires `mi-stats` to be present in `MCORE_LIBS`, and the
`mi_stats` OCaml library to be findable by `ocamlfind` when the
generated OCaml code is compiled.

## Building and installing

```
make            # Build the OCaml library into build/lib/mi_stats
make install    # Install the OCaml library and the mcore files
make uninstall  # Remove them again
make test       # Run the tests (requires `mi`)
make vendor     # Re-vendor Stan Math (requires `fish`, `git` and `rsync`)
```

`make install` respects the same variables as Miking's `Makefile`
(`prefix`, `libdir`, `ocamllibdir`, and `OPAM_SWITCH_PREFIX`). The
mcore files are installed to `$(libdir)/mcore/mi-stats`, which must be
added to `MCORE_LIBS`, e.g.:

```
export MCORE_LIBS=$MCORE_LIBS:mi-stats=$HOME/.local/lib/mcore/mi-stats
```

`make test` uses `misc/test-driver.mc`, a small compiler that knows
about both maps, to compile and run the utests in `src/lib`.

## Nix

`misc/packaging/flake.nix` provides the `mi-stats` package, an overlay,
and a development shell (which also contains `mi`). See
`misc/direnv/` for a corresponding `.envrc`.
