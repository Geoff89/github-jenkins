@Library('my-shared-library') _

pipeline {
    agent any

    tools {
        maven '3.9.0'
    }

    parameters{
        choice(name: 'action', choices: 'create\ndelete', description: 'Choice create/Destroy')
        string(name: 'aws_account_id', description: "AWS Account ID", defaultValue:'622339756908')
        string(name: 'Region', description: "Region of ECR", defaultValue:'us-east-1')
        string(name: 'ECR_REPO_NAME', description: "name of ECR", defaultValue:'sagini')
    }
    environment{
        ACCESS_KEY = credentials('AWS_ACCESS_KEY_ID')
        SECRET_KEY = credentials('AWS_SECRET_ACCESS_KEY')
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
        stage('Jenkins user listing aws resources') {
            steps {
                sh 'aws --version'
            }
        }
        stage('Jenkins user listing aws resources') {
            steps {
                sh '''
                aws s3 ls
            '''
              
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
        // stage('Static code analysis: Sonarqube') {
        //     when {expression { params.action == 'create'}}
        //     steps{
        //         script {
                    
        //             def SonarQubecredentialsId = 'sonar-token'
        //             staticCodeAnalysis(SonarQubecredentialsId)
        //         }
        //     }
        // }
        // stage('Quality Gate Status Check: Sonarqube') {
        //     when {expression { params.action == 'create'}}
        //     steps{
        //         script {
                    
        //             def SonarQubecredentialsId = 'sonar-token'
        //             QualityGateStatus(SonarQubecredentialsId)
        //         }
        //     }
        // }
        stage('Maven Build: maven') {
            when {expression { params.action == 'create'}}
            steps {
                script{
                    mvnBuild()
                }
            }
        }
        stage('Docker Image Build: ECR') {
            when {expression { params.action == 'create'}}
            steps {
                script{
                    dockerBuild("${params.aws_account_id}","${params.Region}","${params.ECR_REPO_NAME}")
                }
            }
        }
         stage('Docker Image Scan: trivy') {
            when {expression { params.action == 'create'}}
            steps {
                script{
                    dockerImageScan("${params.aws_account_id}","${params.Region}","${params.ECR_REPO_NAME}")
                }
            }
        }
         stage('Docker Image Push: ECR') {
            when {expression { params.action == 'create'}}
            steps {
                script{
                    dockerImagePush("${params.aws_account_id}","${params.Region}","${params.ECR_REPO_NAME}")
                }
            }
        }
    }
}