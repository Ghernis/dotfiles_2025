#===============================
# Builder 1: Build tmux + libevent
# ===============================
FROM registry.access.redhat.com/ubi9/ubi AS builder-tmux

RUN dnf -y install \
        gcc \
        make \
        autoconf \
        openssl \
        openssl-devel \
        automake \
        pkgconfig \
        ncurses-devel \
        libevent-devel \
        git \
        tar \
        wget && \
    dnf clean all

# Build libevent
RUN curl -LO https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz && \
    tar -xzf libevent-2.1.12-stable.tar.gz && \
    cd libevent-2.1.12-stable && \
    ./configure && make && make install

# Build tmux
RUN curl -LO https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz && \
    tar -xzf tmux-3.3a.tar.gz && \
    cd tmux-3.3a && \
    ./configure && make && make install

# ===============================
# Builder 2: Build Neovim
# ===============================
FROM registry.access.redhat.com/ubi9/ubi AS builder-nvim

RUN dnf -y install \
        git \
        gcc \
        cmake \
        make \
        ninja-build \
        gettext \
        unzip \
        tar \
        libtool \
        autoconf \
        automake \
        g++ \
        pkgconfig \
        which && \
    dnf clean all

RUN git clone https://github.com/neovim/neovim.git /tmp/neovim && \
    cd /tmp/neovim && \
    git checkout stable && \
    make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/usr/local && \
    make install
RUN ls /usr/local/lib

# ===============================
# Final Stage: Runtime Only
# ===============================
FROM registry.access.redhat.com/ubi9/ubi-minimal

# Install minimal runtime deps
RUN microdnf install -y \
        git \
        bash \
        jq \
        make \
        gcc \
        kernel-headers \
        glibc-devel \
        sqlite \
        tar \
        unzip \
        ncurses \
        libevent \
        shadow-utils \
        hostname && \
    microdnf clean all

# Install oc CLI
RUN curl -LO https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz && \
	tar -xzf openshift-client-linux.tar.gz -C /usr/local/bin oc kubectl && \
	rm openshift-client-linux.tar.gz

# Add tmux from builder
COPY --from=builder-tmux /usr/local/bin/tmux /usr/local/bin/tmux
COPY --from=builder-tmux /usr/local/lib/libevent* /usr/local/lib/

# Add neovim from builder
COPY --from=builder-nvim /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=builder-nvim /usr/local/share/nvim /usr/local/share/nvim
#COPY --from=builder-nvim /usr/local/lib/nvim /usr/local/lib/nvim
#COPY --from=builder-nvim /usr/local/lib/libluajit* /usr/local/lib/

# === NEOVIM PLUGINS ===

#RUN mkdir -p /home/user/.local/share/nvim/lazy && \
#    git clone https://github.com/folke/lazy.nvim.git /home/user/.local/share/nvim/lazy/lazy.nvim

# === START OPTIONAL COMPONENTS ===

# --- GO ---
ARG INSTALL_GO=false
RUN if [ "$INSTALL_GO" = "true" ]; then \
    curl -LO https://golang.org/dl/go1.22.2.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz && \
    rm go1.22.2.linux-amd64.tar.gz ; \
    fi

ARG GO_PATH=/usr/local/go/bin
ENV PATH=$PATH${INSTALL_GO:+:$GO_PATH}

# --- NODE ---
ARG INSTALL_NODE=false
RUN if [ "$INSTALL_NODE" = "true" ]; then \
    curl -fsSL https://rpm.nodesource.com/setup_20.x | bash - && \
    microdnf install -y nodejs && \
    microdnf clean all ; \
    fi

# --- PYTHON ---
ARG INSTALL_PYTHON=false
RUN if [ "$INSTALL_PYTHON" = "true" ]; then \
    microdnf install -y python3 python3-pip && \
    microdnf clean all ; \
    fi

# --- DOTNET ---
ARG INSTALL_DOTNET=false
RUN if [ "$INSTALL_DOTNET" = "true" ]; then \
    curl -sSL https://packages.microsoft.com/config/rhel/9/packages-microsoft-prod.rpm -o /tmp/dotnet.rpm && \
    rpm -i /tmp/dotnet.rpm && \
    microdnf install -y dotnet-sdk-6.0 && \
    microdnf clean all && \
    rm /tmp/dotnet.rpm ; \
    fi

# --- AZURE CLI ---
ARG INSTALL_AZURE_CLI=false
RUN if [ "$INSTALL_AZURE_CLI" = "true" ]; then \
    rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    curl -sSL https://packages.microsoft.com/config/rhel/9/packages-microsoft-prod.rpm -o /tmp/azure.rpm && \
    rpm -i /tmp/azure.rpm && \
    microdnf install -y azure-cli && \
    microdnf clean all && \
    rm /tmp/azure.rpm ; \
    fi

# --- AWS CLI ---
ARG INSTALL_AWS_CLI=false
RUN if [ "$INSTALL_AWS_CLI" = "true" ]; then \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip && \
    unzip awscliv2.zip && ./aws/install && \
    rm -rf aws awscliv2.zip ; \
    fi

# --- AZURE FUNCTIONS CORE TOOLS ---
ARG INSTALL_AZFUNC_CLI=false
RUN if [ "$INSTALL_AZFUNC_CLI" = "true" ]; then \
    microdnf install -y libicu && microdnf clean all && \
    curl -sL https://github.com/Azure/azure-functions-core-tools/releases/download/4.0.7030/Azure.Functions.Cli.linux-x64.4.0.7030.zip -o /tmp/az_func_cli.zip && \
    unzip -d /opt/azure-functions-core-tools /tmp/az_func_cli.zip && \
    chmod +x /opt/azure-functions-core-tools/func && \
    chown 1001:0 /opt/azure-functions-core-tools/func && \
    ln -s /opt/azure-functions-core-tools/func /usr/local/bin/func ; \
    fi

# --- MSSQL ODBC Driver ---
ARG INSTALL_ODBC_DRIVER=false
RUN if [ "$INSTALL_ODBC_DRIVER" = "true" ]; then \
    curl -o /etc/yum.repos.d/mssql-release.repo https://packages.microsoft.com/config/rhel/9/prod.repo && \
    ACCEPT_EULA=Y microdnf install -y msodbcsql18 unixODBC-devel && \
    microdnf clean all ; \
    fi

# --- POWERSHELL ---
ARG INSTALL_POWERSHELL=false
RUN if [ "$INSTALL_POWERSHELL" = "true" ]; then \
    microdnf install -y powershell && \
    microdnf clean all ; \
    fi

# --- PANDOC ---
ARG INSTALL_PANDOC=false
RUN if [ "$INSTALL_PANDOC" = "true" ]; then \
    curl -LO https://github.com/jgm/pandoc/releases/download/3.1.11/pandoc-3.1.11-linux-amd64.tar.gz && \
    tar -xzf pandoc-3.1.11-linux-amd64.tar.gz --strip-components=1 -C /usr/local && \
    rm pandoc-3.1.11-linux-amd64.tar.gz ; \
    fi
# --- Config Files ---

RUN useradd -u 1001 user && \
    mkdir -p /projects && \
    chown -R 1001:0 /projects && \
    chmod -R 775 /projects

ENV HOME=/home/user
ENV LD_LIBRARY_PATH=/usr/local/lib
ENV PATH=/usr/local/bin:$PATH

RUN mkdir -p $HOME/.config
RUN mkdir -p $HOME/bin

RUN git clone https://github.com/Ghernis/dotfiles_2025.git /tmp/dotfiles && \
    cp -r /tmp/dotfiles/config/nvim $HOME/.config/nvim && \
    cp /tmp/dotfiles/.bashrc $HOME/.bashrc && \
    cp /tmp/dotfiles/.tmux.conf $HOME/.tmux.conf && \
    cp /tmp/dotfiles/comp $HOME/bin/comp

# Neovim runtime dirs
#RUN mkdir -p $HOME/.local/share $HOME/.local/state/nvim/shada && \
#    chown -R 1001:0 $HOME/.local

#RUN chown -R 1001:0 $HOME/

# Pre-sync plugins
RUN nvim --headless "+Lazy! sync" +qa && \
    nvim --headless "+TSUpdateSync" +qa

# Neovim runtime dirs

RUN mkdir -p $HOME/.local/state/nvim/shada
RUN mkdir -p $HOME/.cache/nvim/luac

RUN chown -R 1001:0 $HOME && chmod 0755 $HOME

USER 1001
WORKDIR /projects
