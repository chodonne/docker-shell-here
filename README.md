# Docker Shell Here

## About

Starts a posix shell in a Docker container in the mounted current host directory

* The application takes the Docker "image:tag" as a parameter
  * tag is set to "latest" if not specified
* The image will be pulled if it does not exist in the local repository
* The default shell used is "/bin/sh"
  * shell can be overridden on a per image basis by editing case statement in script

## Usage

* run latest fedora image
  * ```docker-shell-here fedora```
* run debian buster
  * ```docker-shell-here debian:buster```
