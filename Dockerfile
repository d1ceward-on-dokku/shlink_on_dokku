ARG SHLINK_VERSION="4.4.3"

FROM shlinkio/shlink:${SHLINK_VERSION}

COPY ./entrypoint.sh /etc/shlink/entrypoint.sh
COPY ./run-server.sh /etc/shlink/run-server.sh

EXPOSE 80/tcp

ENTRYPOINT ["/etc/shlink/entrypoint.sh"]

CMD ["/etc/shlink/run-server.sh"]
