FROM andreaceccanti/vim-dev-base

RUN apt-get update && apt-get install -y fontconfig && pip install ipython

RUN useradd dev && \
  echo "ALL   ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  cp /usr/share/zoneinfo/Europe/Rome /etc/localtime && \
  dpkg-reconfigure locales && \
  locale-gen en_US.UTF-8 && \
  /usr/sbin/update-locale LANG=en_US.UTF8

WORKDIR /home/dev

ENV HOME /home/dev
ENV LC_ALL en_US.UTF-8

RUN chown -R dev:dev $HOME && mkdir git

## Install VIM configuration
RUN git clone https://github.com/andreaceccanti/vimrc.git git/vimrc && \
  cd git/vimrc && /bin/bash install.sh

## Powerline fonts
RUN git clone https://github.com/powerline/fonts.git git/fonts && \
  cd git/fonts && /bin/bash install.sh

RUN fc-cache -vf $HOME/.fonts

## Install spf13-vim
RUN curl http://j.mp/spf13-vim3 -L -o - | sh

## Compile YouCompleteMe
RUN cd .vim/bundle/YouCompleteMe && git submodule update --init --recursive \
 && ./install.sh --clang-completer

RUN chown -R dev:dev $HOME

USER dev

CMD ["tmux", "-u2"]
