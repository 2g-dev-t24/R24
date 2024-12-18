#!/bin/bash

# Simple script to package this Helm chart in a consistent manner with an md5 sha for 
# releasing to distribution, not to be included in the released package. Version should
# follow the existing versioned releases of Transact_AWS_scripts_package_vX.X.X to
# distribution.

echo -n "Version: "
read version

mkdir transact-eks-helm

cp -r templates/ *.yaml README.md README.pdf transact-eks-helm/

zip -r Transact_AWS_scripts_v$version.zip transact-eks-helm/

md5sum Transact_AWS_scripts_v$version.zip > Transact_AWS_scripts_v$version.zip.md5

rm -rf transact-eks-helm/