# TeamCity Instance with an External MySQL Database on Kubernetes


### Create Kubernetes Resources

```
kubectl apply -f teamcity-configmap.yaml;
kubectl apply -f teamcity-secrets.yaml;
kubectl apply -f mysql-pv.yaml;
kubectl apply -f mysql-deployment.yaml;
kubectl apply -f teamcity-pv.yaml;
kubectl apply -f teamcity.yaml;
kubectl apply -f teamcity-loadbalancer.yaml;
```

_`echo -n 'password' | base64` is used to populate values in teamcity-secerts_
### Stage Persistent TeamCityDataDirectory Volume

```
#Copy mysql driver
mkdir -p /tmp/datadir/lib/jdbc && cp mysql-connector-java-8.0.17.jar /tmp/datadir/lib/jdbc
```

[external mysql database](https://www.jetbrains.com/help/teamcity/setting-up-an-external-database.html?_ga=2.213872598.374019039.1565610915-964155662.1565610915#SettingupanExternalDatabase-MySQL)

### Setup TeamCity

1. Open browser go to `localhost:8111`
2. Proceede with specified data directory path
3. Fill out the necessary Database connection information
```
    Select the database type*: MySQL
    Database host[:port]: mysql:3306
    Database name*: teamcity
    User name: teamcity
    Password: password
```
4. Click Proceed
5. Scroll WAY down and accept license agreement
6. Create TeamCity user and set password

### Delete Kubernetes Resources

```
kubectl delete po teamcity;
kubectl delete deployment,svc mysql;
kubectl delete pvc mysql-pv-claim;
kubectl delete pv mysql-pv-volume;
kubectl delete pvc teamcity-pv-claim;
kubectl delete pv teamcity-pv-volume;
kubectl delete svc teamcity-loadbalancer;
kubectl delete configmap teamcity-config;
kubectl delete secrets teamcity-secrets;
```


### To-Do

- [ ] [Configure Data Directory](https://www.jetbrains.com/help/teamcity/teamcity-data-directory.html#TeamCityDataDirectory-ConfiguringtheLocation)
- [x] Convert env vars to configmaps
- [ ] move pwds from mysql deployment to secrets (pg 222)
- [ ] [Stage database connection string](https://www.jetbrains.com/help/teamcity/setting-up-an-external-database.html?_ga=2.213872598.374019039.1565610915-964155662.1565610915#SettingupanExternalDatabase-DatabaseConfigurationProperties)
    ```
    #/tmp/datadir/config/database.properties
    #Tue Oct 01 13:40:13 GMT 2019
    connectionProperties.user=teamcity
    connectionProperties.password=password
    connectionUrl=jdbc\:mysql\://mysql\:3306/teamcity
    ```
- [ ] ~~move msql-connector into configmap subpath (see page 210 kubernetes in action)~~ file char lenght to long for configmap
- [ ] convert service to ingress instead of loadbalancer
- [ ] deploy to eks
- [ ] [Configure Newly Installed MySQL Server](https://www.jetbrains.com/help/teamcity/how-to.html?_ga=2.213872598.374019039.1565610915-964155662.1565610915#HowTo...-ConfigureNewlyInstalledMySQLServer)