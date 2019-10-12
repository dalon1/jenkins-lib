#!/bin/bash
# Done by @AloniD

JENKINS_USER="admin"
JENKINS_TOKEN="11569e938600e9fc42bcf98746c25fe308"
JENKINS_URL="http://localhost:8083"

APP_NAME="boring-app"
JOB_NAMES=("${APP_NAME}_CI" "${APP_NAME}_CR" "${APP_NAME}_CD")
JOB_TEMPLATES=("job-templates/ci-template.xml" "job-templates/cr-template.xml" "job-templates/cd-template.xml")

TIME=$(date)
echo ''
echo '==============================='
echo 'Adding jenkins job in Jenkins'
echo "${TIME}"
echo '==============================='
echo ''

echo "Authenticating using '${JENKINS_USER}' credentials."
CRUMB=$(curl -s "${JENKINS_URL}/crumbIssuer/api/json" -u $JENKINS_USER:$JENKINS_TOKEN | jq '.crumb')
CRUMB=${CRUMB/'"'/''} # x2 to remove double quotes
CRUMB=${CRUMB/'"'/''} # x2 to remove double quotes
echo "Jenkins crumb received: ${CRUMB}"

echo ""
echo "Creating jenkins jobs"
echo ""

len=${#JOB_NAMES[@]}
for (( i=0; i < $len; ++i ))
do
    TEMPLATE=$(echo "${JOB_TEMPLATES[$i]}")
    curl -u $JENKINS_USER:$JENKINS_TOKEN \
    --data-binary @$TEMPLATE \
    -H "${CRUMB}" -H "Content-Type:text/xml" \
    -X POST "${JENKINS_URL}/createItem?name=${JOB_NAMES[$i]}"

    echo ""
    echo "${JOB_NAMES[$i]}..........OK"
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