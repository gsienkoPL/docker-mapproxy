#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM python:3.7
MAINTAINER G Sienko<grzegorz.sienko@lublin.eu>

RUN apt-get -y update

#-------------Application Specific Stuff ----------------------------------------------------

RUN apt-get install -y \
    python-yaml \
    libgeos-dev \
    python-lxml \
    libgdal-dev \
    build-essential \
    python-dev \
    libjpeg-dev \
    zlib1g-dev \
    libfreetype6-dev \
    python-virtualenv \
    && apt-get -y --purge autoremove && apt-get clean \\
    && rm -rf /var/lib/apt/lists/* 

RUN pip3 install Numpy PyYaml boto3 request eventlet lxml Shapely Pillow uwsgi redis
RUN pip3 install git+https://github.com/mapproxy/mapproxy.git@1.13.0

EXPOSE 8080

ADD app.py /mapproxy/app.py
ADD start.sh /start.sh
RUN chmod 0755 /start.sh

#USER www-data
# Now launch mappproxy in the foreground
# The script will create a simple config in /mapproxy
# if one does not exist. Typically you should mount 
# /mapproxy as a volume
CMD /start.sh
