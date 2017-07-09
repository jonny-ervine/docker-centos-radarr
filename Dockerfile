# Base on latest CentOS image
FROM centos:latest
MAINTAINER Jonathan Ervine <jon.ervine@gmail.com>
ENV container docker

# Install updates and enable EPEL and epel-multimedia repositories for radarr pre-requisites
RUN yum update -y
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN curl https://negativo17.org/repos/epel-rar.repo -o /etc/yum.repos.d/epel-rar.repo
RUN curl https://negativo17.org/repos/epel-multimedia.repo -o /etc/yum.repos.d/epel-multimedia.repo
RUN rpm --import "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
RUN yum-config-manager --add-repo http://download.mono-project.com/repo/centos/
RUN yum install -y mediainfo libzen libmediainfo ffmpeg git supervisor gettext mono-core mono-devel sqlite wget
RUN yum clean all

RUN wget $( curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 )
RUN tar -xvzf Radarr.develop.*.linux.tar.gz -C /opt/
RUN rm -f Radarr.develop.*.linux.tar.gz

ADD start.sh /sbin/start.sh
ADD supervisord.conf /etc/supervisord.conf
ADD radarr.ini /etc/supervisord.d/radarr.ini

RUN chmod 755 /sbin/start.sh
EXPOSE 7878 9011

VOLUME /config
VOLUME /downloads

CMD ["/sbin/start.sh"]
