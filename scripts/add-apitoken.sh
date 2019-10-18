#!/usr/bin/env bash


USER="admin"
USER_CRED="admin"
JENKINS_URL="http://localhost:8083"

echo '==============================='
echo 'Adding Jenkins API Token in Jenkins'
echo "$(date)"
echo '==============================='
echo ''

# Creating a new Jenkins API Token
curl -u $USER:$USER_CRED \
-d 'newTokenName=foo' \
-X POST ${JENKINS_URL}/user/${USER}/descriptorByName/jenkins.security.ApiTokenProperty/generateNewToken

# Creating temporal file to keep Jenkins API Toke
echo $USER_CRED > $(whoami).password
