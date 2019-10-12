#!/bin/bash
# Done by @AloniD

TYPE="git"
USER="dannel-git"
USER_PASS="random-password"

JENKINS_USER="admin"
JENKINS_TOKEN="11569e938600e9fc42bcf98746c25fe308"
JENKINS_URL="http://localhost:8083"

TIME=$(date)
echo ''
echo '==============================='
echo 'Adding credentials in Jenkins'
echo "${TIME}"
echo '==============================='
echo ''

echo "Authenticating using '${JENKINS_USER}' credentials."
CRUMB=$(curl -s "${JENKINS_URL}/crumbIssuer/api/json" -u $JENKINS_USER:$JENKINS_TOKEN | jq '.crumb')
CRUMB=${CRUMB/'"'/''} # x2 to remove double quotes
CRUMB=${CRUMB/'"'/''} # x2 to remove double quotes
echo "Jenkins crumb received: ${CRUMB}"

echo ''
echo "Adding credentials in Jenkins"
echo "Credentials Type: ${TYPE}"
echo "Credentials Username: ${USER}"
echo "Credentials Password: ${USER_PASS}"
echo ''

curl --include -X POST "${JENKINS_URL}/credentials/store/system/domain/_/createCredentials" \
-u $JENKINS_USER:$JENKINS_TOKEN \
-H "Jenkins-Crumb: ${CRUMB}" \
--data-urlencode 'json={
  "": "0",
  "credentials": {
    "scope": "GLOBAL",
    "id": "'"enterprise-${TYPE}-access"'",
    "username": "'"${USER}"'",
    "password": "'"${USER_PASSC}"'",
    "description": "'"enterprise ${TYPE} access"'",
    "$class": "com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl"
  }
}'

echo "Jenkins Credentials 'enterprise-${TYPE}-access'.....OK"


