FROM ubuntu:20.04

COPY entrypoint.sh /entrypoint.sh
COPY deb_control_builder.py /usr/bin/dcb
COPY requirements.txt /requirements.txt

RUN chmod +x /entrypoint.sh /usr/bin/dcb
ENTRYPOINT ["/entrypoint.sh"]

RUN apt-get update
RUN apt-get install -y python3 python3-pip && ln -s python3 /usr/bin/python
RUN pip3 install -r /requirements.txt