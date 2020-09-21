pipeline {
  agent {
    kubernetes {
      label "aicacia_user-api-build-agent"
      defaultContainer "jnlp"
      yamlFile "jenkinsAgent.yaml"
    }
  }
  environment {
    MIX_ENV = "production"
  }
  stages {
    stage('Install Dependencies') {
      steps {
        container("agent") {
          sh "mix local.hex --force"
          sh "mix local.rebar --force"
          sh "MIX_ENV=development mix deps.get"
        }
      }
    }
    stage('Test') {
      steps {
        container("agent") {
          sh "mix test"
        }
      }
    }
    stage('Publish Docker Image') {
      when {
        expression {
          isMaster()
        }
      }
      steps {
        container("agent") {
          sh "mix docker.build"
          sh "mix docker.push"
        }
      }
    }
    stage('Publish Helm Chart') {
      when {
        expression {
          isMaster()
        }
      }
      steps {
        container("agent") {
          withCredentials([usernamePassword(credentialsId: "chartmuseum", usernameVariable: "USERNAME", passwordVariable: "PASSWORD")]) {
            sh "HELM_REPO_USERNAME=\"${USERNAME}\" HELM_REPO_PASSWORD=\"${PASSWORD}\" mix helm.push"
          }
        }
      }
    }
    stage('Deploy') {
      when {
        expression {
          isMaster()
        }
      }
      steps {
        container("agent") {
          sh "mix helm.upgrade"
        }
      }
    }
  }
}

def isRelease() {
  return env.BRANCH_NAME.toLowerCase().startsWith("release")
}
def isMaster() {
  return env.BRANCH_NAME.toLowerCase() == 'master'
}