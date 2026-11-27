{ lib, nixarchy, pkgs, ... }:

{
  # Nixarchy adds these preinstalls to the system profile.
  programs.nixarchy = {
    preinstallsExclude = [ "pinta" "cliamp" "libreoffice" ];
    apps = {
      cards.enable = false;
      checkmate.enable = false;
      hype.enable = false;
      monologue.enable = false;
    };
  };

  xdg.mime.defaultApplications = {
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "ai.storyteller.wordcraft.desktop";
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "ai.storyteller.gridcraft.desktop";
  };

  home-manager.users.adamf = { config, ... }: {
    imports = [ nixarchy.homeManagerModules.nixarchy ];

    home.packages = with pkgs; [
      bubblewrap
      codex
      devenv
      gridcraft
      localsend
      nodejs
      pdfcraft
      wordcraft
    ];

    home.stateVersion = "26.05";
    # Keep the cursor visible when display settings change.
    xdg.configFile."hypr/looknfeel.lua".text = ''
      hl.config({ cursor = { no_hardware_cursors = 1 } })
    '';

    # zed settings;
    xdg.stateFile."omarchy/defaults/editor".text = "zeditor\n";
    services.nixi.enable = false;
    programs.zed-editor = {
      enable = true;
      mutableUserSettings = true;
      userSettings = {
        project_panel.dock = "left";
        ui_font_size = 16;
        buffer_font_size = 15;
        theme = "Omarchy";
      };
    };

    programs.nixarchy = {
      enable = true;
      # Use the built-in Omarchy widgets. Disable each plugin the port offers.
      defaultPlugins = lib.mapAttrs (_: _: false) config.programs.nixarchy.defaultPluginSet;
      plugins.omamail.src = pkgs.fetchzip {
        url = "https://codeload.github.com/huacnlee/omamail/tar.gz/031462561b4e36f7f19ac8242727ad281c10e82f";
        extension = "tar.gz";
        sha256 = "1r55ylw9zg9r2zj2phhics4m1ib35yiaz5jw1zmq547xlbv1nil1";
      };
    };
  };
}
