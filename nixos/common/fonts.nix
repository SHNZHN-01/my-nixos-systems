_: {
  flake.nixosModules.fonts =
    { pkgs, lib, ... }:
    {
      fonts.packages =
        with pkgs;
        [
          nerd-fonts.jetbrains-mono
          nerd-fonts.terminess-ttf
          fixedsys-excelsior
          noto-fonts-cjk-sans # makes Chinese render everywhere via fallback (essential)
          noto-fonts-cjk-serif # optional, for serif/prose
          sarasa-gothic # monospace CJK for terminal + editor
        ]
        ++ [
          (pkgs.stdenvNoCC.mkDerivation {
            pname = "berkeley-mono";
            version = "2";

            src = pkgs.requireFile {
              name = "berkeley-mono.zip";
              sha256 = "1i7zfm7f1zzrxhryfc7dxsfjzmc8nj8jrsmvrn16lcmrzhcndyv6";
              url = "https://usgraphics.com/products/berkeley-mono";
              message = ''
                Berkeley Mono is a paid font and cannot be downloaded automatically.
                Download the zip from your Berkeley Graphics account, then run:
                  nix-prefetch-url --type sha256 file://$PWD/berkeley-mono.zip
                and paste the printed hash into the sha256 field in
                nixos/common/fonts.nix
              '';
            };

            nativeBuildInputs = [ pkgs.unzip ];

            unpackPhase = ''
              runHook preUnpack
              unzip $src
              runHook postUnpack
            '';

            installPhase = ''
              runHook preInstall
              find . -name '*.ttf' -exec install -D -m444 -t $out/share/fonts/truetype {} +
              runHook postInstall
            '';

            meta = {
              description = "Berkeley Mono Typeface";
              homepage = "https://usgraphics.com/products/berkeley-mono";
              license = lib.licenses.unfree;
              platforms = lib.platforms.all;
            };
          })
        ];
    };
}
