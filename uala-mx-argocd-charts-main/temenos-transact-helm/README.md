# Temenos Transact Cloud Agnostic Helm Chart


This Helm chart deploys Temenos Transact on either an Amazon EKS or Azure AKS cluster. Two values files are provided, each 
with values defaulted to the respective platforms.

<br>

## Changelog

| Version   | Date      | Changelog                                                                                                                                                                                                                                                         |
|-----------|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1.0.0     | 24/01/23  | Initial release                                                                                                                                                                                                                                                   |
| 1.1.0     | 30/01/23  | Added required UXP configuration                                                                                                                                                                                                                                  |
| 1.2.0     | 02/02/23  | Added default service accounts for app, web & API. Added support for use of existing service accounts.                                                                                                                                                            |
| 1.3.0     | 02/03/23  |  Added values table in readme, added AWS JDBC Wrapper support, added UXP logs directory, added optional UXP debug logs, added optional app pod app server console access, added PDF rendered readme, made PodSecurityPolicy optional, fixed network policy-issues                                                                                                                                                            |
| 1.4.0     | 29/05/23  |R23 support - MAX_THREAD_COUNT & IDLE_TIMEOUT_VALUE addition, api memory request change,temnmonitor changes , Custom java opts support driven from values yaml,-Xms -Xmx changes for web, api and app pods,Transact explorer support ,Queless iris support  |

---

<br>

## Using the Custom Pod Security Policy in AWS EKS

<br>

If using the custom PodSecurityPolicy option is this chart in AWS EKS, you must delete the default **eks.priveleged** policy.

<br>

---

<br>

## AWS Configuration

The following table lists the configurable parameters of the values-aws.yaml file and the default values.

| Parameter                | Description             | Default        |
| ------------------------ | ----------------------- | -------------- |
| `nameOverride` | (Optional) Override default chart name | `""` |
| `fullnameOverride` | (Optional) Override full default chart name | `""` |
| `deployFI.enabled` | Deploy Temenos Financial Inclusion | `false` |
| `deployATM.enabled` | Deploy Temenos ATM Framework | `false` |
| `logstash.enabled` | Deploy Logstash, required by ther TemnLogger | `false` |
| `appReplicaCount` | Transact app pod replicas | `1` |
| `webReplicaCount` | Transact web pod replicas | `1` |
| `apiReplicaCount` | Transact API pod replicas | `1` |
| `isoReplicaCount` | ISO pod replicas | `1` |
| `logstashReplicaCount` | Logstash pod replicas | `null` |
| `edgeProp` | Configuration modes for UXP Browser. Accepted values: SystemTestProperties, ProductionProperties | `"SystemTestProperties"` |
| `appVersion` | (Optional) Transact version to be used in all image tags in the format {.Values.image.app.repository}:{.Values.image.app.version.}.{.Values.image.app.tag} | `""` |
| `environment` | Deployment environment. Accepted values: aks, eks - for Azure Kubernetes Service and AWS Elastic Kubernetes Service respectively. | `"eks"` |
| `podSecurityPolicy.enabled` | Optional pod security policy to ensure Temenos pods run with with minimal permissions e.g. non-root. Note: PodSecurityPolicies are deprecated as of Kubernetes v1.21 and removed in v.1.25. | `false` |
| `serviceAccount.app` | Transact app service account. If value is blank, the service account will be created. To use an existing service account, set the name here. | `""` |
| `serviceAccount.web` | Transact web service account. If value is blank, the service account will be created. To use an existing service account, set the name here. | `""` |
| `serviceAccount.api` | Transact API service account. If value is blank, the service account will be created. To use an existing service account, set the name here. | `""` |
| `iam.dbAccessRoleArn` | ARN of existing IAM role to be attached to the Transact app service account to grant rds-db:connect permission to enable the token generation by the AWS JDBC Wrapper for DB authentication. Only used if app service account name is not set above, otherwise if app service account name is provided, it is assumed an IAM role is attached granting adequate permissions to the RDS instance. | `""` |
| `image.pullPolicy` | Pull policy for images. | `"IfNotPresent"` |
| `image.pullSecret` | (Optional) Image pull secret. | `""` |
| `image.app.repository` | App image repository. | `"transact-app"` |
| `image.app.tag` | App image tag. | `""` |
| `image.web.repository` | Web image repository. | `"transact-web"` |
| `image.web.tag` | Web image tag. | `""` |
| `image.api.repository` | API image repository. | `"transact-api"` |
| `image.api.tag` | API image tag. | `""` |
| `image.iso.repository` | ISO image repository. | `"transact-iso"` |
| `image.iso.tag` | ISO image tag. | `""` |
| `image.logstash.repository` | Logstash image repository. | `"tem-logstash"` |
| `image.logstash.tag` | Logstash image tag. | `""` |
| `tafjee.OLTP_ACTIVE` | Online transaction processing active. true dictates that this Transact instance will serve the frontend applications. false will make it a Transact batch pod. | `"true"` |
| `tafjee.SERVICE_ACTIVE` | Run the Transact pod as a batch service. | `"false"` |
| `apiIp` | (Optional) Set the API load balancer IP address. | `""` |
| `component.name` | Specifies the Temenos component. Accepted values: transact, lending. Setting this will apply custom network policies with a default deny-all posture. | `"transact"` |
| `database.type` | Database Type: AzureSQL, PostgreSQL, PostgreSQLawsWrapper, Yugabyte or Oracle | `""` |
| `database.user` | Databse username | `""` |
| `database.password` | Databse password - not required if using the PostgreSQLawsWrapper database option. | `""` |
| `database.host` | Database hostname. | `""` |
| `database.encryptedPassword` | Encrypted database password value generated using the EncryptionUtility JAR found in the UXPB Tools package. Required if UXP is deployed and the PostgreSQLawsWrapper database type is not being used. | `""` |
| `database.port` | Database port number | `null` |
| `database.database` | Database schema name | `""` |
| `mq.connectionstring` | ActiveMQ connection string | `""` |
| `mq.user` | ActiveMQ user | `""` |
| `mq.password` | ActiveMQ password | `""` |
| `app.user` | Transact username for UXP artefact connectivity | `""` |
| `app.password` | Transact user password for UXP artefact connectivity | `""` |
| `service.port` | WildFly HTTP port | `8080` |
| `service.httpsPort` | WildFly HTTPS port | `8443` |
| `requests.app.cpu` |  | `"1.5"` |
| `requests.app.memory` |  | `"7G"` |
| `requests.web.cpu` |  | `"1"` |
| `requests.web.memory` |  | `"6G"` |
| `requests.iso.cpu` |  | `"1"` |
| `requests.iso.memory` |  | `"6G"` |
| `requests.api.cpu` |  | `"1.5"` |
| `requests.api.memory` |  | `"6G"` |
| `requests.logstash.cpu` |  | `"200m"` |
| `requests.logstash.memory` |  | `"1G"` |
| `limits.app.cpu` |  | `"1.5"` |
| `limits.app.memory` |  | `"7G"` |
| `limits.web.cpu` |  | `"1"` |
| `limits.web.memory` |  | `"6G"` |
| `limits.iso.cpu` |  | `"1"` |
| `limits.iso.memory` |  | `"6G"` |
| `limits.api.cpu` |  | `"2"` |
| `limits.api.memory` |  | `"12G"` |
| `limits.logstash.cpu` |  | `"200m"` |
| `limits.logstash.memory` |  | `"2G"` |
| `ingress.enabled` | Deploy ingress to expose Transact services externally from the cluster | `true` |
| `ingress.controller` | Ingress controller to expose the Transact services. Accepted values: awsalbcontroller, nginx or agic | `"awsalbcontroller"` |
| `ingress.usePrivateIp` |  | `true` |
| `ingress.annotations` | Additional custom annotations for the ingress/ingress controller. | `{}` |
| `ingress.paths` |  | `[{"path": "/BrowserWeb*", "service": "-svc"}, {"path": "/TAFJ*", "service": "-app-svc"}, {"path": "/Browser*", "service": "-svc"}, {"path": "/irf*", "service": "-lb"}, {"path": "/infinity*", "service": "-lb"}, {"path": "/axis2*", "service": "-app-svc"}, {"path": "/TAFJCobMonitor*", "service": "-app-svc"}]` |
| `autoscaling.enabled` | Enable autoscaling for the Transact pods using the Horizontal Pod Autoscaler | `true` |
| `autoscaling.minReplicas` | Minimum number of Transact pods if autoscaling is enabled | `1` |
| `autoscaling.maxReplicas` | Maximum number of Transact pods if autoscaling is enabled | `5` |
| `autoscaling.targetCPUUtilizationPercentage` | Pod CPU utilisation value at which more replicas will be created to distribute load. | `75` |
| `mount.path` |  | `"/shares/"` |
| `gremlinIPblock` |  | `""` |
| `jboss.MDB_POOL_MAX` | Maximum MDB pool size. | `"6"` |
| `jboss.DB_POOL_MIN` | Minimum database pool size | `"10"` |
| `jboss.DB_POOL_MAX` | Maximum database pool size | `"100"` |
| `jboss.MAX_POOL_SIZE` | JMS Connection factory pool size | `"200"` |
| `jboss.JBOSS_PWD` | Password for application server console admin user | `""` |
| `jboss.console.exposed` | Expose the application server console port in the app | `true` |
| `uxp.debugLogs` | Enable UXP debug logs | `false` |
| `ssl.enabled` | Use SSL for the Transact deployments. | `false` |
| `ssl.filename` | SSL certificate file name present in the ssl directory within this chart. | `""` |
| `ssl.password` | SSL certificate password | `""` |
| `ssl.rootCertName` | SSL certificate root certificate name | `""` |
| `redis.enabled` | Use Redis for the TAFJ cache. | `false` |
| `redis.host` | Redis hostname | `""` |
| `redis.keys` | Redis password | `""` |
| `keycloak.api.enabled` | Enable Keycloak for the API deployment | `false` |
| `keycloak.enabled` | Enable Keycloak for Transact web and app | `false` |
| `keycloak.pkencoded` | Base64 encoded Keycloak Transact realm public key | `""` |
| `keycloak.clientsecret` |  | `""` |
| `keycloak.redirecturi` |  | `""` |
| `keycloak.issuer` | Keycloak Transact realm URL | `""` |
| `keycloak.clientid` | ID of UXP Browser client in KeyCloak | `""` |
| `keycloak.principalclaim` | Name of Transact sign-on-name user attribute in Keycloak | `""` |
| `keycloak.tokenendpoint` | Keycloak transact realm token end point URL | `""` |
| `keycloak.pkcertencoded` |  | `""` |
| `keycloak.authzendpoint` | Keycloak Transact realm authorization end point URL | `""` |
| `keycloak.logoutendpoint` |  | `""` |
| `keycloak.pkjwksuri` |  | `""` |
| `akv.enabled` | Azure KeyVault, not used for AWS EKS deployments | `false` |
| `deployQueueless.enabled` | set true to deploy queless iris where api pod will be removed and app pod will have iris war | `false` |
| `deployTE.enabled` | set true to deploy transact explorer.In this case, classic and UXP browser will not be enabled | `false` |
| `CustomJavaOpts.APP.enabled` | set true to append additional java opts to the app pod | `false` |
| `CustomJavaOpts.APP.JavaOpts` | fully formatted java opts string for example -Dkey1=value1 -Dkey2=value2 |  |
| `CustomJavaOpts.API.enabled` | set true to append additional java opts to the api pod | `false` |
| `CustomJavaOpts.API.JavaOpts` | fully formatted java opts string for example -Dkey1=value1 -Dkey2=value2 |  |
| `CustomJavaOpts.WEB.enabled` | set true to append additional java opts to the web pod | `false` |
| `CustomJavaOpts.WEB.JavaOpts` | fully formatted java opts string for example -Dkey1=value1 -Dkey2=value2 |  |

## Azure Configuration

The following table lists the configurable parameters of the values-azure.yaml file and the default values.

| Parameter                | Description             | Default        |
| ------------------------ | ----------------------- | -------------- |
| `nameOverride` | (Optional) Override default chart name | `""` |
| `fullnameOverride` | (Optional) Override full default chart name | `""` |
| `deployFI.enabled` | Deploy Temenos Financial Inclusion | `false` |
| `deployATM.enabled` | Deploy Temenos ATM Framework | `false` |
| `logstash.enabled` | Deploy Logstash, required by ther TemnLogger | `false` |
| `appReplicaCount` | Transact app pod replicas | `1` |
| `webReplicaCount` | Transact web pod replicas | `1` |
| `apiReplicaCount` | Transact API pod replicas | `1` |
| `isoReplicaCount` | ISO pod replicas | `1` |
| `logstashReplicaCount` | Logstash pod replicas | `null` |
| `edgeProp` | Configuration modes for UXP Browser. Accepted values: SystemTestProperties, ProductionProperties | `"SystemTestProperties"` |
| `appVersion` | (Optional) Transact version to be used in all image tags in the format {.Values.image.app.repository}:{.Values.image.app.version.}.{.Values.image.app.tag} | `""` |
| `domainname` | Environment domain name used for AGIC | `""` |
| `environment` | Deployment environment. Accepted values: aks, eks - for Azure Kubernetes Service and AWS Elastic Kubernetes Service respectively. | `"aks"` |
| `podSecurityPolicy.enabled` | Optional pod security policy to ensure Temenos pods run with with minimal permissions e.g. non-root. Note: PodSecurityPolicies are deprecated as of Kubernetes v1.21 and removed in v.1.25. | `false` |
| `serviceAccount.app` | Transact app service account. If value is blank, the service account will be created. To use an existing service account, set the name here. | `""` |
| `serviceAccount.web` | Transact web service account. If value is blank, the service account will be created. To use an existing service account, set the name here. | `""` |
| `serviceAccount.api` | Transact API service account. If value is blank, the service account will be created. To use an existing service account, set the name here. | `""` |
| `image.pullPolicy` | Pull policy for images. | `"IfNotPresent"` |
| `image.pullSecret` | (Optional) Image pull secret. | `""` |
| `image.app.repository` | App image repository. | `"transact-app"` |
| `image.app.tag` | App image tag. | `""` |
| `image.web.repository` | Web image repository. | `"transact-web"` |
| `image.web.tag` | Web image tag. | `""` |
| `image.api.repository` | API image repository. | `"transact-api"` |
| `image.api.tag` | API image tag. | `""` |
| `image.iso.repository` | ISO image repository. | `"transact-iso"` |
| `image.iso.tag` | ISO image tag. | `""` |
| `image.logstash.repository` | Logstash image repository. | `"tem-logstash"` |
| `image.logstash.tag` | Logstash image tag. | `""` |
| `tafjee.OLTP_ACTIVE` | Online transaction processing active. true dictates that this Transact instance will serve the frontend applications. false will make it a Transact batch pod. | `"true"` |
| `tafjee.SERVICE_ACTIVE` | Run the Transact pod as a batch service. | `"false"` |
| `apiIp` | (Optional) Set the API load balancer IP address. | `""` |
| `config.name` | Resource prefix | `""` |
| `component.name` | Specifies the Temenos component. Accepted values: transact, lending. Setting this will apply custom network policies with a default deny-all posture. | `"transact"` |
| `database.type` | Database Type: AzureSQL, PostgreSQL, PostgreSQLawsWrapper, Yugabyte or Oracle | `""` |
| `database.user` | Databse username | `""` |
| `database.password` | Databse password - not required if using the PostgreSQLawsWrapper database option. | `""` |
| `database.host` | Database hostname. | `""` |
| `database.encryptedPassword` | Encrypted database password value generated using the EncryptionUtility JAR found in the UXPB Tools package. Required if UXP is deployed and the PostgreSQLawsWrapper database type is not being used. | `""` |
| `database.port` | Database port number | `null` |
| `database.database` | Database schema name | `""` |
| `mq.connectionstring` | ActiveMQ connection string | `""` |
| `mq.user` | ActiveMQ user | `""` |
| `mq.password` | ActiveMQ password | `""` |
| `app.user` | Transact username for UXP artefact connectivity | `""` |
| `app.password` | Transact user password for UXP artefact connectivity | `""` |
| `service.port` | WildFly HTTP port | `8080` |
| `service.httpsPort` | WildFly HTTPS port | `8443` |
| `requests.app.cpu` |  | `"1.5"` |
| `requests.app.memory` |  | `"7G"` |
| `requests.web.cpu` |  | `"1"` |
| `requests.web.memory` |  | `"6G"` |
| `requests.iso.cpu` |  | `"1"` |
| `requests.iso.memory` |  | `"6G"` |
| `requests.api.cpu` |  | `"1.5"` |
| `requests.api.memory` |  | `"6G"` |
| `requests.logstash.cpu` |  | `"200m"` |
| `requests.logstash.memory` |  | `"1G"` |
| `limits.app.cpu` |  | `"1.5"` |
| `limits.app.memory` |  | `"7G"` |
| `limits.web.cpu` |  | `"1"` |
| `limits.web.memory` |  | `"6G"` |
| `limits.iso.cpu` |  | `"1"` |
| `limits.iso.memory` |  | `"6G"` |
| `limits.api.cpu` |  | `"2"` |
| `limits.api.memory` |  | `"12G"` |
| `limits.logstash.cpu` |  | `"200m"` |
| `limits.logstash.memory` |  | `"2G"` |
| `ingress.enabled` | Deploy ingress to expose Transact services externally from the cluster | `true` |
| `ingress.controller` | Ingress controller to expose the Transact services. Accepted values: awsalbcontroller, nginx or agic | `"awsalbcontroller"` |
| `ingress.usePrivateIp` |  | `true` |
| `ingress.annotations` | Additional custom annotations for the ingress/ingress controller. | `{}` |
| `ingress.paths` |  | `[{"path": "/BrowserWeb*", "service": "-svc"}, {"path": "/TAFJ*", "service": "-app-svc"}, {"path": "/Browser*", "service": "-svc"}, {"path": "/irf*", "service": "-lb"}, {"path": "/infinity*", "service": "-lb"}, {"path": "/axis2*", "service": "-app-svc"}, {"path": "/TAFJCobMonitor*", "service": "-app-svc"}]` |
| `autoscaling.enabled` | Enable autoscaling for the Transact pods using the Horizontal Pod Autoscaler | `true` |
| `autoscaling.minReplicas` | Minimum number of Transact pods if autoscaling is enabled | `1` |
| `autoscaling.maxReplicas` | Maximum number of Transact pods if autoscaling is enabled | `5` |
| `autoscaling.targetCPUUtilizationPercentage` | Pod CPU utilisation value at which more replicas will be created to distribute load. | `75` |
| `secrets.azurestorageaccountname` |  | `""` |
| `secrets.azurestorageaccountkey` |  | `""` |
| `share.names` |  | `""` |
| `mount.path` |  | `"/shares/"` |
| `gremlinIPblock` |  | `""` |
| `eventhub.jaas_config` |  | `""` |
| `jboss.MDB_POOL_MAX` | Maximum MDB pool size. | `"6"` |
| `jboss.DB_POOL_MIN` | Minimum database pool size | `"10"` |
| `jboss.DB_POOL_MAX` | Maximum database pool size | `"100"` |
| `jboss.MAX_POOL_SIZE` | JMS Connection factory pool size | `"200"` |
| `jboss.JBOSS_PWD` | Password for application server console admin user | `""` |
| `jboss.console.exposed` | Expose the application server console port in the app | `true` |
| `uxp.debugLogs` | Enable UXP debug logs | `false` |
| `ssl.enabled` | Use SSL for the Transact deployments. | `false` |
| `ssl.filename` | SSL certificate file name present in the ssl directory within this chart. | `""` |
| `ssl.password` | SSL certificate password | `""` |
| `ssl.rootCertName` | SSL certificate root certificate name | `""` |
| `redis.enabled` | Use Redis for the TAFJ cache. | `false` |
| `redis.host` | Redis hostname | `""` |
| `redis.keys` | Redis password | `""` |
| `keycloak.api.enabled` | Enable Keycloak for the API deployment | `false` |
| `keycloak.enabled` | Enable Keycloak for Transact web and app | `false` |
| `keycloak.pkencoded` | Base64 encoded Keycloak Transact realm public key | `""` |
| `keycloak.clientsecret` |  | `""` |
| `keycloak.redirecturi` |  | `""` |
| `keycloak.issuer` | Keycloak Transact realm URL | `""` |
| `keycloak.clientid` | ID of UXP Browser client in KeyCloak | `""` |
| `keycloak.principalclaim` | Name of Transact sign-on-name user attribute in Keycloak | `""` |
| `keycloak.tokenendpoint` | Keycloak transact realm token end point URL | `""` |
| `keycloak.pkcertencoded` |  | `""` |
| `keycloak.authzendpoint` | Keycloak Transact realm authorization end point URL | `""` |
| `keycloak.logoutendpoint` |  | `""` |
| `keycloak.pkjwksuri` |  | `""` |
| `akv.enabled` | Use Azure KeyVault | `false` |
| `deployQueueless.enabled` | set true to deploy queless iris where api pod will be removed and app pod will have iris war | `false` |
| `deployTE.enabled` | set true to deploy transact explorer.In this case, classic and UXP browser will not be enabled | `false` |
| `CustomJavaOpts.APP.enabled` | set true to append additional java opts to the app pod | `false` |
| `CustomJavaOpts.APP.JavaOpts` | fully formatted java opts string for example -Dkey1=value1 -Dkey2=value2 |  |
| `CustomJavaOpts.API.enabled` | set true to append additional java opts to the api pod | `false` |
| `CustomJavaOpts.API.JavaOpts` | fully formatted java opts string for example -Dkey1=value1 -Dkey2=value2 |  |
| `CustomJavaOpts.WEB.enabled` | set true to append additional java opts to the web pod | `false` |
| `CustomJavaOpts.WEB.JavaOpts` | fully formatted java opts string for example -Dkey1=value1 -Dkey2=value2 |  |