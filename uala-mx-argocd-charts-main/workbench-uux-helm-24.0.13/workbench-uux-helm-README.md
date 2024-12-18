# Workbench-uux application

The Workbench-uux is a Node JS based application used as design time app. It is tightly coupled with dsf-worlbenchtools for its functioning both in git mode and non-git mode.


### Installation and running the application on docker desktop

The application can be installed and run in a Docker Container. Binaries and docker file has been provided which can be used to build an image and load into docker container and start it.

Prerequites:

* Dsf-Workbenchtools to be deployed in docker
* Keycloak 
* Docker Desktop 4.2 + installed

### Building workbench-uux docker image

For building the image, we need to download the following artifacts from the workbench-uux build
    1. workbench-uux-preimage-${workbench-uux-version}.zip

The above provided artifact should be extracted into C:/ drive. After unzipping the artifacts, we will build the Docker image and then push it to Azure Container Registry.

### Run the below commands to build workbench-uux image

```sh
cd workbench-uux
docker build -t dsf-uux/workbench-uux .
az acr login -n <crname>
docker tag dsf-uux/workbench-uux <crname>.azurecr.io/workbench-uux:<tag>
docker push <crname>.azurecr.io/workbench-uux:<tag>
```

### Deploy Workbench-uux on to a Kubernetes cluster using Helm

Run Helm install to deploy Workbench-uux by setting the appropriate values

```sh
helm install workbench-uux helm --version 0.2.0 -uux -n workbench-uux \
   
   --set image.tools.repository="$(crName).azurecr.io"/workbench-uux \
   --set image.tools.tag=$(workbench-uux.release) \
   --set service.port=$(workbench-uux.port) \
   --set env.nodeEnv=$(workbench-uux.nodeEnv) \
   --set env.wbToolsBaseUrl=$(workbench-uux.wbToolsBaseUrl) \
   --set env.wbProfile =$(workbench-uux.wbProfile) \ 
   --set env.authProvider =$(workbench-uux.authProvider) \ 
   --set env.loginMode =$(workbench-uux.loginMode) \
   --set env.oidcAuthServerUrl =$(workbench-uux.oidcAuthServerUrl) \ 
   --set env.oidcClientId =$(workbench-uux.oidcClientId) \
   --set env.oidcRealmName =$(workbench-uux.oidcRealmName) \
   --set env.oidcClientSecret =$(workbench-uux.oidcClientSecret) \
   --set env.sessionTimeoutMinutes =$(workbench-uux.sessionTimeoutMinutes) \
   --set env.cookieSecured =$(workbench-uux.cookieSecured) \

   --create-namespace --wait --timeout 10m0s
```

### Health Probes
Once the workbench-uux app deployed, pipeline does a health check and pod readiness of the application by hitting the URL: https://(DomainName)/wb-uux/health which in return state the status as healthy.
