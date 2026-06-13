{ ... }: {
  flake.wrappers.fzf = { config, lib, wlib, pkgs, ... }: {
    imports = [ wlib.modules.default ];

    # We use `lib.types.nullOr lib.types.str`, which means that this options can either be null or a string.
    # The in the config.env declarations we instruct Nix to only make the config.env.FZF_X attribute
    # if the value of the options is not set to `null`.
    options = {
      fzf_default_command = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Default command to use when input is tty.";
      };
      fzf_default_opts = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Default options.";
      };
      fzf_default_opts_file = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Default options file path.";
      };
    };

    config.package = pkgs.fzf;
    config.env.FZF_DEFAULT_COMMAND   = lib.mkIf (config.fzf_default_command != null)   config.fzf_default_command;
    config.env.FZF_DEFAULT_OPTS      = lib.mkIf (config.fzf_default_opts != null)      config.fzf_default_opts;
    config.env.FZF_DEFAULT_OPTS_FILE = lib.mkIf (config.fzf_default_opts_file != null) config.fzf_default_opts_file;
  };
}
