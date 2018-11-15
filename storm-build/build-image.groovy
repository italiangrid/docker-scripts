#!/usr/bin/env groovy

pipeline {
  agent { label 'docker' }

  options {
    timeout(time: 1, unit: 'HOURS')
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }

  triggers { cron('@daily') }

  environment {
    DOCKER_REGISTRY_HOST = "${env.DOCKER_REGISTRY_HOST}"
    REPOSITORY = "https://github.com/italiangrid/docker-scripts"
    BRANCH = "master"
    DIRECTORY = "storm-build"
  }

  stages {
    stage('prepare'){
      steps {
        container('docker-runner'){
          deleteDir()
          git url: "${env.REPOSITORY}", branch: "${env.BRANCH}"
        }
      }
    }

    stage('build'){
      steps {
        container('docker-runner'){
          dir("${env.DIRECTORY}"){
            sh 'sh build-image.sh'
          }
        }
      }
    }

    stage('push'){
      steps {
        container('docker-runner'){
          dir("${env.DIRECTORY}"){
            sh "sh push-image.sh"
          }
        }
      }
    }
  }

  post {
    failure {
      slackSend color: 'danger', message: "${env.JOB_NAME} - #${env.BUILD_NUMBER} Failure (<${env.BUILD_URL}|Open>)"
    }

    changed {
      script{
        if('SUCCESS'.equals(currentBuild.currentResult)) {
          slackSend color: 'good', message: "${env.JOB_NAME} - #${env.BUILD_NUMBER} Back to normal (<${env.BUILD_URL}|Open>)"
        }
      }
    }
  }
}
