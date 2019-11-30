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

############### 1. BUILD STAGE ###############
FROM golang:1.13-alpine AS build

RUN apk add --no-cache git make bash
RUN mkdir -p /opt/app

WORKDIR /opt/app

COPY ./* ./
RUN make

############### 2. RELEASE STAGE ###############
FROM alpine:latest AS release

COPY --from=build /opt/app/microservice /bin

EXPOSE 9999

CMD [ "microservice" ]
