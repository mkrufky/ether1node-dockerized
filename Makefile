image: build

env:
	$(eval GIT_REF=$(shell git rev-parse --short HEAD))
	$(eval URL=$(shell cat zipfile.url.in))
	$(eval ZIPFILE=$(shell echo ${URL} | sed 's#.*/\([^:]*\).*#\1#'))
	$(eval TEMPDIR=/$(shell echo ${ZIPFILE} | sed 's/\.zip//1'))
	$(eval SHA256SUM=$(shell cat zipfile.sha256sum.in))

build: env
	@echo building ether1node:${GIT_REF}
	@docker build --build-arg ZIPFILE="${ZIPFILE}" --build-arg SHA256SUM="${SHA256SUM}" --build-arg URL="${URL}" --build-arg TEMPDIR="${TEMPDIR}" -f Dockerfile -t ether1node:${GIT_REF} .

daemon: build
	@docker run -p 30305:30305 -p 30305:30305/udp --mount source=ether1node,target=/root ether1node:${GIT_REF}

node: daemon

interactive: build
	@docker run -i --mount source=ether1node,target=/root ether1node:${GIT_REF} geth-ether1 attach

attach: interactive

console: interactive
