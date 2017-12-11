import java.text.SimpleDateFormat

pipeline {
  agent {
    label "cd"
  }
  options {
    buildDiscarder(logRotator(numToKeepStr: '2'))
    disableConcurrentBuilds()
  }
  stages {
    stage("build") {
      steps {
        script {
          def dateFormat = new SimpleDateFormat("yy.MM.dd")
          currentBuild.displayName = dateFormat.format(new Date()) + "-" + env.BUILD_NUMBER
        }
        sh "docker image build -t reach/api-docs:latest -f Dockerfile ."
        sh "docker image tag reach/api-docs:latest reach/api-docs:${currentBuild.displayName}"
      }
    }
    stage("release") {
      when {
        branch "master"
      }
      steps {
        withCredentials([usernamePassword(
            credentialsId: "docker",
            usernameVariable: "USER",
            passwordVariable: "PASS"
        )]) {
            sh "docker login -u $USER -p $PASS"
        }
        sh "docker image push reach/api-docs:latest"
        sh "docker image push reach/api-docs:${currentBuild.displayName}"
        sh "docker logout"
      }
    }
    stage("cd") {
      when {
        branch "master"
      }
      steps {
        script {
          try {
            sh "docker service update --image reach/api-docs:${currentBuild.displayName} api-docs_api-docs --detach=false"
          } catch (e) {
            sh "docker service update --rollback api-docs_api-docs  --detach=false"
            error "Failed to update the service"
          }
        }
      }
    }
    stage("production") {
      when {
        branch "master"
      }
      agent {
        label "prod"
      }
      steps {
        script {
          try {
            sh "docker service update --image reach/api-docs:${currentBuild.displayName} api-docs_api-docs --detach=false"
            slackSend(
              color: "good",
              message: "api-docs version ${currentBuild.displayName} deployed successfully."
            )
          } catch (e) {
            sh "docker service update --rollback api-docs_api-docs  --detach=false"
            error "Failed to update the service"
          }
        }
      }
    }
  }
  post {
      failure {
        slackSend(
                color: "danger",
                message: """api-docs version ${currentBuild.displayName} could not be updated.
Please check Jenkins logs for the job ${env.JOB_NAME} #${env.BUILD_NUMBER}
${env.RUN_DISPLAY_URL}"""
        )
    }
  }
}
