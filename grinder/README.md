# 1. Load tests via Docker containers

The aim is to launch a session of load tests aginst a StoRM deployment, through grinder-load-testsuite executed within a Docker container.

## 1.1 Testsuite configuration

Before lauching the container, edit testsuite.properties as your needed. Don't forget to edit `grinder.script` with the relative path to the test script you want to launch.

Example:

        grinder.script = ./storm/ptg_sync/ptg_sync.py

The `testsuite.properties` file contains all the info necessary both to the container and to the testsuite.

###  1.1.1 Testsuite properties

Testsuite properties tells Docker from where to download the sources and which branch has to be launched.

|Name|Description|Default|
|:--|:--|:--|
|**testsuite.repo** | Testsuite git repository URL | *git://github.com/italiangrid/grinder-load-testsuite.git*
|**testsuite.branch** | Which branch to select and run | *develop*

### 1.1.2 Authorization properties

Authorization properties are useful to create the necessary VOMS proxy to access the desired storage area.

|Name|Description|Default|
|:--|:--|:--|
|**proxy.voname** | VO name used to create the used VOMS proxy credentials | *test.vo*
|**proxy.user** | IGI test CA user to use | *test0*

### 1.1.3 Execution properties

Execution properties are given as input to the grinder execution.

|Name|Description|Default|
|:--|:--|:--|
|**grinder.processes** | Number of processes to launch| 1
|**grinder.threads** | Number of threads per process to launch | 1
|**grinder.runs** | Number of runs for each thread to execute | 1
|**grinder.console.use** | Attach processes to a console. Allowed values: *True*/*False* | *False*
|**grinder.console.host** | The hostname of the console used | -
|**grinder.script** | The test to launch | */storm/mixdav/mixdav.py*

### 1.1.4 Common properties

Common properties can be used by all the tests.

|Name|Description|Default|
|:--|:--|:--|
|**common.storm\_fe\_endpoint\_list**| Comma separated list of StoRM Frontend endpoints. | *omii006-vm03.cnaf.infn.it:8444*
|**common.storm\_dav\_endpoint\_list**| Comma separated list of StoRM WebDAV endpoints. | *omii006-vm03.cnaf.infn.it:8443*
|**common.test_storagearea** | The Storage Area where load tests will be launched. | *test.vo*

### 1.1.5 PtG-Sync properties

In case of PtG tests, these are the customizations available.

|Name|Description|Default|
|:--|:--|:--|
|**ptg\_sync.test\_directory**| Remote test working directory name | *PtG*
|**ptg\_sync.sleep\_threshold**| Number of max attempts of status requests | 50
|**ptg\_sync.sleep\_time**| sec to wait between status requests | .5
|**ptg\_sync.do\_handshake**| Ping endpoint before launching tests. Allowed values: *True*/*False* | *True*
|**ptg\_sync.num\_files**| Number of files created and used by the test. Each run will do a PtG on one of these, randomly. | 1

### 1.1.6 Ls-test properties

In case of Ls tests, these are the customizations available.

|Name|Description|Default|
|:--|:--|:--|
|**ls.test\_directory** | Remote test working directory name | *Ls*
|**ls.test\_directory\_width** | Number of files to be created within each sub-directory during setup phase. | 10
|**ls.test\_directory\_height** | Number of recursive sub-directory to be created into remote test directory during setup phase. | 4
|**ls.do\_setup** | Do the setup phase. Allowed values: *yes*/*no* | *yes*
|**ls.do\_cleanup** |  Do the final cleanup phase. Allowed values: *yes*/*no* | *yes*

### 1.1.7 MkRmDir properties

In case of MkRmDir tests, these are the customizations available.

|Name|Description|Default|
|:--|:--|:--|
|**mkrmdir.test\_directory** | Remote test working directory name | *MkRmDir*

### 1.1.8 Rm-files properties

In case of Rm files tests, these are the customizations available.

|Name|Description|Default|
|:--|:--|:--|
|**rm.test\_directory** | Remote test working directory name | *rm\_files*
|**rm.test\_number\_of\_files** |  Number of files created and used by the test. Each run will do a srmRm on all of these files. | 10

### 1.1.9 MixDAV properties

In case of mixed WebDAV tests, these are the customizations available.

|Name|Description|Default|
|:--|:--|:--|
|**mixdav.test\_directory** | Remote test working directory name | *mix-webdav*


## 2. Run testsuite

Having set the desired properties, it's time to launch tests.

### 2.1 Build image

First of all, build the docker image:

        sh build-image.sh

This command creates the image `italiangrid/grinder:latest`.

### 2.2 Run image

It's mandatory to add a volume that links the directory where your testsuite.properties file is placed and the fixed container directory /etc/storm/grinder:

Example:

	-v /home/vianello/git/docker-scripts/grinder:/etc/storm/grinder

Example of run with 1 process, 1 thread and 1 runs (as default) without console:

	docker run -v /home/vianello/git/docker-scripts/grinder:/etc/storm/grinder italiangrid/grinder