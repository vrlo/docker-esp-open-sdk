FROM buildpack-deps:jessie-scm

MAINTAINER vrlo <vrovro@gmail.com>

# unrar is non-free
RUN echo "deb http://httpredir.debian.org/debian jessie non-free" > /etc/apt/sources.list.d/non-free.list

RUN apt-get update && apt-get install -y --no-install-recommends \
  autoconf \
  automake \
  bison \
  bzip2 \
  flex \
  g++ \
  gawk \
  gcc \
  git \
  gperf \
  libexpat-dev \
  libtool \
  libtool-bin \
  make \
  ncurses-dev \
  nano \
  patch \
  python \
  python-serial \
  sed \
  texinfo \
  unrar \
  unzip \
  wget \
  && rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-password espbuilder \
  && usermod -a -G dialout espbuilder

USER espbuilder

WORKDIR /home/espbuilder

RUN git clone --recursive https://github.com/pfalcon/esp-open-sdk.git \
  && git clone https://github.com/esp8266/source-code-examples.git \
  && cd /home/espbuilder/esp-open-sdk && make STANDALONE=n

#RUN (cd /home/espbuilder/ && git clone https://github.com/tommie/esptool-ck.git && cd esptool-ck && make )

ENV PATH /home/espbuilder/esp-open-sdk/xtensa-lx106-elf/bin:/home/espbuilder/esp-open-sdk/esptool/:$PATH
ENV XTENSA_TOOLS_ROOT /home/espbuilder/esp-open-sdk/xtensa-lx106-elf/bin
ENV SDK_BASE /home/espbuilder/esp-open-sdk/esp_iot_sdk_v1.4.0
#ENV FW_TOOL /home/espbuilder/esptool-ck/esptool

CMD ["bash"]
