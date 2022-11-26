# Pull base from alpine 3.14 for ruby 2.7.6 packages
# alpine:latest has ruby 3.x which breaks wallop

FROM alpine:3.14

MAINTAINER Jarod Watkins <jwatkins@jarodw.com>
# Updated by nick@srgnet.org Nov '22

ENV PKG_CONFIG_PATH /ffmpeg_build/lib/pkgconfig
RUN apk --no-cache add lame-dev libvorbis-dev zlib-dev x264-dev libtheora-dev \
  libvpx-dev rtmpdump-dev v4l-utils-dev x265-dev git build-base libass-dev \
  autoconf automake libtool ruby-dev libstdc++ coreutils bzip2 yasm ruby-bundler \
  ruby-json \

# Install bundler gem to workaround some ruby error when trying to install wallop
  && gem install bundler:1.11.2 \

  && mkdir /ffmpeg_sources \
  && cd /ffmpeg_sources \
  && git clone https://github.com/mstorsjo/fdk-aac.git \
  && cd fdk-aac \
  && autoreconf -fiv \
  && ./configure --prefix="/ffmpeg_build" --disable-shared \
  && make \
  && make install \
  && make distclean \
  && cd /ffmpeg_sources \

# We need to git an older ffmpeg version that supports the hls_wrap option
# Looks like version 5.0 removed this option, any version prior should work

  && git clone git://source.ffmpeg.org/ffmpeg \
  && cd ffmpeg \
  && git checkout tags/n4.1 \

  && ./configure --prefix="/ffmpeg_build" --pkg-config-flags="--static" --enable-gpl \
    --extra-cflags="/ffmpeg_build/include" --extra-ldflags="-L/ffmpeg_build/lib" \
    --bindir="/ffmpeg/bin" --enable-gpl --enable-libx264 --enable-libfdk-aac \
    --enable-nonfree --enable-libmp3lame --enable-libass --enable-libfreetype \
  && make \
  && make install \
  && make distclean \
  && hash -r \
  && git clone --depth 1 https://github.com/maddox/wallop.git /wallop \
  && cd /wallop \
  && bundle install --standalone --binstubs --local --path vendor/gems --quiet \
  && apk del libvorbis-dev zlib-dev libtheora-dev libvpx-dev rtmpdump-dev \
  v4l-utils-dev x265-dev git build-base autoconf automake libtool ruby-dev \
  && rm -rf /ffmpeg_sources \
  && rm -rf /ffmpeg_build

WORKDIR /wallop
VOLUME /tmp
EXPOSE 8888
ENV RACK_ENV production
ENTRYPOINT ["script/server"]
