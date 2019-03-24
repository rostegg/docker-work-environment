FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
        libxtst6 \
        wget \
        mesa-utils \
        libxrender1 \
        libxcomposite1 \
        libxslt1.1 \
        libgl1-mesa-dri \
        libgl1-mesa-glx \
        libxcomposite1 \
        libxslt1.1 \
        libgstreamer1.0-0 \
        libgstreamer-plugins-base1.0-0 \
        dbus-x11 \
        dunst \
        hunspell-en-us \
        python3-dbus \
        software-properties-common \
        libpulse-mainloop-glib0 \
        alsa-utils \
        libasound2 \
        libasound2-plugins \
        pulseaudio \
        pulseaudio-utils \
        qt5-default \
        libx11-xcb1 \
        gconf2 \
        libpulse0 \
        libasound2 \
        libnss3 \
        libcurl3 \
        binutils \
        libsm6 \
        libxrender1 \
        libfontconfig1 \
        zenity \
        --no-install-recommends && \
            apt-get clean

ENV HOME /home/pulseaudio

RUN useradd --create-home --home-dir $HOME pulseaudio && \
	usermod -aG audio,pulse,pulse-access pulseaudio && \
	chown -R pulseaudio:pulseaudio $HOME

RUN cd /tmp && \
    wget http://download.cdn.viber.com/cdn/desktop/Linux/viber.deb && \
    dpkg -i viber.deb || apt-get -fy install 

RUN ln -sf /usr/lib/x86_64-linux-gnu/qt5/plugins/platforms/ /usr/bin/

ENV QT_XKB_CONFIG_ROOT=/usr/share/X11/xcb
ENV QT_QPA_PLATFORM_PLUGIN_PATH=/usr/share/X11/xcb



WORKDIR $HOME
USER pulseaudio

RUN pulseaudio -D

CMD ["/opt/viber/Viber"]