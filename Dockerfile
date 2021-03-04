FROM cm2network/steamcmd:root

RUN /home/steam/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/steam/valheim +app_update 896660 +quit

# https://github.com/ValveSoftware/steam-for-linux/issues/7036
RUN apt-get update && \
    apt-get install -yqq libsdl2-2.0-0:i386

COPY valheim_launch.sh /home/steam/

WORKDIR /home/steam