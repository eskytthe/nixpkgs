{ lib, fetchFromGitHub, fetchzip, stdenv }:

rec {
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "returntocorp";
    repo = "semgrep";
    rev = "v${version}";
    sha256 = "sha256-qtiOZRqN+EqJs7kDmNReW4uweEynJd0TrU7vpR/fbqI=";
  };

  # submodule dependencies
  # these are fetched so we:
  #   1. don't fetch the many submodules we don't need
  #   2. avoid fetchSubmodules since it's prone to impurities
  submodules = {
    "cli/src/semgrep/lang" = fetchFromGitHub {
      owner = "returntocorp";
      repo = "semgrep-langs";
      rev = "08656cdefc9e6818c64e168cf51ee1e76ea8829e";
      sha256 = "sha256-vYf33JhfvEDmt/VW0hBOmqailIERS0GdUgrPuCxWt9I=";
    };
    "cli/src/semgrep/semgrep_interfaces" = fetchFromGitHub {
      owner = "returntocorp";
      repo = "semgrep-interfaces";
      rev = "deffcb8e0e5166e29ce17b8af72716f45cbb2aa6";
      sha256 = "sha256-yrVn1fJcAkQd3TMIvrWa5NDb/fN3ngybOycu7DG4pbE=";
    };
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  core = rec {
    data = {
      x86_64-linux = {
        suffix = "-ubuntu-16.04.tgz";
        sha256 = "sha256-cnF92jrVeRxDAbDQxicZ4+CfdOD7BJUz2fHjIHEim24=";
      };
      x86_64-darwin = {
        suffix = "-osx.zip";
        sha256 = "sha256-eg6oHTz3vRd4GubvOYiJIjv/NZgXRWHPBmFvSu60S+E=";
      };
    };
    src = let
      inherit (stdenv.hostPlatform) system;
      selectSystemData = data: data.${system} or (throw "Unsupported system: ${system}");
      inherit (selectSystemData data) suffix sha256;
    in fetchzip {
      url = "https://github.com/returntocorp/semgrep/releases/download/v${version}/semgrep-v${version}${suffix}";
      inherit sha256;
    };
  };

  meta = with lib; {
    homepage = "https://semgrep.dev/";
    downloadPage = "https://github.com/returntocorp/semgrep/";
    changelog = "https://github.com/returntocorp/semgrep/blob/v${version}/CHANGELOG.md";
    description = "Lightweight static analysis for many languages";
    longDescription = ''
      Semgrep is a fast, open-source, static analysis tool for finding bugs and
      enforcing code standards at editor, commit, and CI time. Semgrep analyzes
      code locally on your computer or in your build environment: code is never
      uploaded. Its rules look like the code you already write; no abstract
      syntax trees, regex wrestling, or painful DSLs.
    '';
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jk ambroisie ];
    # limited by semgrep-core
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
