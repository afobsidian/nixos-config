# Adam’s NixOS desktop

This flake rebuilds the installed NixOS machine named `nixos`, including Adam’s Omarchy desktop. Its hardware configuration identifies this machine’s root and EFI partitions.

## Apply the configuration

```sh
git clone https://github.com/afobsidian/nixos-config ~/nixos-config
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#nixos
```

For later changes, edit the checkout and repeat the last command from that directory. Stage new files with Git before rebuilding so the flake can see them. Home Manager runs during the same rebuild.

## Where to edit

- **configuration.nix** defines the machine, packages, services, and login account.
- **home.nix** configures Home Manager and turns off optional Nixarchy shell plugins and the Nixi assistant.
- **dotfiles/hypr/** contains the monitor layout and cursor setting. Edit these Lua files to change the corresponding Hyprland settings.
- **dotfiles/omarchy/shell.json** defines the bar, dock, and idle settings. Omarchy can edit its running copy. To keep a menu edit, copy the desired change into the repository before rebuilding.
- **flake.lock** records the exact software inputs. Ordinary rebuilds reuse these versions.

The first switch preserves conflicting desktop files beside the originals with the suffix `.before-nixos-config`. To return to the previous system generation, run `sudo nixos-rebuild switch --rollback` or select the previous generation at boot. The shell layout is writable user data. Its saved copy is available to restore separately.
