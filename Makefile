# ISC License
#
# Copyright (c) 2019-present, Mykhailo Stadnyk <mikhus@gmail.com>
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
OUT_NAME      := "microservice"
PKG_ROOT      := "."
BIN_OUT       := "$(PKG_ROOT)/$(OUT_NAME)"
BIN_IN        := "$(PKG_ROOT)/main.go"
VERSION       := `git describe --tags`
HOST_PORT     := "9999"
GUEST_PORT    := "9999"

.PHONY: all

all: clean main

main: clean
	@echo "Building..."
	@go build -ldflags="-s -w -X main.build=`git describe --tags`" \
		-i -v -o $(BIN_OUT) $(BIN_IN)
	@echo "Build success!"
	@echo "Binary is here -> $(BIN_OUT)"

clean:
	@rm -rf $(BIN_OUT)

start:
	@test ! -f $(BIN_OUT) && make --no-print-directory || exit 0
	@echo "Starting..."
	@./$(BIN_OUT)

# Docker manipulations

docker-build: clean
	@docker build -f Dockerfile -t $(OUT_NAME) .
	@make docker-clean
	@echo "Build success! Docker image produced:"
	@docker images | grep $(OUT_NAME)
	@echo "Use 'make docker-run' to start the container"
	@echo "Use 'make docker-stop' to stop the container"

docker-run:
	@docker run -dp $(HOST_PORT):$(GUEST_PORT) --rm -it \
	--name $(OUT_NAME) $(OUT_NAME)

docker-stop:
	@docker stop `docker ps -q --filter ancestor=$(OUT_NAME)` || exit 0

docker-clean: docker-stop
	@echo "Clean all untagged/dangling (<none>) images"
	-docker rmi `docker images -q -f dangling=true` || exit 0

docker-ssh:
	@docker exec -ti $(OUT_NAME) /bin/sh
