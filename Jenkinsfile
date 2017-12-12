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
        build("api-docs")
      }
    }
    stage("release") {
      when {
        branch "master"
      }
      steps {
        tag("docs-api")
        release("api-docs")
      }
    }
    stage("cd") {
      when {
        branch "master"
      }
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
