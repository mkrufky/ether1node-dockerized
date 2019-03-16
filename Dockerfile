# download stage
FROM debian:latest AS fetcher

RUN apt-get update -y && \
    apt-get dist-upgrade -y

RUN apt-get install -y wget

WORKDIR /usr/sbin

ARG URL
ARG TEMPDIR
ARG ZIPFILE
ARG SHA256SUM

RUN echo ${SHA256SUM} ${ZIPFILE} > ${ZIPFILE}.sha256sum && \
    wget -nv ${URL} && \
    sha256sum -c ${ZIPFILE}.sha256sum && \
    tar -zxvf ${ZIPFILE}

# final stage
FROM debian:latest

RUN apt-get update -y && \
    apt-get dist-upgrade -y

COPY --from=fetcher /usr/sbin/geth /usr/sbin/geth-ether1

CMD [ "/usr/sbin/geth-ether1", "--syncmode=fast", "--cache=512" ]
EXPOSE 30305 30305/udp
