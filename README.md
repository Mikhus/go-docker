# Minimalist Go Docker Example

This repo provides an example of building minimalist docker build for Go lang
based microservice.

So the most interesting part is to observe:

 - [Dockerfile](https://github.com/Mikhus/go-docker/blob/master/Dockerfile)
 - [Makefile](https://github.com/Mikhus/go-docker/blob/master/Makefile)

`Dockerfile` represents 2-stage building process. First phase is to run
go build under a target platform, which is based on Alpine Linux. Second
phase creates a release image containing only minimalist Alpine image and
pre-built binary of microservice.

`Makefile` provides a basic command set to automate local and docker builds
of microservice.

With current docker build implementation it results into `1.66 MB` image
size production using `scratch` zero-size image with a packed by `upx`
statically compiled executable inside.

**Is it possible to have less?**

Author would be greatly appreciated for any suggestions and contributions
of further optimizations and improvements to this example. 

## License

[ISC License](https://github.com/Mikhus/go-docker/blob/master/LICENSE)
