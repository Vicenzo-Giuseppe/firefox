{
  description = "firefox with privacy options";
  inputs = {
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = {
    self,
    utils,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in
    utils.lib.mkFlake
    {
      inherit self inputs;
      supportedSystems = [system];
      outputsBuilder = x: let
        pkgs = x.nixpkgs;
      in {
        apps = rec {
          firefox = utils.lib.mkApp {
            drv = self.packages.${system}.firefox;
          };
          default = firefox;
        };
        packages = rec {
          firefox = with pkgs; wrapFirefox firefox-esr-115-unwrapped (import ./firefox.nix {inherit pkgs;});
          default = firefox;
        };
        formatter = pkgs.alejandra;
      };
    };
}
