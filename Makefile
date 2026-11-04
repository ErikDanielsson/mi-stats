MI ?= mi
TEST_DRIVER_NAME=test-driver

prefix ?= $(HOME)/.local
bindir ?= $(prefix)/bin
libdir ?= $(prefix)/lib
mcoredir = $(libdir)/mcore
ifdef OPAM_SWITCH_PREFIX
opamlibdir = $(OPAM_SWITCH_PREFIX)/lib
endif
ocamllibdir ?= $(or $(opamlibdir), $(libdir)/ocaml/site-lib)

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(dir $(mkfile_path))

# Used when building and running the tests, to make the local mcore
# files and the locally built OCaml library visible. Both are placed
# first, so they take precedence over any other (e.g., installed)
# versions.
SET_MCORE_LIBS=MCORE_LIBS="mi-stats=$(current_dir)src/lib$${MCORE_LIBS:+:$${MCORE_LIBS}}"
SET_OCAMLPATH=OCAMLPATH="$(current_dir)build/lib$${OCAMLPATH:+:$${OCAMLPATH}}"

.PHONY: default
default: build


# Everything in `build` is generated
.PHONY: clean
clean:
	rm -rf build


# The `mi_stats` OCaml library

.PHONY: build
build:
	misc/scripts/with-tmp-dir dune build --root=src/mi-stats/ --build-dir="{}" \
	"&&" dune install --root=src/mi-stats/ --build-dir="{}" --prefix=$(current_dir)/build ">/dev/null" "2>&1"
	rm -f $(current_dir)"/build/lib/mi_stats/dune-package"

.PHONY: vendor
vendor:
	cd src/mi-stats; ./vendor.fish


# Installing and uninstalling the OCaml library and the mcore files

.PHONY: install
install: install-ocaml install-mcore
	@echo ""
	@echo "The mcore files for mi-stats have been installed to $(mcoredir)/mi-stats."
	@echo "Please ensure that MCORE_LIBS contains them, e.g., under Bash:"
	@echo 'export MCORE_LIBS=$${MCORE_LIBS:+$$MCORE_LIBS:}mi-stats=$(mcoredir)/mi-stats'

.PHONY: uninstall
uninstall: uninstall-ocaml uninstall-mcore

.PHONY: install-ocaml
install-ocaml:
	misc/scripts/with-tmp-dir dune build --root=src/mi-stats/ --build-dir="{}" \
	"&&" dune install --root=src/mi-stats/ --build-dir="{}" --prefix=$(prefix) --libdir=$(ocamllibdir) ">/dev/null 2>&1"

.PHONY: uninstall-ocaml
uninstall-ocaml:
	misc/scripts/with-tmp-dir dune build --root=src/mi-stats/ --build-dir="{}" @install ">/dev/null 2>&1" \
	"&&" dune uninstall --root=src/mi-stats --build-dir="{}" --prefix=$(prefix) --libdir=$(ocamllibdir) ">/dev/null 2>&1"

.PHONY: install-mcore
install-mcore:
	mkdir -p $(mcoredir)
	rm -rf $(mcoredir)/mi-stats || true
	cp -rf src/lib $(mcoredir)/mi-stats

.PHONY: uninstall-mcore
uninstall-mcore:
	rm -rf $(mcoredir)/mi-stats


# Testing (requires `mi`)

build/$(TEST_DRIVER_NAME): misc/test-driver.mc $(wildcard src/lib/*.mc)
	mkdir -p build
	$(SET_MCORE_LIBS) $(MI) compile misc/test-driver.mc --output build/$(TEST_DRIVER_NAME)

.PHONY: test
test: build build/$(TEST_DRIVER_NAME)
	$(SET_MCORE_LIBS) $(SET_OCAMLPATH) build/$(TEST_DRIVER_NAME) $(wildcard src/lib/*.mc)
