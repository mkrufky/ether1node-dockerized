# download stage
FROM debian:latest AS fetcher

RUN apt-get update -y
RUN apt-get dist-upgrade -y
RUN apt-get install -y wget sudo

WORKDIR /

ADD https://ether1.org/scripts/debian/setup.sh /
RUN chmod +x setup.sh
RUN ./setup.sh

# final stage
FROM debian:latest

RUN apt-get update -y
RUN apt-get dist-upgrade -y

COPY --from=fetcher /usr/sbin/geth /usr/sbin/geth-ether1

CMD [ "/usr/sbin/geth-ether1", "--syncmode=fast", "--cache=512" ]
EXPOSE 30305 30305/udp
