{ ... }: {
  flake.nixosModules.firefox =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      extensions = [
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}"
        "uBlock0@raymondhill.net"
        "{73a6fe31-595d-460b-a920-fcc0f8843232}"
        "simple-tab-groups@drive4ik"
        "openmultipleurls@ustat.de"
        "addon@darkreader.org"
      ];
    in
    {
      programs.firefox = {
        enable = true;
        languagePacks = [ "en-US" ];
        preferencesStatus = "locked";
        preferences = {
          "layout.spellcheckDefault" = 1;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          # allow adblockers to act everywhere. WARNING this is a security hole.
          # "extensions.webextensions.restrictedDomains" = "";
          "media.webrtc.camera.allow-pipewire" = true;
          "browser.download.always_ask_before_handling_new_types" = true;
          "browser.startup.page" = 3;

          "browser.discovery.enabled" = false;
          "browser.contentblocking.category" = "strict";
          "app.shield.optoutstudies.enabled" = false;
          "browser.topsites.contile.enabled" = false;
          "browser.urlbar.suggest.quicksuggest.sponsored" = false;
          "browser.urlbar.trending.featureGate" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.snippets" = false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.system.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          # Disable automatic opening in new windows (manually still works)
          "browser.link.open_newwindow" = 3;
          # Set all window open modes to abide above method
          "browser.link.open_newwindow.restriction" = 0;

          "privacy.resistFingerprinting" = "true";
          # disable sending downloaded files to the internet
          "browser.safebrowsing.downloads.remote.enabled" = false;
          "network.dns.disablePrefetch" = false;
          # redundancy: disable network prefetching
          "network.predictor.enabled" = false;
          # disable preloading websites when hovering over links
          "network.http.speculative-parallel-limit" = 0;
          # disable connecting to bookmarks when hovering over them
          "browser.places.speculativeConnect.enabled" = "false";
          "privacy.globalprivacycontrol.enabled" = true;
          "privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
          "privacy.fingerprintingProtection" = true;

          "extensions.pocket.enabled" = false;
          "browser.search.suggest.enabled" = false;
          "browser.search.suggest.enabled.private" = false;
          "browser.urlbar.suggest.searches" = false;
          # store media in cache only on private browsing
          "browser.privatebrowsing.forceMediaMemoryCache" = true;
          "network.http.referer.XOriginTrimmingPolicy" = 2;
          # Privacy: Disable CSP reporting
          # https://bugzilla.mozilla.org/show_bug.cgi?id=1964249
          "security.csp.reporting.enabled" = false;

          #### SECURITY ###
          #"browser.formfill.enable" = false;
          "pdfjs.enableScripting" = false;
          #"signon.autofillForms" = false
          # UNCLEAR
          "signon.formlessCapture.enabled" = false;
          # prevent scripts from moving or resizing windows
          "dom.disable_window_move_resize" = true;
          # Security: Disable remote debugging feature
          "devtools.debugger.remote-enabled" = false;
          # Security: Restrict directories from which extensions can be loaded (Unclear)
          "extensions.enabledScopes" = 5;

          #### SSL ###
          # Security: Require safe SSL negotiation to avoid potentially MITMed sites
          "security.ssl.require_safe_negotiation" = true;
          # Security: Disable TLS1.3 0-RTT as key encryption may not be forward secret
          # https://github.com/tlswg/tls13-spec/issues/1001
          "security.tls.enable_0rtt_data" = 2;
          # Security: Enable strict public key pinning, prevents some MITM attacks
          "security.cert_pinning.enforcement_level" = 2;
          # Security: Enable CRLite to ensure that revoked certificates are detected
          "security.pki.crlite_mode" = 2;
          # Security: Treat unsafe negotiation as broken
          # https://wiki.mozilla.org/Security:Renegotiation
          # https://bugzilla.mozilla.org/1353705
          "security.ssl.treat_unsafe_negotiation_as_broken" = true;
          #  Security: Display more information on Insecure Connection warning pages
          # Test: https://badssl.com
          "browser.xul.error_pages.expert_bad_cert" = true;

          "extensions.screenshots.disabled" = "lock-true";
          "browser.formfill.enable" = "lock-false";
          "browser.urlbar.showSearchSuggestionsFirst" = "lock-false";
        };

        policies = {
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          DisablePocket = true;
          DisableFirefoxAccounts = true;
          DisableAccounts = true;
          DisableFirefoxScreenshots = true;
          OverrideFirstRunPage = "";
          OverridePostUpdatePage = "";
          DontCheckDefaultBrowser = true;
          DisplayBookmarksToolbar = "never";
          DisplayMenuBar = "default-off";
          SearchBar = "unified";

          ExtensionSettings = builtins.listToAttrs (
            builtins.map (id: {
              name = id;
              value = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
                #installation_mode = "force_installed";
                sidebar_action = "pin";
              };
            }) extensions
          );

          "3rdparty".Extensions."uBlock0@raymondhill.net".adminSettings = builtins.toJSON {
            selectedFilterLists = [
              # uBlock defaults
              "user-filters"
              "ublock-filters"
              "ublock-badware"
              "ublock-privacy"
              "ublock-unbreak"
              "ublock-quick-fixes"
              "easylist"
              "easyprivacy" # EasyPrivacy
              "urlhaus-1" # Online Malicious URL Blocklist
              "plowe-0" # Peter Lowe's Ad/tracking server list
              # regional
              "DEU-0" # EasyList Germany (was wrongly "easylistgermany")
              "spa-0" # EasyList Spanish
              "spa-1" # AdGuard Spanish/Portuguese
              "CHN-0" # AdGuard Chinese
            ];
          };

          UserMessaging = {
            ExtensionRecommendations = false;
            UrlbarInterventions = false;
            SkipOnboarding = true;
            MoreFromMozilla = false;
            FirefoxLabs = true;
          };
          FirefoxSuggest = {
            WebSuggestions = false;
            SponsoredSuggestions = false;
            ImproveSuggest = false;
            Locked = true;
          };

          AutofillAddressEnabled = false;
          AutofillCreditCardEnabled = false;
          HttpsOnlyMode = "force_enabled";
          SSLVersionMin = "tls1.2";
          PostQuantumKeyAgreementEnabled = true;
          HttpAllowlist = [
            "http://localhost"
            "http://127.0.0.1"
          ];
          NetworkPrediction = false;
          SanitizeOnShutdown = {
            Cache = true;
            FormData = true;
            SiteSettings = false;
            OfflineApps = true;
          };

          SearchSuggestEnabled = false;
        };
      };
    };
}
