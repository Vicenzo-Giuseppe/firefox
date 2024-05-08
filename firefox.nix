{pkgs, ...}: let
  catppuccin = {
    "{8446b178-c865-4f5c-8ccc-1d7887811ae3}" = "https://github.com/catppuccin/firefox/releases/download/old/catppuccin_mocha_lavender.xpi";
  };
  ublock-origin = "uBlock0@raymondhill.net";
in {
  extraPolicies = {
    FirefoxHome = {
      Search = true;
      TopSites = false;
      SponsoredTopSites = false;
      Highlights = false;
      Pocket = false;
      SponsoredPocket = false;
      Snippets = false;
      Locked = true;
    };
    PasswordManagerEnabled = false;
    StartDownloadsInTempDirectory = true;
    UserMessaging = {
      ExtensionRecommendations = false;
      SkipOnboarding = true;
      WhatsNew = false;
      FeatureRecommendations = false;
      UrlbarInterventions = false;
      MoreFromMozilla = false;
      locked = true;
    };
    Permissions = let
      NOPE = {
        Allow = [];
        Block = [];
        BlockNewRequests = true;
        Locked = true;
      };
    in {
      Camera = NOPE;
      Microphone = NOPE;
      Location = NOPE;
      Notifications = NOPE;
      Autoplay = {
        Allow = [];
        Block = [];
        Default = "block-audio-video";
        Locked = true;
      };
    };
    SearchEngines = let
      Remove = [
        "Amazon.com"
        "Bing"
        "DuckDuckGo"
        "Wikipedia (en)"
      ];
      nix-source = {
        Name = "Sourcegraph/Nix";
        Description = "Sourcegraph nix search";
        Alias = "nix";
        Method = "GET";
        IconURL = "https://sourcegraph.com/.assets/img/sourcegraph-mark.svg?v2";
        URLTemplate = "https://sourcegraph.com/search?q=context:global+file:.nix%24+{searchTerms}&patternType=literal";
      };
      github = {
        Name = "GitHub";
        Description = "Search GitHub";
        URLTemplate = "https://github.com/search?q={searchTerms}";
        Method = "GET";
        IconURL = "https://github.com/favicon.ico";
        Alias = "github";
      };
    in {
      inherit Remove;
      Add = [
        github
        nix-source
      ];
      Default = "Google";
      PreventInstalls = true;
    };
    SanitizeOnShutdown = {
      Cache = true;
      History = true;
      Cookies = true;
      Downloads = true;
      FormData = true;
      Sessions = true;
      OfflineApps = true;
    };
    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
    };
    HardwareAcceleration = true;
    ExtensionSettings = let
      Extensions = {
        inherit
          ublock-origin
          ;
      };
      otherExtensionsOptions = catppuccin;
    in
      builtins.mapAttrs
      (_: url: {
        install_url = url;
        installation_mode = "force_installed";
      })
      (pkgs.lib.mapAttrs'
        (
          name: id:
            pkgs.lib.nameValuePair id "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi"
        )
        Extensions
        // otherExtensionsOptions
        // {
          "*" = {
            installation_mode = "blocked";
            blocked_install_message = "manage extensions throught nix";
          };
        });
  };
}
