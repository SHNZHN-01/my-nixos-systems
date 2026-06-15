{ ... }:
let
  mkKeybinds = pkgs: entries:
    let data = pkgs.writeText "keybinds.txt" entries;
    in pkgs.writeShellApplication {
      name = "keybinds";
      #runtimeInputs = [ pkgs.rofi pkgs.util-linux ];  # util-linux -> `column`
      text = ''
        column -t -s'|' ${data} \
          | rofi -dmenu -i -p keybinds
      '';
    };

  defaultEntries = ''
    Mod+w               | i3 - Tabbed layout
    Mod+Alt+c           | i3 - Reload
    Mod+Alt+r           | i3 - Restart
    Mod+Ctrl+r          | i3 - Resize mode
    Mod+Shift+r         | rofi - Run command mode
    Mod+v               | misc - Open volume mixer
    Ctrl+Shift+Space    | term - Enter vim mode 
  '';
in
{
  # Real flake output: `nix run .#keybinds`, buildable per system.
  perSystem = { pkgs, ... }: {
    packages.keybinds = mkKeybinds pkgs defaultEntries;
  };

  # Consumable NixOS module.
  flake.nixosModules.keybinds = { config, pkgs, lib, ... }:
    let cfg = config.programs.keybinds;
    in {
      options.programs.keybinds = {
        enable = lib.mkEnableOption "rofi keybind glossary";

        entries = lib.mkOption {
          type = lib.types.lines;
          default = defaultEntries;
          description = "Glossary lines, '|'-delimited into columns.";
        };

        package = lib.mkOption {
          type = lib.types.package;
          readOnly = true;
          default = mkKeybinds pkgs cfg.entries;
          description = "The built keybinds command.";
        };

      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = [ cfg.package ];  # drop if you only want the keybind
      };
    };
}

