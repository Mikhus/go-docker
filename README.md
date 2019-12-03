# Minimalist Go Docker Example

This repo provides an example of building minimalist docker build for Go lang
based microservice.

So the most interesting part is to observe:

 - [Dockerfile](https://github.com/Mikhus/go-docker/blob/master/Dockerfile)
 - [Makefile](https://github.com/Mikhus/go-docker/blob/master/Makefile)

`Dockerfile` represents 2-stage building process. First stage implements
minimalistic go executable build and second one, which is release stage
creates minimalistic zero-size container to run under docker with a single
pre-built executable inside.

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
