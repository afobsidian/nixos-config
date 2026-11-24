{
  description = "Adam's NixOS desktop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixarchy = {
      url = "github:olafkfreund/nixarchy/release";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixarchy, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixarchy.nixosModules.nixarchy
        ./configuration.nix
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "before-nixos-config";
            users.adamf.imports = [
              nixarchy.homeManagerModules.nixarchy
              ./home.nix
            ];
          };
        }
      ];
    };
  };
}
