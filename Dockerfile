FROM fedora

ENV PROXY_IP=87.254.212.120
ENV PROXY_PORT=8080
ENV http_proxy=http://${PROXY_IP}:${PROXY_PORT}
ENV https_proxy=http://${PROXY_IP}:${PROXY_PORT}
ENV HTTP_PROXY=http://${PROXY_IP}:${PROXY_PORT}
ENV HTTPS_PROXY=http://${PROXY_IP}:${PROXY_PORT}

ENV TOOLS /tools
ENV PATH $PATH:$TOOLS:$TOOLS/bin
ENV CODE /code
ENV BASE /base

ENV LANG="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"
ENV EDITOR=vim
ENV TERM=xterm-256color

RUN mkdir -p $TOOLS && \
    mkdir -p $BASE

RUN echo -e "proxy=${HTTP_PROXY}" >> /etc/dnf/dnf.conf

RUN curl -sL https://rpm.nodesource.com/setup_11.x | bash

RUN dnf install -y findutils && \
    dnf install -y git && \
    dnf install -y ctags && \
    dnf install -y cscope && \
    dnf install -y vim && \
    dnf install -y clang && \
    dnf install -y nodejs && \
    dnf clean all

RUN curl https://raw.githubusercontent.com/wdyczko/vim/master/one_line_install.sh | bash

RUN pip3 install yapf

RUN npm install -g js-beautify

ADD scripts/* /tmp/scripts/

RUN cd /tmp/scripts && \
    find . -name "*.py" -o -name "*.sh" | xargs chmod +x && \
    ./install.py

ENTRYPOINT ["loop"]
