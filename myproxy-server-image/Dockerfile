FROM italiangrid:base

ADD . /

run chmod +x /setup.sh && /setup.sh

# setup deployment script
run chmod +x /startup.sh

# expose myproxy server ports
expose 7512


