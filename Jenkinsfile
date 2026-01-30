pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = "chandan669/insurance"
        DOCKER_IMAGE = "${DOCKER_REGISTRY}:1.0"
        DOCKER_CREDENTIALS_ID = "dockercreds"
        GIT_REPO = "https://github.com/Chandanb2003/Insurance.git"
        GOOGLE_APPLICATION_CREDENTIALS = "${WORKSPACE}/terraform-key.json"
        TERRAFORM_DIR = "${WORKSPACE}/terraform_files"
        CLUSTER_NAME = "capstone-projects-insurance"
        CLUSTER_ZONE = "asia-south1-a"
        PROJECT_ID = "model-deployments"
    }

    stages {

        stage('Prepare AWS') {
            steps {
                sh '''
                echo "🔐 Using AWS instance profile credentials..."
                aws sts get-caller-identity
                '''
            }
        }


        stage('Git Checkout') {
            steps {
                echo "✅ Already checked out by Jenkins (Declarative: Checkout SCM). Skipping extra checkout."
            }
        }

        stage('Terraform (EKS) - Next Step') {
            steps {
                echo "⏭ Skipping GKE/GCloud steps. Next we will wire Terraform to provision EKS in us-east-2."
            }
        }

        stage('Wait for Cluster (EKS placeholder)') {
            steps {
                echo "⏭ Skipping GKE wait. EKS readiness check will be added later."
            }
        }


        stage('Build Package') {
            steps {
                sh 'mvn package'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    echo '🐳 Building and pushing Docker image...'
                    sh "docker build -t ${env.DOCKER_IMAGE} ."
                    withCredentials([usernamePassword(credentialsId: env.DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}"
                    }
                    sh "docker push ${env.DOCKER_IMAGE}"
                }
            }
        }

        stage('Configure kubectl') {
            steps {
                script {
                    echo '⚙️ Configuring kubectl...'
                    sh '''
                    gcloud auth activate-service-account --key-file=${WORKSPACE}/terraform-key.json
                    gcloud container clusters get-credentials ${CLUSTER_NAME} \
                        --zone ${CLUSTER_ZONE} \
                        --project ${PROJECT_ID} \
                    '''
                }
            }
        }

        stage('Run Ansible Playbook for Version Checks') {
            steps {
                script {
                    echo "🛠 Running Ansible playbook to check installed versions..."

                    // Assuming ansible and python are installed on the Jenkins agent
                    sh '''
                    ansible-playbook ${WORKSPACE}/ansible-playbook.yml --connection=local -i localhost,
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo '🚢 Deploying manifests...'
                sh '''
                kubectl apply -f deploy.yml --validate=false
                kubectl apply -f service.yaml --validate=false
                '''
            }
        }
    }

    post {
        always {
            echo '🧹 Cleaning workspace...'
            cleanWs()
        }
    }
}
