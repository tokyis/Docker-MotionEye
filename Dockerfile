# MotionEye

FROM ubuntu:17.10

LABEL maintainer="malvarez00@icloud.com"

ENV DEBIAN_FRONTEND noninteractive
ENV MOTIONEYE_VERSION="0.39.1"

# Install motion, ffmpeg, v4l-utils and the dependencies from the repositories
RUN apt-get update && \
    apt-get -y -f install \
        wget \
        gdebi-core \
        motion \
        ffmpeg \
        v4l-utils \
        tzdata \
        python-pip \
        python-dev \
        curl \
        libssl-dev \
        libcurl4-openssl-dev \
        libjpeg-dev &&\
     apt-get clean

# Install latest motion (4.1.1)
RUN wget -O /tmp/motion_4.1.1-1_amd64.deb https://github.com/Motion-Project/motion/releases/download/release-4.1.1/bionic_motion_4.1.1-1_amd64.deb
RUN gdebi -n /tmp/motion_4.1.1-1_amd64.deb
RUN rm /tmp/motion_4.1.1-1_amd64.deb

# Install motioneye, which will automatically pull Python dependencies (tornado, jinja2, pillow and pycurl)
RUN pip install motioneye==$MOTIONEYE_VERSION

# Prepare the configuration directory and the media directory
RUN mkdir -p /etc/motioneye \
    mkdir -p /var/lib/motioneye

# Configurations, Video & Images
VOLUME ["/etc/motioneye", "/var/lib/motioneye"]

# Start the MotionEye Server
CMD test -e /etc/motioneye/motioneye.conf || \
    cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf ; \
    /usr/local/bin/meyectl startserver -c /etc/motioneye/motioneye.conf

EXPOSE 8765
