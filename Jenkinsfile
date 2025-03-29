@Library('my-shared-library') _

pipeline {
    agent any

    tools {
        maven '3.9.0'
    }

    parameters{
        choice(name: 'action', choices: 'create\ndelete', description: 'Choice create/Destroy')
    }

    stages {
        stage('Git Checkout') {
            when { expression { params.action == 'create'}}
            steps{
                gitCheckout(
                    branch: "main",
                    url: "https://github.com/Geoff89/github-jenkins.git"
                )
            }
        }
        stage("Mvn Verification"){
            steps{
                sh 'mvn --version'
            }
           
        }
        stage('Unit Test maven') {
            when {expression { params.action == 'create'}}
            steps{
                script{
                    mvnTest()
                }
            }
        }
        stage('Integration Test maven') {
            when {expression { params.action == 'create'}}
            steps{
                script {
                    mvnIntergrationTest()
                }
            }
        }
    }
}