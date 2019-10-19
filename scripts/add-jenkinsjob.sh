#!/bin/bash
# Done by @AloniD

## TEST DATA
JENKINS_USER="admin"
JENKINS_TOKEN="11569e938600e9fc42bcf98746c25fe308"
JENKINS_URL="http://localhost:8083"
JENKINSFILES=("JenkinsfileCI" "JenkinsfileCR" "JenkinsfileCD")

APP_NAME="boring-app97"
JOB_NAMES=("${APP_NAME}_CI" "${APP_NAME}_CR" "${APP_NAME}_CD")
JOB_TEMPLATES=("job-templates/ci-template.xml" "job-templates/cr-template.xml" "job-templates/cd-template.xml")

GIT_URL="https://github.com/dalon1/travel-distance.git"
GIT_CREDENTIALS_ID="enterprise-git-access"
## TEST DATA


TIME=$(date)
echo ''
echo '==============================='
echo 'Adding jenkins job in Jenkins'
echo "${TIME}"
echo '==============================='
echo ''

# Authenticating to retrieve Jenkins Crumb as part of authentication header
echo "Authenticating using '${JENKINS_USER}' credentials."
CRUMB=$(curl -s "${JENKINS_URL}/crumbIssuer/api/json" -u $JENKINS_USER:$JENKINS_TOKEN | jq '.crumb')
CRUMB=${CRUMB/'"'/''} # x2 to remove double quotes
CRUMB=${CRUMB/'"'/''} # x2 to remove double quotes
echo "Jenkins crumb received: ${CRUMB}"
echo "Jenkins Authentication..............................OK"

echo ""
echo "Updating EPL Jenkins Jobs templates"
echo ""

# Reading and passing arguments to Jenkins Jobs XML Templates
len=${#JOB_NAMES[@]}
for (( i=0; i < $len; ++i ))
do
    TMP_TEMPLATE=$(cat "${JOB_TEMPLATES[$i]}")
    TMP_TEMPLATE=${TMP_TEMPLATE/'#GIT_URL#'/$GIT_URL}
    TMP_TEMPLATE=${TMP_TEMPLATE/'#GIT_CREDENTIALS_ID#'/$GIT_CREDENTIALS_ID}
    TMP_TEMPLATE=${TMP_TEMPLATE/'#JENKINSFILE#'/${JENKINSFILES[$i]}}
    echo $TMP_TEMPLATE > "${JOB_NAMES[$i]}.xml"
    echo "${JOB_NAMES[$i]}.xml.........OK"
done
echo "Updating Jenkins Templates..........................OK"

echo ""
echo "Creating jenkins jobs"
echo ""

# Passing XML template and creating Jenkins Jobs
len=${#JOB_NAMES[@]}
for (( i=0; i < $len; ++i ))
do
    TEMPLATE=$(echo "${JOB_NAMES[$i]}.xml")
    RESPONSE=$(curl -u $JENKINS_USER:$JENKINS_TOKEN \
    --data-binary @$TEMPLATE \
    -H "${CRUMB}" -H "Content-Type:text/xml" \
    -X POST "${JENKINS_URL}/createItem?name=${JOB_NAMES[$i]}")

    echo ""
    STATUS="OK"
    if ! [ -z "${RESPONSE}" ]
    then
        echo "$(date) Logs: Error creating jenkins job."
        echo "$(date) Logs: Jenkins job with similar name is already in Master"
        STATUS="FAILURE"
    fi

    echo ""
    echo "${JOB_NAMES[$i]}..........${STATUS}"
    echo "Jenkins job URL: ${JENKINS_URL}/job/${JOB_NAMES[$i]}"
    echo ""
done

echo ""
echo "Triggering jenkins jobs"
echo ""

for (( i=0; i < $len; ++i ))
do
    curl -u $JENKINS_USER:$JENKINS_TOKEN \
    -H "${CRUMB}" \
    -X POST "${JENKINS_URL}/job/${JOB_NAMES[$i]}/build"

    echo ""
    echo "${JOB_NAMES[$i]}..........STARTED"
    echo "Jenkins #1 build URL: ${JENKINS_URL}/job/${JOB_NAMES[$i]}/1/console"
    echo ""
done

# Clean up workspace
echo ""
echo "Cleaning up workspace"
echo ""
rm ./*.xml