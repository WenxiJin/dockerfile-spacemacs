# ubuntu:14.04 + emacs-25.1
from wenxijin/dockerfile-emacs:latest

maintainer Wenxi Jin <jwenxi@gmail.com>

# User setup
ENV uid 1000
ENV gid 1000
ENV UNAME wjn

RUN mkdir -p /home/${UNAME}/workspace                                                   && \
    echo "${UNAME}:x:${uid}:${gid}:${UNAME},,,:/home/${UNAME}:/bin/bash" >> /etc/passwd && \
    echo "${UNAME}:x:${uid}:" >> /etc/group                                             && \
    echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${UNAME}                   && \
    echo "docker:x:999:${UNAME}" >> /etc/group                                          && \
    chmod 0440 /etc/sudoers.d/${UNAME}                                                  && \
    chown ${uid}:${gid} -R /home/${UNAME}

USER ${UNAME}

# Fonts
ADD https://github.com/adobe-fonts/source-code-pro/archive/2.010R-ro/1.030R-it.zip /tmp/scp.zip
ADD http://www.ffonts.net/NanumGothic.font.zip /tmp/ng.zip

RUN sudo apt-get install -y zip                        && \
    sudo mkdir -p /usr/local/share/fonts               && \
    sudo unzip /tmp/scp.zip -d /usr/local/share/fonts  && \
    sudo unzip /tmp/ng.zip -d /usr/local/share/fonts   && \
    sudo chown ${uid}:${gid} -R /usr/local/share/fonts && \
    sudo chmod 777 -R /usr/local/share/fonts           && \
    sudo fc-cache -fv

# Git
RUN sudo apt-get install -y git

# Spacemacs
RUN git clone https://github.com/WenxiJin/.spacemacs.d.git /home/${UNAME}/.spacemacs.d          && \
    git clone https://github.com/syl20bnr/spacemacs.git -b develop /home/${UNAME}/.emacs.d      && \
    sudo find $HOME/                                                                               \
      \( -type d -exec chmod u+rwx,g+rwx,o+rx {} \;                                                \
      -o -type f -exec chmod u+rw,g+rw,o+r {} \; \)                                             && \

    sudo chown -R ${uid}:${gid} $HOME                                                           && \
    emacs -nw -batch -u "${UNAME}" -q -kill


# ENTRYPOINT ["bash", "/usr/local/bin/start.bash"]