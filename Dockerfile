FROM alpine:3

RUN ["/bin/sh", "-c", "apk add --update --no-cache py3-pip bash git ca-certificates jq aws-cli"]

COPY ["src", "/src/"]

RUN pip3 install semver

ENTRYPOINT ["/src/main.sh"]
