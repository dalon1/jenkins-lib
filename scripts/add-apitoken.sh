#!/usr/bin/env bash


USER="admin"
USER_CRED="admin"
JENKINS_URL="http://localhost:8083"

echo '==============================='
echo 'Adding Jenkins API Token in Jenkins'
echo "$(date)"
echo '==============================='
echo ''


# Authenticating to retrieve Jenkins Crumb as part of authentication header
echo "Authenticating using '${JENKINS_USER}' credentials."
CRUMB=$(curl -s "${JENKINS_URL}/crumbIssuer/api/json" -u $USER:$USER_CRED | jq '.crumb')
CRUMB=${CRUMB/'"'/''} # x2 to remove double quotes
CRUMB=${CRUMB/'"'/''} # x2 to remove double quotes
echo "Jenkins crumb received: ${CRUMB}"
echo "Jenkins Authentication..............................OK"



# Creating a new Jenkins API Token
curl --include -u $USER:$USER_CRED \
-H "Jenkins-Crumb: ${CRUMB}" \
-H "Content-Type:application/x-www-form-urlencoded" \
-d 'newTokenName=foo' \
-X POST ${JENKINS_URL}/user/${USER}/descriptorByName/jenkins.security.ApiTokenProperty/generateNewToken

# Creating temporal file to keep Jenkins API Toke
echo $USER_CRED > $(whoami).password
