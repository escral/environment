FROM ubuntu:noble AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential sudo ansible unzip && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS user
#ARG TAGS
#RUN addgroup --gid 1000 alexander
#RUN useradd -m -s /bin/bash -u 1000 -g 1000 alexander && chown -R alexander:alexander /home/alexander
#RUN usermod -aG sudo alexander
#USER alexander

ENV HOME=/home/alexander
ENV USER=alexander

ARG TAGS
RUN userdel -r ubuntu 2>/dev/null || true && \
    groupdel ubuntu 2>/dev/null || true && \
    addgroup --gid 1000 alexander && \
    adduser --home /home/alexander --gecos alexander --uid 1000 --gid 1000 --disabled-password alexander && \
    usermod -aG sudo alexander
USER root
WORKDIR /home/alexander

FROM user
COPY . .
ARG PLAYBOOK=base
ENV PLAYBOOK=${PLAYBOOK}
CMD ["sh", "-c", "ansible-playbook $TAGS playbooks/${PLAYBOOK}.yml"]

