pipeline {
  agent any

  tools {
    terraform 'tf 1.12'
  }

  environment {
    TF_IN_AUTOMATION = 'true'
    AWS_REGION = 'us-east-1'
  }

  stages {

    stage('Checkout') {
      steps {
        git credentialsId: 'github54-token', url: 'https://github.com/your-org/terraform-modules.git'
      }
    }

    stage('Terraform Init') {
      steps {
        sh '''
          terraform init \
            -backend-config="bucket=your-bucket" \
            -backend-config="key=dev/network/terraform.tfstate" \
            -backend-config="region=us-east-1" \
            -backend-config="dynamodb_table=your-lock-table"
        '''
      }
    }

    stage('Format & Validate') {
      steps {
        sh 'terraform fmt -check -recursive'
        sh 'terraform validate'
      }
    }

    stage('Security Scan') {
      steps {
        sh 'tflint --init && tflint'
        sh 'checkov -d .'
      }
    }

    stage('Terraform Plan') {
      steps {
        sh 'terraform plan -out=tfplan.binary'
        archiveArtifacts artifacts: 'tfplan.binary', allowEmptyArchive: false
      }
    }

    stage('Approval') {
      when {
        branch 'main'
      }
      steps {
        input message: '🛑 Please approve the Terraform APPLY to PRODUCTION'
      }
    }

    stage('Terraform Apply') {
      steps {
        sh 'terraform apply tfplan.binary'
      }
    }
  }

  post {
    success {
      echo '✅ Terraform deployment successful!'
    }
    failure {
      echo '❌ Deployment failed. Check logs.'
    }
  }
}
