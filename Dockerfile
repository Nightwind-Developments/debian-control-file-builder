FROM ubuntu:20.04

COPY entrypoint.sh /entrypoint.sh
COPY deb_control_builder.py /dcb.py

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

RUN apt-get update
RUN apt-get install -y python3 python3-pip

RUN file="$(ls -1)" && echo $file

RUN echo "Arguments Read from Entrypoint Script:" \
&& echo "CONFIGURATION FILE  = ${DEB_CONFIG_FILE}" \
&& echo "DEPENDENCY FILE     = ${DEB_DEPS_FILE}"