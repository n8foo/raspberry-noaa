FROM ubuntu:latest
MAINTAINER matiasozdy@gmail.com

RUN  export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && apt-get update && apt-get -y install predict python-setuptools ntp cmake libusb-1.0 git sox at nginx wget cron
RUN mkdir -p /etc/modprobe.d/
RUN echo "blacklist dvb_usb_rtl28xxu \
blacklist rtl2832 \
blacklist rtl2830" > /etc/modprobe.d/rtlsdr.conf
RUN git clone https://github.com/keenerd/rtl-sdr.git && cd rtl-sdr && \
    mkdir build && cd build && cmake ../ -DDETACH_KERNEL_DRIVER=ON -DINSTALL_UDEV_RULES=ON && make && \
    make install && ldconfig
RUN wget https://wxtoimgrestored.xyz/beta/wxtoimg-linux-armhf-2.11.2-beta.tar.gz && tar zxvf wxtoimg-linux-armhf-2.11.2-beta.tar.gz
#dpkg -i wxtoimg-linux-armhf-2.11.2-beta.deb
COPY .noaa.conf /.noaa.conf
ADD crontab /etc/cron.d/noaa-cron
RUN chmod 0644 /etc/cron.d/noaa-cron
RUN crontab /etc/cron.d/noaa-cron
RUN touch /var/log/cron.log
COPY nginx.cfg /etc/nginx/conf.d
RUN mkdir /var/www/wx
COPY index.html /var/www/wx
COPY post.py /
COPY receive.sh /
COPY sun.py /
COPY schedule.sh /
COPY schedule_sat.sh /
CMD nginx && cron -f && tail -f /var/log/cron.log
