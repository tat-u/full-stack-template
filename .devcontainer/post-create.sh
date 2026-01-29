#!/bin/bash
NODE_VERSION="24"

# Install Claude Code
curl -fsSL https://claude.ai/install.sh | bash

# Install Volta and setup Node.js
curl https://get.volta.sh | bash
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
volta install node@$NODE_VERSION
volta install npm

# NOTE: ここで `source ~/.bashrc` を実行しても継承されたターミナルには反映されないため、
#       PATH の変更を手動で反映してください
echo "Post-create setup completed."
echo "Restart your terminal or run 'source ~/.bashrc' to apply the changes."
