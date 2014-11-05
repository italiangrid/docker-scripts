FROM italiangrid:base

# add and run setup
add . /
run chmod +x /setup.sh && /setup.sh

# setup for the tester user
workdir /home/tester

entrypoint /setup_testsuite.sh
