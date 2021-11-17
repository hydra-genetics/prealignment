pipeline {
    agent any
    stages {
        stage('test-slurm') {
            steps {
                sshagent(['stanley']) {
                    sh """ pwd """
                    sh """ ls """
                    sh """ssh -tt stanley@marvin.cgu.igp.uu.se 'sbatch  --wrap "sleep 30 "' """
                }
            }
        }
    }
}
