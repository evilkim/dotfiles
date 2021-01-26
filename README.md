# dotfiles
DotFiles - source etc/dotgit.sh

This is a HOME directory configured with [DotFiles](https://github.com/evilkim/dotfiles.git)

## Bootstrap HOME directory on a new server

Assumes HOME directory is not NFS mounted and/or was not prevously configured.

Assumes existing OneDrive directory on Windows 10 is suitable for keeping source files safe for work in progress.
Assumes OneDrive is equivalent to one or the other of OneDriveConsumer or OneDriveCommercial.
Assumes HOME is equivalent to USERPROFILE.

Launch Git Bash a/k/a Git for Windows (G4W)
```
cd
mkdir ${OneDrive}/src
git clone --separate-git-dir ${OneDrive}/src/.dotfiles.git https://github.com/evilkim/dotfiles.git
```
