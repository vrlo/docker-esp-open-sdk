FROM buildpack-deps:jessie

MAINTAINER vrlo <vrovro@gmail.com>

RUN apt-get update && apt-get -y -q --no-install-recommends install \
    bison \
    flex \
    gawk \
    gperf \
    libtool-bin \
    python-serial \
    texinfo \
    unrar-free \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-password espbuilder \
  && usermod -a -G dialout espbuilder

USER espbuilder

WORKDIR /home/espbuilder

RUN git clone --recursive https://github.com/pfalcon/esp-open-sdk.git \
  && git clone https://github.com/esp8266/source-code-examples.git \
  && cd /home/espbuilder/esp-open-sdk && make STANDALONE=n

ENV PATH /home/espbuilder/esp-open-sdk/xtensa-lx106-elf/bin:/home/espbuilder/esp-open-sdk/esptool/:$PATH
ENV XTENSA_TOOLS_ROOT /home/espbuilder/esp-open-sdk/xtensa-lx106-elf/bin
ENV SDK_BASE /home/espbuilder/esp-open-sdk/esp
#ENV FW_TOOL /home/espbuilder/esptool-ck/esptool

CMD ["bash"]
