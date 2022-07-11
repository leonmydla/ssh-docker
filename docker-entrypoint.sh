#!/bin/bash

set -e

if [[ -e '/mode_server' ]]; then
  ssh-keygen -A
  cd /run/sshd

  if [[ -z "$@" ]] || [[ "$1" = 'sshd' ]]; then
    cp /authorized_keys /home/client/.ssh/authorized_keys
    chown client:nogroup /home/client/.ssh/authorized_keys
    chmod 600 /home/client/.ssh/authorized_keys
    gosu root /usr/sbin/sshd -D -e ${@:2}
  fi

  if [[ "$1" = '/usr/sbin/sshd' ]]; then
    cp /authorized_keys /home/client/.ssh/authorized_keys
    chown client:nogroup /home/client/.ssh/authorized_keys
    chmod 600 /home/client/.ssh/authorized_keys
    gosu root $@
  fi
fi

if [[ -e '/mode_client' ]]; then
  cd ~client

  if [[ -z "$@" ]] || [[ "$1" = 'ssh' ]] || [[ "$1" = '/usr/bin/ssh' ]]; then
    cp /id /home/client/.ssh/id
    chown client:nogroup /home/client/.ssh/id
    chmod 600 /home/client/.ssh/id
    gosu client /usr/bin/ssh ${@:2}
  fi
fi

exec $@
