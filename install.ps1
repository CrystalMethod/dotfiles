$ErrorActionPreference = "Stop"

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

if ($env:SKIP_SCOOP -ne "true")
{
  if (-not (Get-Command scoop -ErrorAction SilentlyContinue))
  {
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
  }
  scoop bucket add main
  scoop install main/git
  scoop install main/chezmoi
}

chezmoi init --apply --verbose CrystalMethod
