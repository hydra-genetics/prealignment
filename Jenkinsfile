pipeline {
    agent { label 'marvin-clone' }
    stages {
        stage('test-github-slurm') {
            steps {
                sshagent(['jenkins']) {
                    sh """ virtualenv venv -p python3.8 
                           source venv/bin/activate
                           pip install -r requirements.txt
                           cp .tests/integration2/config_fastp.yaml config.yaml
                           module load singularity
                           module load slurm-drmaa
                           snakemake -s workflow/Snakefile --profile .tests/integration2/profiles/slurm
                       """
                }
            }
        }
    }
}
