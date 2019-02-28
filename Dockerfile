ARG CODE_VERSION
ARG BASE_DISTRO

FROM ${BASE_DISTRO}:${CODE_VERSION}

LABEL maintainer="<marcelo.frneves@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive
ENV CHEFUSER=chefadmin
ENV	CHEFPASS="changeme!!"

RUN apt-get update -y && \
	apt-get install wget sudo -y --no-install-recommends

ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN useradd ${CHEFUSER} -s /bin/bash && \
    (echo "${CHEFPASS}" ; echo "${CHEFPASS}") \
    | passwd ${CHEFUSER} && gpasswd -a ${CHEFUSER} sudo


EXPOSE 443 22

ENTRYPOINT []
CMD ["docker-entrypoint.sh"]