image: build

env:
	$(eval GIT_REF=$(shell git rev-parse --short HEAD))

build: env
	@echo building ether1node:${GIT_REF}
	@docker build -f Dockerfile -t ether1node:${GIT_REF} .

daemon: build
	@docker run -p 30305:30305 -p 30305:30305/udp --mount source=ether1node,target=/root ether1node:${GIT_REF}

interactive: build
	@docker run -i --mount source=ether1node,target=/root ether1node:${GIT_REF} geth-ether1 attach
