FROM ubuntu:16.04

# Update and install essential packages
RUN apt-get update && apt-get install -y \
    software-properties-common \
    build-essential \
    libssl-dev \
    libffi-dev \
    zlib1g-dev \
    wget \
    curl \
    vim \
    git \
    zsh \
    gdb \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    liblzma-dev \
    && apt-get clean

# Install Python 3.8 from source
RUN wget https://www.python.org/ftp/python/3.8.10/Python-3.8.10.tgz && \
    tar -xf Python-3.8.10.tgz && \
    cd Python-3.8.10 && \
    ./configure --enable-optimizations && \
    make -j$(nproc) && \
    make altinstall && \
    cd .. && \
    rm -rf Python-3.8.10.tgz Python-3.8.10

# Install pip for Python 3.8
RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3.8 get-pip.py && \
    rm get-pip.py

# Upgrade setuptools
RUN python3.8 -m pip install --no-cache-dir --upgrade setuptools

# Install rbenv and Ruby 3.1
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc && \
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build && \
    ~/.rbenv/bin/rbenv install 3.1.2 && \
    ~/.rbenv/bin/rbenv global 3.1.2 && \
    ~/.rbenv/bin/rbenv rehash

# Install Oh My Zsh
RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" || true

# Install Powerlevel10k theme
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k && \
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Install GEF (GDB Enhanced Features)
RUN wget -q -O ~/.gdbinit-gef.py https://gef.blah.cat/py && echo "source ~/.gdbinit-gef.py" >> ~/.gdbinit

# Install one_gadget
RUN ~/.rbenv/shims/gem install one_gadget

# Install ROPgadget
RUN python3.8 -m pip install --no-cache-dir ROPgadget

# Set up Zsh as the default shell
RUN chsh -s $(which zsh)

# Prevent zsh initial configuration message
RUN touch ~/.zshrc

# Set up dynamic home directory for the user
ARG USER_HOME
RUN mkdir -p "$USER_HOME" && \
    echo "cd $USER_HOME" >> ~/.zshrc

# Set up home directory volume
VOLUME ["${USER_HOME}"]

# Change working directory to user-defined home directory
WORKDIR ${USER_HOME}

# Start zsh
CMD ["/bin/zsh"]
