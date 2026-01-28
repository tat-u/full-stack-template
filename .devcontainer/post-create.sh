#!/bin/bash

# Install Claude Code
curl -fsSL https://claude.ai/install.sh | bash

# Install Volta
curl https://get.volta.sh | bash

# NOTE: ここで `source ~/.bashrc` を実行しても反映されないため、手動で反映してください
echo "Post-create setup completed."
echo "Restart your terminal or run 'source ~/.bashrc' to apply the changes."
