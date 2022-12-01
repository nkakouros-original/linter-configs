#!/usr/bin/env bash

set -euo pipefail

if [[ "$UID" -ne 0 ]]; then
  echo 'this script should be run by root'
  exit 1
fi

function _download_latest_from_github() {
  project="$1"
  app="$2"
  file_pattern="$3"
  extract="$4"

  if [[ -e "/usr/bin/$app" ]]; then
    echo "/usr/bin/$app already exists, skipping installing $app from github"
    return
  fi

  echo "Installing $project from github..."
  local base latest version os arch url dir

  base="https://github.com/$project/releases"
  latest="$(curl -fs "$base/latest" -w 'MARKER%{redirect_url}')"
  latest="${latest##*MARKER}"
  version="${latest##*/v}"
  os="$(uname -s)"
  arch="$(uname -m)"
  url="$base/download/v$version/$file_pattern"
  eval url="$url"

  dir="/tmp/$app"
  mkdir -p "$dir"

  if [[ "$extract" == 'true' ]]; then
    curl --silent --fail --show-error --location "$url" \
      | tar --strip-components 1 -x --xz -C "$dir"
  else
    curl -sfSL "$url" >|"$dir/$app"
  fi

  mv "$dir/$app" "/usr/bin/$app"
  chmod +x "/usr/bin/$app"

  echo "...done"
}

# System packages
echo 'Installing system packages'
readarray -t packages <<<"$(grep -vE "^\s*#|^\s*$" vendor/packages.apt)"
apt update
apt install -y "${packages[@]}"

# go dependencies
echo 'Installing go dependencies'
cat vendor/deps.go | xargs go install

# python dependencies
echo 'Installing python dependencies'
pip install virtualenv
virtualenv vendor/python
pip install pipenv
export PIPENV_PIPFILE='vendor/Pipfile'
export VIRTUAL_ENV='python/'  # relative to Pipfile
pipenv install

# npm packages
apt remove -y libnode*
curl -sL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs
npm install --prefix vendor

# github deps
echo 'Installing github projects'
while IFS=, read -r project app pattern extract; do
  [[ "$project" =~ (^\s*\#)|^\s*$ ]] && continue
  _download_latest_from_github "$project" "$app" "$pattern" "$extract"
done < vendor/repos.gh
