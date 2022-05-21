FROM ubuntu:22.04

ARG MODE
ARG CLIENT_UID=1000
ARG CLIENT_GID=1000
ARG CLIENT_USERNAME=client
ARG CLIENT_HOME=/home/$CLIENT_USERNAME
ARG CLIENT_SSH_DIR=$CLIENT_HOME/.ssh
ENV TZ=Europe/Berlin

VOLUME /etc/ssh

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN mkdir --parents "$CLIENT_SSH_DIR" && \
    adduser --system \
      --uid "$CLIENT_UID" \
      --ingroup nogroup \
      --disabled-password \
      --disabled-login \
      --no-create-home \
      --home "$CLIENT_HOME" \
      "$CLIENT_USERNAME" && \
    chown -R "$CLIENT_USERNAME:nogroup" "$CLIENT_HOME" && \
    chmod 755 /docker-entrypoint.sh "$CLIENT_HOME" && \
    chmod 700 "$CLIENT_SSH_DIR" &&\
    mkdir /run/sshd --mode 755 && \
    touch "/mode_$MODE" && \
    chmod 000 "/mode_$MODE"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install \
      --no-install-recommends  \
      --no-install-suggests \
      --assume-yes \
      "openssh-$MODE" \
      gosu && \
    rm -rf /var/lib/apt/lists/* /etc/ssh/ssh_host_*_key /etc/ssh/ssh_host_*_key.pub

ENTRYPOINT ["/docker-entrypoint.sh"]

STOPSIGNAL SIGKILL

CMD []
