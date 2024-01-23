#!/bin/bash

# Enable debug mode
set -x

# Install starship
echo -e "\n" | curl -sS https://starship.rs/install.sh | sh -s -- -y

# Install the_silver_searcher
sudo dnf -y groupinstall "Development Tools" && \
sudo dnf -y install pcre-devel xz-devel zlib-devel && \
cd /usr/local/src && \
[ -d the_silver_searcher ] || sudo git clone https://github.com/ggreer/the_silver_searcher.git && \
cd the_silver_searcher/ && \
sudo ./build.sh && \
sudo make install

# Install lazygit
cd /tmp && \
[ -d lazygit ] || git clone https://github.com/jesseduffield/lazygit.git && \
cd lazygit && \
go install

# Update .bashrc
echo '
### Custom script for codecatalyst ###
# git completion
source /usr/share/doc/git/contrib/completion/git-completion.bash
# Install starship: curl -sS https://starship.rs/install.sh | sh
eval "$(starship init bash)"
# Install lazygit : go install github.com/jesseduffield/lazygit@latest
go_path="~/go/bin"
if [[ ":$PATH:" != *":$go_path:"* ]]; then
    export PATH=$PATH:$go_path # Check if the path is not already in the PATH
fi
' >> ~/.bashrc

# Source the updated .bashrc
source ~/.bashrc

# Display completion message
echo "Environment setup completed!"
cd ~

# Disable debug mode
set +x
