# Total View Sample

This guide will help you deploy InterSystems Total View on your local PC using docker and a docker compose file.

Here is what you will need:
* If you are using Windows, **you must** [install Git](https://git-scm.com/download/win) and use GitBash as your shell (instead of cmd or powershell)
* A machine with at least 32GiB of RAM and 8 physical cores (16 logical cores)
* Docker installed on your machine configured to have access to at least 10 GiB of RAM and 8 logical cores
* An IRIS Advanced Server Server License (core based, not concurrent user)
* An IRIS Adaptive Analytics (AtScale) license
* An account with InterSystems so you can access our container registry at https://containers.intersystems.com

Feel free to ask your Sales Engineer to help you with the requirements above.

Here is a description of the contents of this repository:

| Component                     | Description                                                                                                                   |
|-------------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| `start.sh`                    | Script used to start the three images as new containers by using the composition defined in the `./docker-compose.yaml` file. |
| `stop.sh`                     | Script used to stop the composition defined in the `./docker-compose.yaml` file. You can use the `./start.sh` script to resume it later and continue your work from where you stopped. |
| `remove.sh`                   | Script used to remove the containers of the composition and purge the durable folders of IRIS and IRIS Adaptive Analytics. This script can be used after switching to another branch in this Git repository so that your images will be rebuilt with the code from that branch. That is why we need to dispose of the durable data saved outside the containers. This script can also be run when the user needs to clean the durable data saved outside the container in order to start clean in the same branch. |
| `logs.sh`                     | Script used to follow the logs of the running composition. |
| `VERSION`                     | File that contains the version of the product on the current branch |
| `CONF_IRIS_LOCAL_WEB_PORT`    | Local port used to reach the IRIS management portal. Default is 42773 which means that the management portal will be at http://localhost:42773/csp/sys/UtilHome.csp |
| `CONF_IRIS_LOCAL_JDBC_PORT`   | Local port used to reach the IRIS SuperServer. Default is 41972. Which means that the default JDBC URL will be jdbc:IRIS://localhost:41972/B360 |
| `CONF_FRONTEND_LOCAL_PORT`    | Local port used to reach the Angular UI Frontend. Default is 8081. Which means that the angular UI will be at http://localhost:8081 |
| `CONF_DOCKER_SUBNET`          | The IPv4 subnet to be used when creating the docker network for this docker-compose project. The default is 172.20.0.0/16. If IRIS Adaptive Analytics is not starting, it may be because you are using a "bad subnet". |
| `CONF_DOCKER_GTW`             | The IPv4 gateway to be used when creating the docker network for this docker-compose project The default is 172.20.0.1. |


# Starting

Make sure you pick the right IRIS license for your platform. If your machine is a Mac M1/M2, you will need an ARM IRIS license and it must be put on the file `./licenses/iris.key`.

Make sure you have an AtScale License on file `./licenses/AtScaleLicense.json`.

In order to start InterSystems Total View (frontend, iris and iris adaptive analytics), run the `./start.sh` script.

The composition will start in the background. You can use the `logs.sh` script to follow its logs.

When you notice that the logs stopped moving, you should be able to start opening things such as:

| What | Where | Username | Password |
|------------------------|---------------------------------------------|-------------|-------|
| Total View             | http://localhost:8081                       | SystemAdmin | sys   |
| AtScale                | http://localhost:10500                      | admin       | admin |
| IRIS Management Portal | http://localhost:42773/csp/sys/UtilHome.csp | SuperUser   | sys   |

# Stopping

You can use the `./stop.sh` script to bring the three containers down and pause them. This will not remove their durable data. You should be able to resume the work by running the `./start.sh` script again.

# Removing containers and durable data

You can use the `./remove.sh` script to stop and remove the current containers and purge their durable data.
