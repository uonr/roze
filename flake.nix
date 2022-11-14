{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server.url = "github:msteen/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    sweet-home.url = "github:uonr/sweet-home";
  };
  outputs = { self, nixpkgs, nixos-generators, sweet-home, vscode-server
    , home-manager, ... }: {
      packages.x86_64-linux = {
        linode = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          modules = [
            vscode-server.nixosModule
            home-manager.nixosModules.home-manager
            {
              home-manager.sharedModules = [
                sweet-home.nixosModules.home
                vscode-server.nixosModules.home
              ];
            }
            ./configuration
          ];
          format = "linode";
        };
        default = self.packages.x86_64-linux.linode;
      };
    };
}
