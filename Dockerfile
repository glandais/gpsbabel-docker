FROM alpine:latest AS gpsbabel-build

RUN	apk add --no-cache --update \
	alpine-sdk \
	libusb-dev \
	sed \
	qt5-qtbase \
	qt5-qtmultimedia-dev \
	qt5-qttools-dev \
	qt5-qtbase-x11 \
	git
RUN git clone https://github.com/gpsbabel/gpsbabel.git gpsbabel
WORKDIR /gpsbabel/
RUN ./configure
RUN make

FROM alpine:latest
RUN	apk add --no-cache --update libgcc qt5-qtbase libusb ca-certificates
RUN mkdir /gpsbabel && mkdir /work

WORKDIR /gpsbabel/
COPY --from=gpsbabel-build /gpsbabel/gpsbabel /gpsbabel/
WORKDIR /work/
ENTRYPOINT	["/gpsbabel/gpsbabel"]
