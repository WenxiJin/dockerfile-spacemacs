FROM ubuntu:18.04 as base

maintainer Wenxi Jin <jwenxi@gmail.com>

# User setup
ENV uid 1000
ENV gid 1000
ENV UNAME wjn

# Install packages
RUN apt update && \
    apt -y install \
    build-essential \
    sudo \
    wget \
    emacs \
    silversearcher-ag \
    git

# Add wjn as a new user
RUN mkdir -p /home/${UNAME}/workspace                                                   && \
    echo "${UNAME}:x:${uid}:${gid}:${UNAME},,,:/home/${UNAME}:/bin/bash" >> /etc/passwd && \
    echo "${UNAME}:x:${uid}:" >> /etc/group                                             && \
    echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${UNAME}                   && \
    echo "docker:x:999:${UNAME}" >> /etc/group                                          && \
    chmod 0440 /etc/sudoers.d/${UNAME}                                                  && \
    chown ${uid}:${gid} -R /home/${UNAME}

USER ${UNAME}

# Spacemacs
RUN git clone https://github.com/WenxiJin/.spacemacs.d.git /home/${UNAME}/.spacemacs.d          && \
    git clone https://github.com/syl20bnr/spacemacs.git -b develop /home/${UNAME}/.emacs.d      && \
    sudo find $HOME/                                                                               \
      \( -type d -exec chmod u+rwx,g+rwx,o+rx {} \;                                                \
      -o -type f -exec chmod u+rw,g+rw,o+r {} \; \)                                             && \
    sudo chown -R ${uid}:${gid} $HOME                                                           && \
    emacs -nw -batch -u "${UNAME}" -q -kill
