# ISC License
#
# Copyright (c) 2019-present, Mykhailo Stadnyk <mikhusgmail.com>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
APP_NAME    := go-docker
BIN_OUT     := ./$(APP_NAME)
BIN_IN      := ./main.go
VERSION     := `git describe --tags`
HOST_PORT   := 9999
GUEST_PORT  := 9999

.PHONY: all main clean start
.SILENT: clean start docker-stop docker-clean

all: clean main

main: clean
	@echo "Building..."
	CGO_ENABLED=0 GOOS=linux go build \
		-ldflags="-s -w -X main.build=$(VERSION) -X main.port=$(GUEST_PORT)" \
		-a -installsuffix cgo \
		-i -v -o $(BIN_OUT) $(BIN_IN)
	@echo "Build success!"
	@echo "Binary is here -> $(BIN_OUT)"

clean:
	rm -rf $(BIN_OUT)

start:
	test ! -f $(BIN_OUT) && make --no-print-directory || exit 0
	echo "Starting..."
	./$(BIN_OUT)

# Docker manipulations

docker-build: clean
	docker build \
		--build-arg APP_NAME=$(APP_NAME) \
		-f Dockerfile \
		-t $(APP_NAME) .
	@echo "Build success! Docker image produced:"
	docker images | grep $(APP_NAME)

docker-run:
	docker run -dp $(HOST_PORT):$(GUEST_PORT) --rm -it \
		--name $(APP_NAME) $(APP_NAME)

docker-stop:
	echo "Stopping running container, if any..."
	docker stop `docker ps -q --filter ancestor=$(APP_NAME)` 2>/dev/null ||:

docker-clean: docker-stop
	echo "Clean all untagged/dangling (<none>) images"
	docker rmi `docker images -q -f dangling=true`

docker-ssh:
	docker exec -ti $(APP_NAME) /bin/sh
