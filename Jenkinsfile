pipeline {
    agent { label 'marvin-clone' }
    stages {
        stage('test-github-slurm') {
            steps {
                sshagent(['jenkins']) {
                    sh """ pwd """
                    sh """ ls """
                    sh """sbatch  --wrap 'sleep 40' """
                }
            }
        }
    }
}
