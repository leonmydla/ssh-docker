#!/bin/bash

set -e

if [[ -e '/mode_server' ]]; then
  ssh-keygen -A
  cd /run/sshd

  if [[ -z "$@" ]] || [[ "$1" = 'sshd' ]]; then
    gosu root /usr/sbin/sshd -D -e ${@:2}
  fi

  if [[ "$1" = '/usr/sbin/sshd' ]]; then
    gosu root $@
  fi
fi

if [[ -e '/mode_client' ]]; then
  cd ~client

  if [[ -z "$@" ]] || [[ "$1" = 'ssh' ]]; then
    gosu client /usr/bin/ssh ${@:2}
  fi

  if [[ "$1" = '/usr/bin/ssh' ]]; then
    gosu client $@
  fi
fi

exec $@
