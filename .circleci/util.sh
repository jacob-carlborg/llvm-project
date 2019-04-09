function arch {
  uname -m
}

function os {
  local os=$(uname | tr '[:upper:]' '[:lower:]')
  [ $os = 'darwin' ] && echo 'macos' || echo $os
}

function release_name {
  echo "llvm-$(llvm_version)-$(os)-$(arch)"
}

function archive_name {
  echo "$(release_name)".tar.xz
}

function llvm_version {
  git describe --always | cut -d '-' -f 2
}
