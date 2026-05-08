#!/usr/bin/env bash
set -euo pipefail

SITE_URL="${SITE_URL:-https://biof3.com}"
BASE_URL="${BASE_URL:-/}"
SSH_TARGET="${SSH_TARGET:-aliyun}"
REMOTE_ROOT="${REMOTE_ROOT:-/opt/biof3-tutorial}"
RELEASE="biof3-$(date +%Y%m%d-%H%M%S)"

SITE_URL="$SITE_URL" BASE_URL="$BASE_URL" npm run build

ssh "$SSH_TARGET" "mkdir -p '$REMOTE_ROOT/releases/$RELEASE' '$REMOTE_ROOT/current-site'"
rsync -az --delete build/ "$SSH_TARGET:$REMOTE_ROOT/releases/$RELEASE/"
ssh "$SSH_TARGET" \
  "rsync -a --delete '$REMOTE_ROOT/releases/$RELEASE/' '$REMOTE_ROOT/current-site/' && \
   ln -sfn '$REMOTE_ROOT/releases/$RELEASE' '$REMOTE_ROOT/current' && \
   echo 'Deployed $RELEASE to $REMOTE_ROOT/current-site'"
