pipeline {
  agent any

  environment {
    IMAGE = "itisscomp12/nginx-web"
    TAG   = "${BUILD_NUMBER}"
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/itisscomp12-eng/k8s.git'
      }
    }

    stage('Build Image') {
      steps {
        sh 'docker build -t $IMAGE:$TAG -t $IMAGE:latest .'
      }
    }

    stage('Push Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                         usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
          sh '''
            echo $DH_PASS | docker login -u $DH_USER --password-stdin
            docker push $IMAGE:$TAG
            docker push $IMAGE:latest
          '''
        }
      }
    }

    stage('Deploy to K8s') {
      steps {
        withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
          sh '''
            kubectl apply -f k8s/
            kubectl set image deployment/nginx-web nginx=$IMAGE:$TAG
            kubectl rollout status deployment/nginx-web
          '''
        }
      }
    }
  }
}
