# Grinder

## Configuration

Edit testsuite.properties as your needed. Don't forget to edit `grinder.script` with the relative path to the test script you want to launch.

Default:

	grinder.script = ./storm/ptg_sync/ptg_sync.py


## Build Grinder image

	sh build-image.sh
	
This command create the image `italiangrid/grinder`.

## Run image

### Environment variables

|Name|Description|Default|
|---|---|---|
|TESTSUITE\_REPO|Testsuite repo's URL|git://github.com/italiangrid/grinder-load-testsuite.git|
|TESTSUITE\_BRANCH|Testsuite branch to use|master|
|TESTSUITE\_TEST\_VONAME|VO name of the storage area under test|test.vo|
|TESTSUITE\_PROPFILE\_FILENAME|Name of the configuration file|testsuite.properties|
|GRINDER\_PROCESSES|Number of processes to launch|4|
|GRINDER\_THREADS|Number of threads for each process to launch|10|
|GRINDER\_RUNS|Number of runs for each thread to do (0 is infinite)|0|
|GRINDER\_USE\_CONSOLE|Boolean flag to determine if you are using a console|true|
|GRINDER\_CONSOLE\_HOST|Hostname of the console|dot1x-179.cnaf.infn.it|
|GRINDER\_LOG\_LEVEL|Grinder process logging level|info|
|WORKER\_LOG\_LEVEL|Worker process logging level|warn|

### Run docker

It's mandatory to add a volume that links the directory where your testsuite.properties file is placed and the fixed container directory /etc/storm/grinder:

Example:

	-v /home/vianello/git/docker-scripts/grinder:/etc/storm/grinder

Example of run with 1 process, 1 thread and 20 runs without console:

	docker run -e "TESTSUITE_BRANCH=develop" -e "GRINDER_USE_CONSOLE=false" -e "GRINDER_RUNS=20" -e "GRINDER_THREADS=1" -e "GRINDER_PROCESSES=1" -v /home/vianello/git/docker-scripts/grinder:/etc/storm/grinder italiangrid/grinder