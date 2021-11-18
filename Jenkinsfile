pipeline {
    agent any
    stages {
        stage('test-github-slurm') {
            steps {
                sshagent(['jenkins']) {
                    sh """ pwd """
                    sh """ ls """
                    sh """ssh -tt jenkins@marvin-clone.cgu.igp.uu.se 'sbatch  --wrap "sleep 40 "' """
                }
            }
        }
    }
}
