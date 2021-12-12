pipeline{
    agent any 
    stages{
        stage("sonar quality check"){
            agent {
                docker {
                    image 'openjdk:11'
                }
            }
            steps{
                script{
                    withSonarQubeEnv() {
                            sh 'chmod +x gradlew'
                            sh './gradlew sonarqube'
                    }

                }
                timeout(time: 1, unit: 'HOURS') {
                      def qg = waitForQualityGate()
                      if (qg.status != 'OK') {
                           error "Pipeline aborted due to quality gate failure: ${qg.status}"
                      }
                }  
            }
        }

    }
    post{
        always{
            echo "SUCCESS"
        }
    }
}