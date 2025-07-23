echo -e "\033[1;33m===>\033[0m Install packages"

sudo apt-get install -y \
    bash \
    build-essential \
    curl \
    direnv \
    gcc \
    git \
    golang-go \
    gnupg2 \
    htop \
    jq \
    mc \
    podman \
    rsync \
    nano \
    ssh \
    wget \
    python3-pip \
    python3-venv \
    python3-dev \
    python3-setuptools \
    python3-wheel \
    python-is-python3 \
    virtualbox-guest-utils \
    virtualbox-guest-x11 \
    wget \
    zip \
    unzip \
    zsh \
    yamllint \
    nodejs \
    node \
    vim \

# Install glab
curl -sSL "https://raw.githubusercontent.com/upciti/wakemeops/main/assets/install_repository" | sudo bash
sudo apt install glab

sudo apt-get clean
sudo apt-get autoremove -y

