with import <nixpkgs> {}; {
  urchin = stdenv.mkDerivation {
    name = "urchin";
    buildInputs = [
      busybox
      bash dash mksh zsh
    ];
  };  
}
