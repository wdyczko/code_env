FROM centos
# ENV PROXY_IP=87.254.212.120
# ENV PROXY_PORT=8080
# ENV http_proxy=http://${PROXY_IP}:${PROXY_PORT}
# ENV https_proxy=https://${PROXY_IP}:${PROXY_PORT}
# ENV HTTP_PROXY=http://${PROXY_IP}:${PROXY_PORT}
# ENV HTTPS_PROXY=https://${PROXY_IP}:${PROXY_PORT}

ENV TOOLS /tools
ENV PATH $PATH:$TOOLS:$TOOLS/bin
ENV CODE /code
ENV BASE /base

RUN mkdir -p $TOOLS && \
    mkdir -p $BASE

ADD scripts/loop.sh /tools/

RUN yum install -y git && \
    yum install -y ctags && \
    yum install -y cscope && \
    yum install -y sqlite-devel && \
    yum install -y gcc-c++ && \
    yum install -y make && \
    yum install -y wget && \
    yum install -y ncurses-devel && \
    yum install -y zlib-devel && \
    yum groupinstall -y "Development Tools"

RUN cd /tmp && wget https://www.python.org/ftp/python/3.6.4/Python-3.6.4.tar.xz && tar -xJf Python-3.6.4.tar.xz && cd Python-3.6.4 && ./configure && make && make install

RUN cd /tmp/ && \
    wget https://github.com/Kitware/CMake/releases/download/v3.13.3/cmake-3.13.3.tar.gz && \
    tar -xvf cmake-3.13.3.tar.gz && \
    cd cmake-3.13.3 && \
    ./configure --prefix=/tools

RUN cd /tmp/cmake-3.13.3 && \
    gmake && \
    make install

RUN cd /tmp && \
    git clone https://github.com/ruben2020/codequery.git && \
    cd codequery && \
    cmake -DCMAKE_INSTALL_PREFIX="${TOOLS}/" -G "Unix Makefiles" -DNO_GUI=ON . && \
    make && \
    make install

RUN chmod +x /tools/loop.sh

RUN cd /tmp && \
    git clone https://github.com/vim/vim.git && \
    cd vim && \
    ./configure --disable-nls --enable-cscope --enable-gui=no --enable-multibyte --enable-pythoninterp=yes --with-features=huge --with-tlib=ncurses --without-x && \

    make && \
    make install

RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN cd /tmp/ && \
    git clone https://github.com/wdyczko/vim.git vimrc && \
    cp /tmp/vimrc/vimrc ~/.vimrc && \
    vim +PlugInstall +qall

RUN curl https://beyondgrep.com/ack-2.24-single-file > /usr/bin/ack && chmod 0755 /usr/bin/ack

ADD scripts/* /tmp/scripts/

RUN cd /tmp/scripts && \
    find . -name "*.py" -o -name "*.sh" | xargs chmod +x && \
    python install.py

ENV LC_ALL="en_US.UTF-8"
ENV EDITOR=vim
ENV TERM=xterm-256color


ENTRYPOINT ["loop.sh"]
