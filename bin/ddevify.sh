#!/bin/bash

if [ ! -f ${1} ]; then
    echo "Can't read ${1}" 1>&2 
    exit 1
fi


cat $1 | awk '/apk add/{$0=$0" neovim gcompat clang16-extra-tools git gdb"} 1' | sed '/^CMD/q' | head -n -1 > "dev.${1}"
    
# Set up dev stuff
cat <<EOF >> "dev.${1}"
WORKDIR /git
RUN git clone https://github.com/NvChad/NvChad.git && cd NvChad && mkdir -p /root/.config/nvim && mv init.lua lua /root/.config/nvim && rm -fr /root/.config/nvim/custom
RUN git clone https://github.com/pbellens/dotfiles.git && cd dotfiles && cp -r nvim/.config/nvim/lua/custom /root/.config/nvim/lua
CMD ["tail -f /dev/null"]
EOF
