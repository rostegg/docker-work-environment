FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
	apt-get install -y \
	    wireshark && \
	        apt-get clean

ENV HOME /home/wireshark

RUN useradd --create-home --home-dir $HOME wireshark \
	&& chown -R wireshark:wireshark $HOME

# https://wiki.wireshark.org/CaptureSetup/CapturePrivileges#Most_UNIXes
RUN chown root /usr/bin/dumpcap
RUN chmod u+s /usr/bin/dumpcap

USER wireshark

WORKDIR ${HOME}

CMD ["wireshark"]