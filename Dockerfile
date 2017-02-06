FROM ubuntu:14.04

RUN apt-get update && apt-get install --no-install-recommends -y mysql-client python-pip && \
  pip install awscli && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

ADD run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
