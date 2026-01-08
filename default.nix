let
 pkgs = import (fetchTarball "https://github.com/rstats-on-nix/nixpkgs/archive/2026-01-05.tar.gz") {};

 rpkgs = builtins.attrValues {
  inherit (pkgs.rPackages)
    quarto
    ggplot2
    knitr
    reticulate
    rmarkdown
    withr
    ;
 };

 pyconf = builtins.attrValues {
   inherit (pkgs.python312Packages)
     plotnine
     beautifulsoup4
     polars
     requests
     xlsx2csv
     lxml
     pyarrow
     ;
 };

 rix = (pkgs.rPackages.buildRPackage {
   name = "rix";
   src = pkgs.fetchgit {
     url = "https://github.com/ropensci/rix/";
     rev = "fe17ede0753e235ba25f9da14e2c829d5cd0a927";
     sha256 = "sha256-8ApbYTBqkyuB44bx2DXHqHNhbV3oZBul5TetuZLMNXw=";
   };
   propagatedBuildInputs = builtins.attrValues {
     inherit (pkgs.rPackages) 
       codetools
       curl
       jsonlite
       sys;
   };
 });

 rixpress = (pkgs.rPackages.buildRPackage {
   name = "rixpress";
   src = pkgs.fetchgit {
     url = "https://github.com/b-rodrigues/rixpress";
     rev = "649dff7f900e10657b30b3269d03999b15e80788";
     sha256 = "sha256-C5tF54mbQsZYCCI7RGWfdO13VAQcjvnp0IXMjqtv0E8=";
   };
   propagatedBuildInputs = builtins.attrValues {
     inherit (pkgs.rPackages) 
       igraph
       jsonlite
       processx;
   };
 });
    
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
  inherit (pkgs) R glibcLocalesUtf8 quarto python312;
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

    buildInputs = [ jlconf rix rixpress pyconf rpkgs tex system_packages  ];
      
  }
