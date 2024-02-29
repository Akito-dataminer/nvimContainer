FROM ubuntu:22.04

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get upgrade -y \
  && apt-get install -y \
  ca-certificates \
  gcc \
  g++ \
  git \
  libtool \
  automake \
  autoconf \
  unzip \
  make \
  cmake \
  tar \
  curl \
  locales \
  iproute2 \
  inetutils-ping \
  rclone \
  ripgrep \
  nodejs \
  npm \
  && locale-gen ja_JP.UTF-8 \
  && echo "export LANG=ja_JP.UTF-8" >> ~/.bashrc \
  && npm install n -g \
  && n stable \
  && apt-get purge -y nodejs npm \
  && apt-get autoremove -y && apt-get clean -y && apt-get autoclean -y \
  # Install rclone
  && curl https://rclone.org/install.sh | bash \
  # Install Neovim
  && curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz \
  && tar -zxvf nvim-linux64.tar.gz \
  && mv nvim-linux64/bin/nvim /usr/bin/nvim \
  && mv nvim-linux64/lib/nvim /usr/lib/nvim \
  && mv nvim-linux64/share/nvim/ /usr/share/nvim \
  && rm -rf nvim-linux64 \
  && rm nvim-linux64.tar.gz

ARG USERNAME=$USERNAME
ARG GROUPNAME=vimmer
ARG UID=1000
ARG GID=1000
RUN groupadd --gid $GID $GROUPNAME \
  && useradd -m -G $GROUPNAME -g $GID -u $UID -s /bin/bash $USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME/

# Install deno (for Neovim)
RUN curl -fsSL https://deno.land/x/install/install.sh | sh
ENV DENO_INSTALL="/home/${USERNAME}/.deno"
ENV PATH="$DENO_INSTALL/bin:$PATH"

ARG NVIM_CONF_URL=${NVIM_CONF_URL}
ARG GIT_USER=${GIT_USER}
ARG GIT_EMAIL=${GIT_EMAIL}
RUN git config --global user.name "$GIT_USER" \
  && git config --global user.email "$GIT_EMAIL"
RUN mkdir .config && cd .config && git clone $NVIM_CONF_URL

ENTRYPOINT ["nvim", "--headless", "--listen"]
CMD ["0.0.0.0:6497"]
