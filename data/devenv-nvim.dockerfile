ARG base
FROM ${base}

ARG DEVENV="/devenv"
ARG user
ARG UID
ARG GID

ENV HOME="/home/${user}"

RUN --mount=type=cache,target=/var/cache/yum,rw \
    dnf install -y \
      unzip \
    && dnf clean all

RUN mkdir -vp "${DEVENV}"
WORKDIR "${DEVENV}"

RUN wget https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-x86_64-unknown-linux-musl.tar.gz \
    && tar xzvf ripgrep-14.1.0-x86_64-unknown-linux-musl.tar.gz \
    && cp ripgrep-14.1.0-x86_64-unknown-linux-musl/rg /usr/bin \
    && rm -fr ripgrep-14.1.0-x86_64-unknown-linux-musl*

RUN wget https://github.com/clangd/clangd/releases/download/17.0.3/clangd-linux-17.0.3.zip \
    && unzip clangd-linux-17.0.3.zip \
    && cp clangd_17.0.3/bin/* /usr/bin \
    && cp -r clangd_17.0.3/lib/clang /usr/lib \
    && rm -fr clangd*

RUN wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz \
    && tar xzvf nvim-linux64.tar.gz \
    && ln -s ${DEVENV}/nvim-linux64/bin/nvim /usr/bin/nvim

RUN groupadd -g ${GID} ${user} && \
    adduser --uid ${UID} --gid ${GID} ${user} && \
    usermod -G wheel -a ${user} && \
    sed 's/# %wheel/%wheel/g' /etc/sudoers > /etc/sudoers.bak && \
    mv /etc/sudoers.bak /etc/sudoers

RUN git clone https://github.com/NvChad/NvChad.git \
    && cd NvChad \
    && mkdir -p /home/${user}/.config/nvim \
    && mv init.lua lua /home/${user}/.config/nvim \
    && rm -fr /home/${user}/.config/nvim/custom
RUN git clone https://github.com/pbellens/dotfiles.git \
    && cd dotfiles \
    && cp -r nvim/.config/nvim/lua/custom /home/${user}/.config/nvim/lua
#RUN curl -sS https://starship.rs/install.sh | sh

RUN chown ${UID}:${GID} ${DEVENV}

USER ${user}

RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
    && ~/.fzf/install --all --no-zsh --no-fish

RUN ( echo "alias ll='ls --color -l'" \
    && echo . /opt/rh/gcc-toolset-13/enable \
    && echo "alias ls=ll" \
    && echo "alias vi=nvim" \
    && echo "alias vim=nvim" ) >> "${HOME}/.bashrc"

CMD ["/bin/bash"]
