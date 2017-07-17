FROM fedora:23
MAINTAINER sealeg <https://github.com/sealeg>

ENV ANSIBLE_VERSION 2.2

RUN dnf -y update \
&&  dnf -y install iputils sshpass openssh-clients man python \
           asciidoc python2-devel gcc rpm-build \
           gmp-devel libffi-devel openssl-devel \
&&  pip install --no-cache-dir --upgrade pip \
&&  pip install --no-cache-dir --upgrade setuptools \
&&  pip install --no-cache-dir Jinja2==2.8 \
&&  pip install --no-cache-dir ansible==${ANSIBLE_VERSION} \
&&  dnf -y remove asciidoc python2-devel gcc rpm-build \
           gmp-devel libffi-devel openssl-devel \
&&  dnf -y autoremove \
&&  dnf clean all

#RUN wget -O /tmp/ansible-${ANSIBLE_VERSION}.tar.gz \
#      http://releases.ansible.com/ansible/ansible-${ANSIBLE_VERSION}.tar.gz && \
#    tar -xvzf /tmp/ansible-${ANSIBLE_VERSION}.tar.gz -C /tmp && \
#    rm -f /tmp/ansible-${ANSIBLE_VERSION}.tar.gz && \
#    cd /tmp/ansible-${ANSIBLE_VERSION} && \
#    make install

ARG uid=1000

RUN useradd -d /ansible -ms /bin/bash --uid ${uid} ansible
COPY ansible.cfg /ansible/.ansible.cfg
RUN  chown ansible.ansible /ansible/.ansible.cfg
USER ansible
WORKDIR /ansible
RUN mkdir inventory

