pipeline {
    agent any
    
    triggers {
        // Poll SCM every minute for changes
        pollSCM('* * * * *')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Prepare') {
            steps {
                sh 'chmod +x deploy.sh'
                
                // Ensure Docker and Docker Compose are installed
                sh '''
                if ! command -v docker &> /dev/null; then
                    echo "Docker not found, installing..."
                    sudo apt-get update
                    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
                    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
                    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
                    sudo apt-get update
                    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
                fi
                
                if ! command -v docker-compose &> /dev/null; then
                    echo "Docker Compose not found, installing..."
                    sudo curl -L "https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                    sudo chmod +x /usr/local/bin/docker-compose
                fi
                '''
                
                // Ensure Jenkins user can run Docker
                sh '''
                if ! groups jenkins | grep -q docker; then
                    echo "Adding jenkins user to docker group..."
                    sudo usermod -aG docker jenkins
                    echo "You may need to restart Jenkins for this to take effect."
                fi
                '''
            }
        }
        
        stage('Deploy') {
            steps {
                sh './deploy.sh'
            }
        }
        
        stage('Verify') {
            steps {
                // Wait a moment for Nginx to start
                sh 'sleep 3'
                
                // Verify the service is responding
                sh 'curl -s http://localhost:8088 | grep "Nginx Deployed with Jenkins"'
            }
        }
    }
    
    post {
        success {
            echo 'Nginx Docker deployment successful!'
        }
        failure {
            echo 'Nginx Docker deployment failed!'
        }
    }
}
