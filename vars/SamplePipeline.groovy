def call(body) {
    body.resolveStrategy = Closure.DELEGATE_FIRST
    body()

    pipeline {
        agent any

        stages {

            stage('Stage A') {
                steps {
                    echo 'Stage A...'
                }
            }

            stage('Stage B') {
                steps {
                    echo 'Stage B...'
                }
            }

            stage('Stage C') {
                steps {
                    echo 'Stage C...'
                }
            }
        }
    }

}
