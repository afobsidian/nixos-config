{ config, lib, ... }:

{
  home.stateVersion = "26.05";
  services.nixi.enable = false;

  programs.nixarchy = {
    enable = true;
    # Use the built-in Omarchy widgets. Disable each plugin the port offers.
    defaultPlugins = lib.mapAttrs (_: _: false) config.programs.nixarchy.defaultPluginSet;
  };

  xdg.configFile = {
    "hypr/monitors.lua".source = ./dotfiles/hypr/monitors.lua;
    "hypr/looknfeel.lua".source = ./dotfiles/hypr/looknfeel.lua;
  };

  # Omarchy saves the entire layout when you edit the bar. Give it a writable copy.
  home.activation.omarchyShellLayout = lib.hm.dag.entryAfter [ "nixarchySeed" ] ''
    layout="${config.xdg.configHome}/omarchy/shell.json"
    if ! cmp -s ${./dotfiles/omarchy/shell.json} "$layout"; then
      if [[ -f "$layout" && ! -e "$layout.before-nixos-config" ]]; then
        run cp -p "$layout" "$layout.before-nixos-config"
      fi
      if [[ ! -v DRY_RUN ]]; then
        temp=$(mktemp "$layout.XXXXXX")
        install -m 0644 ${./dotfiles/omarchy/shell.json} "$temp"
        mv -T "$temp" "$layout"
      fi
    fi
  '';
}
