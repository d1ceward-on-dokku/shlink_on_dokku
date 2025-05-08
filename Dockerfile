ARG SHLINK_VERSION="4.4.6"

FROM shlinkio/shlink:${SHLINK_VERSION}

ENV USER_ID='1001'

COPY custom-entrypoint.sh custom-entrypoint

USER ${USER_ID}

ENTRYPOINT ["/bin/sh", "./custom-entrypoint.sh"]
