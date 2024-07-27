# AstroNvim configuration

## 🛠️ Installation

#### Make a backup of your current nvim and shared folder

```shell
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
git clone https://github.com/silvern1990/astronvim_for_spring ~/.config/nvim
```

#### Start Neovim

```shell
nvim
```

## Bug ? 

After installing astrocommunity, when I opened some files using telescope(<Leader>ff),
I have a issue that I don't see which-key window.

This issue is temporarily resolved by deleting the ~/.local/state/nvim directory, but the same issue repeats.

Although it is cumbersome, to temporarily solve this issue in the editing session, you need to open another file or enter ex mode.


------

Additionally, through further experimentation, it has been determined that the issue is related to session files stored in the ~/.local/state/nvim/view folder. Deleting the lines related to fold commands in the session files resolves the issue. However, it has not been determined why the fold commands cause this issue.
