# Mongo DB Deployment

Mongo DB is used in UKC/CASP setup to store logs. The *mongo.yaml* file includes a sample Mongo DB *StatefulSet* along with the corresponding service. The setup is provided for demonstration purposes only, and should not be used as-is in production.

Logs are collected from all running instances into the following collections:
  
- ukclog
- ukctracelog
- ukccryptolog
- casplog
- casptracelog
  
## Configuration

The [Mongo secrets file](deployments/mongo-secrets.yaml) contains default passwords, notably the Mongo root password. A number of other items may be configured, see the [Configmap file](deployments/mongo-configmap.yaml) for more information.

To access the logs, use the database and credentials as configured, in the Mongo shell:

```bash
mongo -u <your-user> -p <your-password> -d <logs-DB-name>
```


For example, with the default settings:

```bash
mongo -u unbound -p Unbound1! unboundLogDB
```

## Filtering

Logs are collected from all running instances. You can filter the collection by the specific source server.

To use MongoDB filtering:

```mongo
db.<collection name>.find({"server": <server name>});
```

For example:

- UKC logs from *ukc-ep*:

    ```mongo
    db.ukclog.find({"server": "ukc-ep"});
    ```

- UKC trace logs from *ukc-partner*:

    ```mongo
    db.ukctracelog.find({"server": "ukc-partner"});
    ```

- UKC crypto logs from *ukc-ep* additional server:

    ```mongo
    db.ukccryptolog.find({"server": "add-ep-0"});
    ```

- CASP logs from CASP 1st server:

    ```mongo
    db.casplog.find({"server": "casp-server-0"});
    ```

- CASP trace logs from CASP 2nd server:

    ```mongo
    db.casptracelog.find({"server": "casp-server-1"});
    ```

## Scripts
Start/stop scripts are provided to apply/delete the Mongo deployment.
