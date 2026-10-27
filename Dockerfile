FROM opensuse/leap:16.0
LABEL maintainer="Jeff Geerling"
ENV container=docker

ENV pip_packages="ansible"

# Install systemd (based on official CentOS instructions).
RUN zypper -n install systemd && zypper clean && \
    rm -f /lib/systemd/system/multi-user.target.wants/* && \
    rm -f /etc/systemd/system/*.wants/* && \
    rm -f /lib/systemd/system/local-fs.target.wants/* && \
    rm -f /lib/systemd/system/sockets.target.wants/*udev* && \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl* && \
    rm -f /lib/systemd/system/basic.target.wants/* && \
    rm -f /lib/systemd/system/anaconda.target.wants/*

# Install base requirements and Python 3.
RUN zypper refresh && \
    zypper install -y \
      sudo \
      which \
      hostname \
      iproute2 \
      python3 \
      python3-pip \
      python3-wheel \
      python3-PyYAML && \
    zypper clean -a

# Upgrade pip, setuptools, and wheel.
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel

# Install Ansible via Pip (latest).
RUN pip3 install --no-cache-dir $pip_packages

# Install a minimal Ansible inventory.
RUN mkdir -p /etc/ansible
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup"]
CMD ["/usr/lib/systemd/systemd"]
