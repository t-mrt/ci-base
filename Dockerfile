FROM debian:buster-20191014-slim

RUN apt-get update && apt-get install -y \
      build-essential \
      curl \
      git \
      jq \
      zlib1g-dev \
      libssl-dev \
      libreadline-dev\
      libffi-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/local/bin

RUN git clone https://github.com/tagomoris/xbuild.git /root/.xbuild

RUN /root/.xbuild/python-install 3.7.5 /root/local/python-3.7.5
RUN /root/.xbuild/node-install v12.12.0 /root/local/node-v12.12.0
RUN /root/.xbuild/go-install 1.13.3 /root/local/go-1.13.3
RUN /root/.xbuild/ruby-install 2.6.5 /root/local/ruby-2.6.5

ENV PATH /root/local/python-3.7.5/bin:$PATH
ENV PATH /root/local/node-v12.12.0/bin:$PATH
ENV PATH /root/local/go-1.13.3/bin:$PATH
ENV PATH /root/local/ruby-2.6.5/bin:$PATH
ENV PATH /root/local/bin:$PATH
ENV GOROOT /root/local/go-1.13.3

RUN curl -sLO https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    pip --version && \
    pip install awscli --upgrade && \
    rm get-pip.py && \
    rm -rf /root/.cache

RUN npm install -g yarn@1.19.1

RUN curl -sLo kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && mv ./kubectl /root/local/bin/kubectl

RUN curl -sLo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 && \
    chmod +x ./skaffold && mv ./skaffold /root/local/bin/skaffold

WORKDIR /workdir

RUN python -V && \
    pip -V&& \
    node -v && \
    npm -v && \
    ruby -v && \
    go version && \
    aws --version && \
    yarn -v && \
    kubectl version --client && \
    skaffold version
