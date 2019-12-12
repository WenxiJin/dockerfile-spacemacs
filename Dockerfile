FROM spacemacs/emacs-snapshot:develop as base

maintainer Wenxi Jin <jwenxi@gmail.com>

# Install packages
RUN apt update && \
    apt -y install \
    build-essential \
    sudo \
    openssh-server \
    wget \
    silversearcher-ag \
    git \
    subversion

RUN rm /home/emacs/.spacemacs
RUN git clone https://github.com/WenxiJin/.spacemacs.d.git /home/emacs/.spacemacs.d