pipeline {
    agent any

    stages {
        

        stage('Checkout') {
            steps {
                deleteDir()
                sh 'echo cloning repo'
                sh 'git clone https://github.com/devil9121/terrafomr-ansible-jenkins.git' 
            }
        }
        
        stage('Terraform Apply') {
            steps {
                script {
                    dir('/var/lib/jenkins/workspace/challenge/terrafomr-ansible-jenkins') {
                    sh 'pwd'
                    sh 'terraform init'
                    sh 'terraform validate'
                    // sh 'terraform destroy -auto-approve'
                    sh 'terraform plan'
                    sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
        
        stage('Ansible Deployment') {
            steps {
                script {
                   sleep '360'
                    ansiblePlaybook becomeUser: 'ec2-user', credentialsId: 'amazonlinux', disableHostKeyChecking: true, installation: 'ansible', inventory: '/var/lib/jenkins/workspace/challenge/terrafomr-ansible-jenkins/inventory.yaml', playbook: '/var/lib/jenkins/workspace/challenge/terrafomr-ansible-jenkins/amazon-playbook.yml', vaultTmpPath: ''
                    ansiblePlaybook become: true, credentialsId: 'ubuntuuser', disableHostKeyChecking: true, installation: 'ansible', inventory: '/var/lib/jenkins/workspace/challenge/terrafomr-ansible-jenkins/inventory.yaml', playbook: '/var/lib/jenkins/workspace/challenge/terrafomr-ansible-jenkins/ubuntu-playbook.yml', vaultTmpPath: ''
                }
            }
        }
    }
}
