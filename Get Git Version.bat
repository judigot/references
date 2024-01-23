@echo off
setlocal EnableDelayedExpansion

:: ====================GET THE LATEST GIT VERSION====================
:: Use curl to fetch the JSON data from GitHub API for Git tags

:: Parse the JSON data and extract the latest Git version
for /f "tokens=3 delims=:, " %%v in ('curl -s https://api.github.com/repos/git/git/tags') do (
    set "git_version=%%v"
    goto VersionFound
)

:VersionFound
:: Remove leading and trailing double quotes
set "git_version=!git_version:"=!"

for /f "tokens=*" %%a in ("!git_version!") do (
  set "gitLatestVersion=%%~nxa"
  set gitLatestVersion=!gitLatestVersion:~1!
)

echo !gitLatestVersion!
pause
:: Now you can use the variable !git_version! in your script
:: ====================GET THE LATEST GIT VERSION====================