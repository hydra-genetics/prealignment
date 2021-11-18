pipeline {
    agent { label 'marvin-clone' }
    stages {
        stage('test-github-slurm') {
            steps {
                sshagent(['jenkins']) {
                    sh """ virtualenv venv -p python3.8 
                           source venv/bin/activate
                           pip install -r requirements.txt
                           cp .test/integration2/profiles/config_fastp.yaml config.yaml
                           snakemake -s workflow/Snakefile --profile .test/integration2/profiles/slurm
                       """
                }
            }
        }
    }
}
