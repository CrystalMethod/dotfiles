# dotfiles

Personal dotfiles, managed with [chezmoi](https://github.com/twpayne/chezmoi).

## Setup

### Darwin / Ubuntu

```console
sh -c "$(curl -fsSL https://raw.githubusercontent.com/CrystalMethod/dotfiles/v2/install.sh)"
```

### Windows

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod https://raw.githubusercontent.com/CrystalMethod/dotfiles/v2/install.ps1 | Invoke-Expression
```
