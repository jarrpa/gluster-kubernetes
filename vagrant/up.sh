#!/bin/sh

export ANSIBLE_TIMEOUT=60
vagrant up --no-provision "${@}" \
    && vagrant provision || exit 1

if [[ "x$(vagrant plugin list | grep sahara)" != "x" ]]; then
  vagrant sandbox on
fi

# shellcheck disable=SC2094
vagrant ssh-config > ssh-config
