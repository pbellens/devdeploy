ARG base
FROM ${base}

ARG DEVENV="/devenv"
ARG USER
ARG UID
ARG GID

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
    && cp clangd_17.0.3/bin/clangd /usr/bin \
    && rm -fr clangd*

RUN wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz \
    && tar xzvf nvim-linux64.tar.gz \
    && ln -s ${DEVENV}/nvim-linux64/bin/nvim /usr/bin/nvim

RUN groupadd -g ${GID} ${USER} && \
    adduser --uid ${UID} --gid ${GID} ${USER} && \
    usermod -G wheel -a ${USER} && \
    sed 's/# %wheel/%wheel/g' /etc/sudoers > /etc/sudoers.bak && \
    mv /etc/sudoers.bak /etc/sudoers

RUN git clone https://github.com/NvChad/NvChad.git \
    && cd NvChad \
    && mkdir -p /home/${USER}/.config/nvim \
    && mv init.lua lua /home/${USER}/.config/nvim \
    && rm -fr /home/${USER}/.config/nvim/custom

RUN git clone https://github.com/pbellens/dotfiles.git \
    && cd dotfiles \
    && cp -r nvim/.config/nvim/lua/custom /home/${USER}/.config/nvim/lua

RUN chown ${UID}:${GID} ${DEVENV}

CMD ["/bin/bash"]
