#!/bin/bash
USER_ID=`ls -lahn / | grep mapproxy | awk '{print $3}'`
GROUP_ID=`ls -lahn / | grep mapproxy | awk '{print $4}'`
USER_NAME=`ls -lah / | grep mapproxy | awk '{print $3}'`

groupadd -g $GROUP_ID mapproxy
useradd --shell /bin/bash --uid $USER_ID --gid $GROUP_ID $USER_NAME

# Create a default mapproxy config is one does not exist in /mapproxy
cd /mapproxy
su $USER_NAME -c "uwsgi --http 127.0.0.1:80 --wsgi-file app.py --wsgi-disable-file-wrapper --master --processes 2 --threads 6"
