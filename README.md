# jenkins-lib
A simple jenkins shared library. For testing purposes

## Including automation scripts for the following actions:

### 1. Creating Jenkinsfiles
```shell
  ./add-jenkinsfiles.sh
```
### 2. Creating and storing credentials
```shell
  ./add-credentials.sh @type @user @password
```
*Replace `@type` with git*<br>
*Replace `@user` with username*<br>
*Replace `@password` with password*

### 3. Creating and triggering Jenkins jobs
```shell
  ./add-jenkinsjob.sh @user @password
```
*Replace `@user` with username*<br>
*Replace `@password` with password*