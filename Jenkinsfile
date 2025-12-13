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
        stage('Confirming aws cli version') {
            steps {
                sh 'aws --version'
            }
        }
        stage('Jenkins user listing aws resources') {
            steps {
                sh """
                    aws configure set aws_access_key_id ${ACCESS_KEY}
                    aws configure set aws_secret_access_key ${SECRET_KEY}
                    aws configure set default.region ${params.Region}
                    aws s3 ls
            """   
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
        stage('Static code analysis: Sonarqube') {
            when {expression { params.action == 'create'}}
            steps{
                script {
                    
                    def SonarQubecredentialsId = 'sonar-token'
                    staticCodeAnalysis(SonarQubecredentialsId)
                }
            }
        }
        stage('Quality Gate Status Check: Sonarqube') {
            when {expression { params.action == 'create'}}
            steps{
                script {
                    
                    def SonarQubecredentialsId = 'sonar-token'
                    QualityGateStatus(SonarQubecredentialsId)
                }
            }
        }
        stage('Maven Build: maven') {
            when {expression { params.action == 'create'}}
            steps {
                script{
                    mvnBuild()
                }
            }
        }
//         stage('Docker Image Build: ECR') {
//             when {expression { params.action == 'create'}}
//             steps {
//                 script{
//                     dockerBuild("${params.aws_account_id}","${params.Region}","${params.ECR_REPO_NAME}")
//                 }
//             }
//         }
//         stage('Docker Image Scan: trivy') {
//             when {expression { params.action == 'create'}}
//             steps {
//                 script{
//                     dockerImageScan("${params.aws_account_id}","${params.Region}","${params.ECR_REPO_NAME}")
//                 }
//             }
//         }
//          stage('Docker Image Push: ECR') {
//             when {expression { params.action == 'create'}}
//             steps {
//                 script{
//                     dockerImagePush("${params.aws_account_id}","${params.Region}","${params.ECR_REPO_NAME}")
//                 }
//             }
//         }
//         stage('Docker Image Cleanup : ECR '){
//          when { expression {  params.action == 'create' } }
//             steps{
//                script{   
//                    dockerImageCleanup("${params.aws_account_id}","${params.Region}","${params.ECR_REPO_NAME}")
//                }
//             }
//         } 
//         stage('Docker Image Cleanup : ECR '){
//          when { expression {  params.action == 'create' } }
//             steps{
//                script{  
//                    dockerImageCleanup("${params.aws_account_id}","${params.Region}","${params.ECR_REPO_NAME}")
//                }
//             }
//         } 
         
//         stage('Create EKS Cluster : Terraform'){
//             when { expression {  params.action == 'create' } }
//             steps{
//                 script{
//                     dir('eks_module') {
//                       sh """  
//                           terraform init 
//                           terraform plan -var 'access_key=$ACCESS_KEY' -var 'secret_key=$SECRET_KEY' -var 'region=${params.Region}' --var-file=./config/terraform.tfvars
//                           terraform apply -var 'access_key=$ACCESS_KEY' -var 'secret_key=$SECRET_KEY' -var 'region=${params.Region}' --var-file=./config/terraform.tfvars --auto-approve
//                       """
//                   }
//                 }
//             }
//         }
//         stage('Connect to EKS '){
//             when { expression {  params.action == 'create' } }
//             steps{
//                 script{
//                     sh """
//                     aws configure set aws_access_key_id "$ACCESS_KEY"
//                     aws configure set aws_secret_access_key "$SECRET_KEY"
//                     aws configure set region "${params.Region}"
//                     aws eks --region ${params.Region} update-kubeconfig --name ${params.cluster}
//                     """
//                 }
//             }
//         } 
//         stage('Deployment on EKS Cluster'){
//             when { expression {  params.action == 'create' } }
//             steps{
//                 script{
                  
//                   def apply = false

//                   try{
//                     input message: 'please confirm to deploy on eks', ok: 'Ready to apply the config ?'
//                     apply = true
//                   }catch(err){
//                     apply= false
//                     currentBuild.result  = 'UNSTABLE'
//                   }
//                   if(apply){

//                     sh """
//                       kubectl apply -f .
//                     """
//                   }
//                 }
//             }
//         } 
//         stage('Destroy EKS Cluster : Terraform') {
//             when { expression { params.action == 'delete' } }
//             steps {
//                 script {

//                     def proceed = false

//                     try {
//                         input message: '⚠️ WARNING: This will permanently destroy the EKS cluster and all Terraform-managed resources. Continue?', ok: 'Yes, destroy everything'
//                         proceed = true
//                     } catch (err) {
//                         proceed = false
//                         currentBuild.result = 'UNSTABLE'
//                         echo "Destroy cancelled by user."
//                     }

//             if (proceed) {
//                 dir('eks_module') {
//                     sh """
//                         echo "Initializing Terraform..."
//                         terraform init

//                         echo "Planning Terraform destroy..."
//                         terraform plan -destroy \
//                             -var 'access_key=$ACCESS_KEY' \
//                             -var 'secret_key=$SECRET_KEY' \
//                             -var 'region=${params.Region}' \
//                             --var-file=./config/terraform.tfvars

//                         echo "Destroying Terraform resources..."
//                         terraform destroy \
//                             -var 'access_key=$ACCESS_KEY' \
//                             -var 'secret_key=$SECRET_KEY' \
//                             -var 'region=${params.Region}' \
//                             --var-file=./config/terraform.tfvars \
//                             --auto-approve
//                     """
//                 }
//             }
//         }
//     }
// }

    
 

    }
}