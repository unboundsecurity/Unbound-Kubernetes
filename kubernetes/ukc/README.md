#  UKC Server in Kubernetes

The UKC setup includes three servers:
1. Entry Point ("EP")
1. Partner
1. Auxiliary ("AUX")

Each server runs in its' own POD. There are three corresponding deployments: *ukc-ep*, *ukc-partner* and *ukc-aux*. There are also a number of services defined for the sake of internal UKC communications.

Note that the number of replicas in each deployment **should not** be changed from 1. To scale the setup, see [Scaling](#Scaling) below.

The setup is stateful: On the first run it is initialized. The state is preserved unless the corresponding PVCs are deleted.

**Note:** The state of each server should correspond. One cannot initialize just one of them without the others. Once initialized, servers (and the corresponding PODs) may be restarted separatly. See [UKC documentation](https://www.unboundtech.com/docs/TechDocs/Unbound_Doc_Versions-HTML/Content/Products/UnboundDocLibrary/Technical_Document_Versions.htm#UKC) for more details.

In addition, Mongo DB is used for centralized logging. See the details [here](../other/mongodb/README.md).

## Configure the setup before start
The Kubernetes secret files contain default passwords, notably the UKC root password, that one should change. A number of other items may be configured for UKC. See the [Configmap file](ukc-server/deployments/ukc-configmap.yaml) for more informatoin.

## Work with UKC
The *ukc-ui* service is defined as a load balancer that exposes the UKC web interface externally. Another option is to work with the UKC command-line interface, either directly from the UKC EP server or externally. (The later option requires UKC client installation and configuration.)

## Scaling
To scale the setup, additional servers may be added. Two *StatefulSet* objects are provided, *add-ep* and *add-partner*. By default, they are created with 0 replicas, but the number may be increased/decreased as needed. One should keep number of replicas the same for both sets. For example:

     > kubectl scale statefulset add-ep --replicas=1
     > kubectl scale statefulset add-partner --replicas=1


## Other Scripts
Start/stop scripts are provided to apply/delete the UKC deployment. The scripts apply/delete the YAML files in the correct order.

## Logging
A log collector deamon (Fluentd) is running on UKC EP and Partner servers (as well as on additional pairs), monitoring UKC log files and sending them to MongoDB for centralized storage.

Mongo connection details (host, port, user and database) should be configured in the [Mongo config map](../other/mongodb/deployments/mongo-configmap.yaml) and the password in the [Mongo secrets](../other/mongodb/deployments/mongo-secrets.yaml). Note that the corresponding database and user needs to be created on the Mongo DB.

Inside the database log messages are stored in collections according to type: *ekmlog*, *cryptolog* and *tracelog*. (The trace log is OFF by default.)
Each record contains the following fields:
- "server" - the log origin
- "message" - the log line
- "time" - the timestemp
