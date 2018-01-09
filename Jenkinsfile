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
        updateVersion("config.ini")
        build("api-docs")
      }
    }
    stage("release") {
      steps {
        release("api-docs")
      }
    }
    stage("cd") {
      steps {
        deploy("api-docs", "api-docs", "api-docs")
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
        tag("docs-api")
        deploy("api-docs", "api-docs", "api-docs")
      }
    }
  }
  post {
    always {
      cleanup("api-docs")
    }
  }
}
