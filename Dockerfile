FROM ubuntu:14.04

RUN apt-get update

# https://downloads.mariadb.org/mariadb/repositories/#mirror=digitalocean-sfo&distro=Ubuntu&distro_release=trusty--ubuntu_trusty&version=10.1
RUN apt-get install -y software-properties-common && \
    apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db && \
    sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu trusty main'

RUN apt-get install --no-install-recommends -y mariadb-client python-pip && \
  pip install awscli && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

ADD run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
