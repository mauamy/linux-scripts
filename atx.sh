#!/bin/sh
# quick AWS Profile Switcher
set -o allexport

if [ ! -x "$(which aws 2>/dev/null)" ]; then
  echo "please install: aws-cli (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)" >&2
  exit 1
fi
if [ ! -x "$(which fzf 2>/dev/null)" ]; then
  echo "please install: fzf (https://github.com/junegunn/fzf)" >&2
  exit 1
fi

current="$AWS_PROFILE"
if [ -z "$current" ]; then
  current="default"
fi

selected=$( (grep -oPa "(?<=\[profile ).*(?=\])"  ~/.aws/config) | fzf -0 -1 --tac -q "${1:-""}" --prompt "$current> ")
if [ ! -z "$selected" ]; then
  export AWS_PROFILE=$selected
  echo "Set AWS Profile to \"$selected\""
fi

export AWS_PROFILE=$selected
echo $selected > /tmp/current_aws_profile.tmp

set +o allexport
