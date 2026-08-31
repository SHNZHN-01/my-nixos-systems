# llama.cpp router server — serves local GGUF models to the pi coding agent.
# Router mode (no -m): discovers models under modelsDir and loads/unloads them
# on demand, so per-role model tiering can swap models without a restart.
# Enable on the `computer` host, which already ships the NVIDIA driver.
{ ... }:
{
  flake.nixosModules.llamacpp =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      username = config.username;
      modelsDir = "/models";

      llama = pkgs.llama-cpp.override { cudaSupport = true; };

      serverArgs = [
        "--models-dir ${modelsDir}"
        "--no-models-autoload" # start empty; pi loads models on demand via /llama
        "--jinja"
        "--host 127.0.0.1" # local-only
        "--port 8080"
        "-ngl 999" # offload all layers to the GPU
        "-c 32768" # per-model context; lower to spare the 12 GB of VRAM
      ];
    in
    {
      # Drop GGUFs into /models by hand (flat single-file, or a subdir per
      # multi-shard / multimodal model). Owned by the login user, like /vms.
      systemd.tmpfiles.rules = [
        "d ${modelsDir} 0755 ${username} ${username} - -"
      ];

      systemd.services.llama-router = {
        description = "llama.cpp router server (local models for pi)";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          User = username;
          ExecStart = "${lib.getExe' llama "llama-server"} ${lib.concatStringsSep " " serverArgs}";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };
    };
}
