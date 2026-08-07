{
  description = "Reproducible Data Science with Nix and T";

  inputs = {
    nixpkgs.url = "github:rstats-on-nix/nixpkgs/2026-08-02";
    tlang = {
      url = "github:b-rodrigues/tlang";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  # Configure Cachix caches if needed
  nixConfig = {
    extra-substituters = [
      "https://rstats-on-nix.cachix.org"
    ];
    extra-trusted-public-keys = [
      "rstats-on-nix.cachix.org-1:vdiiVgocg6WeJrODIqdprZRUrhi1JzhBnXv7aWI6+F0="
    ];
  };

  outputs = { self, nixpkgs, tlang, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        tlang-pkg = tlang.packages.${system}.default;

        rpkgs = builtins.attrValues {
          inherit (pkgs.rPackages)
            dplyr
            ggplot2
            knitr
            purrr
            quarto
            reticulate
            rmarkdown
            withr
            ;
        };

        pyconf = builtins.attrValues {
          inherit (pkgs.python313Packages)
            beautifulsoup4
            lxml
            numpy
            pandas
            plotnine
            polars
            pyarrow
            requests
            scipy
            xlsx2csv
            ;
        };

        jlconf = pkgs.julia_110.withPackages [
          "Arrow"
          "DataFrames"
          "LinearAlgebra"
          "SparseArrays"
        ];

        tex = pkgs.texliveSmall.withPackages (ps: with ps; [
          amsmath
          framed
          fvextra
          environ
          fontawesome5
          orcidlink
          lualatex-math
          pdfcol
          tcolorbox
          tikzfill
        ]);

        system_packages = builtins.attrValues {
          inherit (pkgs) R glibcLocalesUtf8 quarto python313;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          LOCALE_ARCHIVE = if system == "x86_64-linux" then "${pkgs.glibcLocalesUtf8}/lib/locale/locale-archive" else "";
          LANG = "en_US.UTF-8";
          LC_ALL = "en_US.UTF-8";
          LC_TIME = "en_US.UTF-8";
          LC_MONETARY = "en_US.UTF-8";
          LC_PAPER = "en_US.UTF-8";
          LC_MEASUREMENT = "en_US.UTF-8";

          RETICULATE_PYTHON = "${pkgs.python313}/bin/python3";

          buildInputs = pkgs.lib.flatten [
            tlang-pkg
            jlconf
            pyconf
            rpkgs
            tex
            system_packages
          ];
        };
      }
    );
}
