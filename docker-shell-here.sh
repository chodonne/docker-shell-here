#!/bin/bash

MYIMAGETAG="$1"

sayhelp() {
  echo ""
  echo "Start a shell in a Docker container in the current directory."
  echo ""
  echo "Usage: $(basename "$0") image:[tag]"
  echo ""
  echo "Set default image:tag with DSH_DEFAULT env var"
  echo "e.g. DSH_DEFAULT=\"ubuntu:20.04\""
  echo ""
}

getimage() {
  echo "$1" | cut -d":" -f 1
}

gettag() {
  echo "$1" | grep ":" | cut -d":" -f 2
}

check_and_pull_image() {
  if [ "$(docker images \
    | grep -v REPOSITORY \
    | grep "$1" \
    | grep "$2")" \
    = "" ];
  then
    docker pull "${1}:${2}"
  fi
}

run_image() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --workdir "/shared" \
    --entrypoint "$MYSHELL" \
    --volume "$(pwd)":/shared:z \
    "${1}:${2}"
}

set_shell() {
  case "$1" in
    debian)
      MYSHELL="/bin/bash"
      ;;
    ubuntu)
      MYSHELL="/bin/bash"
      ;;
    *)
      MYSHELL="/bin/sh"
      ;;
  esac
}

###

if [ -z "$MYIMAGETAG" ]; then
  if [ -n "$DSH_DEFAULT" ]; then
    MYIMAGE="$(getimage "$DSH_DEFAULT")"
    MYTAG="$(gettag "$DSH_DEFAULT")"
    set_shell "$MYIMAGE"
    check_and_pull_image "$MYIMAGE" "$MYTAG"
    run_image "$MYIMAGE" "$MYTAG"
  else
    sayhelp
  fi
else
  MYIMAGE="$(getimage "$MYIMAGETAG")"
  MYTAG="$(gettag "$MYIMAGETAG")"
  if [ -z "$MYTAG" ]; then
    MYTAG="latest"
  fi
  set_shell "$MYIMAGE"
  check_and_pull_image "$MYIMAGE" "$MYTAG"
  run_image "$MYIMAGE" "$MYTAG"
fi
