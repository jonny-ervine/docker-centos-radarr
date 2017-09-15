# docker-centos-radarr
## Radarr Movie Organiser on CentOS (7.4)
### Build Version: 3
Date: 15th September 2017

The Dockerfile should intialise the CentOS image and subscribe to the EPEL, mono, EPEL-rar, and EPEL-multimedia repositories (the last two are hosted at negativo17.org) The pre-requisites for Radarr are then installed via yum.

The EPEL repository provides:

    supervisor mediainfo libzen libmediainfo ffmpeg

The Radarr daemon is controlled via the supervisord daemon which has a web front end exposed via port 9011. Default username and password for the web front end is admin:admin.

The Radarr software package is downloaded as a tarball file from the Radarr github master branch and then extracted into the docker container ready for use.

The container can be run as follows:

    docker pull jervine/docker-centos-radarr
    docker run -d --network=<optional network> --name <optional container name> -h <optional hostname> -e <optional timezone> -e USER=<user to run as> -e USERUID=<userid of user> -v /docker/config/radarr:/config -v <movie directory on host>:<movie directory in container> -v <download directory on host>:<download directory in container> -p 7878:7878 jervine/docker-centos-radarr
    

The USER and USERUID variables will be used to create an unprivileged account in the container to run the Radarr application under. The startup.sh script will create this user and also inject the username into the user= parameter of the radarr.ini supervisor file.

THe TZ variable allows the user to set the correct timezone for the container and should take the form "Europe/London". If no timezone is specified then UTC is used by default. The timezone is set up when the container is run. Subsequent stops and starts will not change the timezone.

If the container is removed and is set up again using docker run commands, remember to remove the .setup file so that the start.sh script will recreate the user account and set the local time correctly.

The container can be verified on the host by using:

    docker logs <container id/container name>

Please note that the SELinux permissions of the config and downloads directories may need to be changed/corrected as necessary. [Currently chcon -Rt svirt_sandbox_file_t ]
