{
  description = "Simple Python Shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    allSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    forAllSystems = f:
      nixpkgs.lib.genAttrs allSystems (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
          };
        });
  in {
    devShells = forAllSystems ({pkgs}: {
      default = let
        python = pkgs.python312;
      in
        pkgs.mkShell {
          packages =
            [
              (python.withPackages (ps:
                with ps; [
                  # python packages
                  qtile
                ]))
            ]
            ++ (with pkgs; [
              # other packages
            ]);
        };
    });
  };
}
