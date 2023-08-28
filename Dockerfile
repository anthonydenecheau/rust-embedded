FROM ubuntu:22.04 as base

# https://forums.balena.io/t/usb-device-cannot-be-viewed-by-docker-container-libusb/356883/2
ENV UDEV=1

COPY ./scripts/* /scripts/

RUN apt update && apt install -yqq \
      build-essential \
      pkg-config \
      sudo \
      curl \
      gpg \
      apt-transport-https \
      udev \
      openssl libssl-dev usbutils

# Get Rust; NOTE: using sh for better compatibility with other base images
RUN curl https://sh.rustup.rs --tlsv1.2 -sSf | bash -s -- -y
# Add .cargo/bin to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

RUN /bin/bash -e /scripts/install.sh 

# https://www.google.com/search?q=Docker+build+Failed+to+send+reload+request%3A+No+such+file+or+directory&sca_esv=560664892&rlz=1C1GCEU_frFR829FR829&sxsrf=AB5stBj-J5cCi8FDypwisaUVKguWjK5-fg%3A1693237095674&ei=Z7_sZJfWKO3rkdUP6Z-K4AQ&ved=0ahUKEwjXpe7c1_-AAxXtdaQEHemPAkwQ4dUDCA8&uact=5&oq=Docker+build+Failed+to+send+reload+request%3A+No+such+file+or+directory&gs_lp=Egxnd3Mtd2l6LXNlcnAiRURvY2tlciBidWlsZCBGYWlsZWQgdG8gc2VuZCByZWxvYWQgcmVxdWVzdDogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeUjfFFC4Blj7E3ABeAGQAQCYAVigAdoGqgECMTG4AQPIAQD4AQHCAgoQABhHGNYEGLADwgIHEAAYDRiABMICBhAAGAcYHsICBhAAGB4YDcICCBAAGAUYHhgNwgIEEAAYHuIDBBgAIEGIBgGQBgg&sclient=gws-wiz-serp
USER root
RUN /lib/systemd/systemd-udevd --daemon && udevadm control --reload-rules

# remove any unnecessary files and data that may be stored in the intermediate layers 
# en doublon avec install.sh
#RUN apt-get clean \
#    && rm -rf /var/lib/apt/lists/*

COPY ./scripts/onStartUp.sh /usr/local/bin/onStartUp.sh 
RUN chmod +x /usr/local/bin/onStartUp.sh 
CMD ["onStartUp.sh"]
