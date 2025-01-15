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
    libcapstone-dev \
    python2.7-dev \
    python-pip \
    unzip \
    locales \
    && apt-get clean

# Set locale to UTF-8
RUN locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 && \
    export LANG=en_US.UTF-8

# Install Pwntools for Python 2.7
RUN pip install --upgrade pip && \
    pip install pwntools

# Install GEF
RUN wget https://github.com/hugsy/gef/archive/refs/tags/2021.10.zip && \
    unzip 2021.10.zip && \
    echo "source ~/gef-2021.10/gef.py" >> ~/.gdbinit && \
    rm -f 2021.10.zip

# Install Oh My Zsh
RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" || true

# Install Powerlevel10k theme
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k && \
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Set up Zsh as the default shell
RUN chsh -s $(which zsh)

# Prevent Zsh initial configuration message
RUN touch ~/.zshrc

# Set up dynamic home directory for the user
ARG USER_HOME
RUN mkdir -p "$USER_HOME" && \
    echo "cd $USER_HOME" >> ~/.zshrc

# Set up home directory volume
VOLUME ["${USER_HOME}"]

# Change working directory to user-defined home directory
WORKDIR ${USER_HOME}

# Start Zsh
CMD ["/bin/zsh"]

