ARG SHLINK_VERSION="4.5.0"

FROM shlinkio/shlink:${SHLINK_VERSION}

ENV USER_ID='1001'

COPY custom-entrypoint.sh custom-entrypoint.sh

USER ${USER_ID}

ENTRYPOINT ["/bin/sh", "./custom-entrypoint.sh"]
