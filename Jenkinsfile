pipeline {
    agent any

    stages {
        stage("Git Checkout") {
            steps{
                script{
                   checkout scmGit(branches: [[name: 'main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Geoff89/github-jenkins.git']]) 
                   echo "Checked out the stage"
                }
            }
        }
    }
}