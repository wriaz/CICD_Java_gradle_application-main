pipeline{
    agent any 
    environment(
        VERSION="${env.BUILD_ID}"
    )
    stages{
        stage("sonar quality check"){
            agent {
                docker {
                    image 'openjdk:11'
                }
            }
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonartoken') {
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

    stage("Docker build & Docker Push"){
        steps[
            script(
                withCredentials([string(credentialsId: 'docker_pass', variable: 'docker_password')]) {
                sh '''
                docker build -t localhost:8081/springapp:${VERSION} .
                docker login  -u admin -p ${docker_password} localhost:8083
                docker push localhost:8083/springapp:${VERSION}
                docker rmi localhost:8083/springapp:${VERSION}
                '''

                }
            )
        ]
    }


    }
    post{
        always{
            echo "SUCCESS"
        }
    }
}