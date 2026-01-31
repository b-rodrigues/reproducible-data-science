let
 pkgs = import (fetchTarball "https://github.com/rstats-on-nix/nixpkgs/archive/2026-01-30.tar.gz") {};

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

 tex = (pkgs.texlive.combine {
   inherit (pkgs.texlive) scheme-small amsmath framed fvextra environ fontawesome5 orcidlink pdfcol tcolorbox tikzfill;
  });

 system_packages = builtins.attrValues {
  inherit (pkgs) R glibcLocalesUtf8 quarto python313;
};
  in
  pkgs.mkShell {
    LOCALE_ARCHIVE = if pkgs.system == "x86_64-linux" then  "${pkgs.glibcLocalesUtf8}/lib/locale/locale-archive" else "";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    
    # Tell reticulate to use the Python from this Nix environment
    RETICULATE_PYTHON = "${pkgs.python313}/bin/python3";

    buildInputs = [ jlconf pyconf rpkgs tex system_packages  ];
      
  }
