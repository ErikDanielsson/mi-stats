{ lib, stdenv, nix-gitignore,
  ocamlPackages,
}:

with ocamlPackages;

stdenv.mkDerivation (finalAttrs: {
  pname = "mi-stats";
  version = "0.0.0+git";

  src = nix-gitignore.gitignoreSource "/misc/packaging\n/result\n" ../..;

  nativeBuildInputs = [
    dune_3
    ocaml
    findlib
  ];

  makeFlags = [ "prefix=$(out)" "ocamllibdir=$(out)/lib/ocaml/${ocaml.version}/site-lib" ];

  buildFlags = [ "build" ];

  installTargets = "install-ocaml install-mcore";

  preConfigure = ''
    for f in $(find misc -type f -a -executable); do patchShebangs --build $f; done
  '';

  # NOTE: There is deliberately no setup hook adding the installed mcore
  # files to MCORE_LIBS here; that hook is provided by `miking-lib`,
  # which is needed to use the mcore files in the first place.

  meta = with lib; {
    description     = "Statistics functions for Miking, implemented using Stan Math";
    homepage        = "https://miking.org";
    license         = with licenses; [ mit bsd3 boost mpl20 ];
    longDescription = ''
      An OCaml library (`mi_stats`) of statistics functions, wrapping
      parts of the Stan Math library, together with mcore files
      exposing them as externals (`mi-stats::stats.mc`) and a map of
      their OCaml implementations (`mi-stats::stats.ext-ocaml.mc`)
      that a compiler can pass to `compileMCore`.
    '';
  };
})
