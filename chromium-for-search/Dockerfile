FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y \
        fonts-liberation \
        chromium-browser \
        pulseaudio \
        wget \
        tzdata \
        fonts-roboto \
        fonts-symbola \
        hicolor-icon-theme \
        libcanberra-gtk-module \
        libexif-dev \
        libgl1-mesa-dri \
        libgl1-mesa-glx \
        libpango1.0-0 \
        libv4l-0 && \
                apt-get clean
        
ENV HOME /home/chromium
RUN useradd --create-home --home-dir $HOME chromium && \
        usermod -aG audio,pulse,pulse-access chromium && \
	chown -R chromium:chromium $HOME

WORKDIR $HOME
USER chromium

VOLUME ["/home/chromium"]
CMD ["/usr/bin/chromium-browser", "--enable-logging=stdout" ]