pipeline {
    agent { label 'marvin-clone' }
    stages {
        stage('test-github-slurm-dev') {
            when {
                expression { env.BRANCH_NAME == 'develop' }
            }
            steps {
                sshagent(['jenkins']) {
                    sh """ 
                           source /etc/bashrc
                           virtualenv venv -p python3.8 
                           source venv/bin/activate
                           pip install -r requirements.txt
                           cp .tests/integration2/config_fastp.yaml config.yaml
                           sed 's/samples\\.tsv/samples_sub\\.tsv/' -i config.yaml
                           module load singularity
                           module load slurm-drmaa
                           snakemake -s workflow/Snakefile --use-singularity --profile .tests/integration2/profiles/slurm  --singularity-args " -B /beegfs-storage "
                       """
                }
            }
        }
        stage('test-github-slurm') {
            when {
                expression { env.BRANCH_NAME != 'develop' }
            }
            steps {
                sshagent(['jenkins']) {
                    sh """ 
                           source /etc/bashrc
                           virtualenv venv -p python3.8 
                           source venv/bin/activate
                           pip install -r requirements.txt
                           cp .tests/integration2/config_fastp.yaml config.yaml
                           sed 's/samples\\.tsv/samples_full\\.tsv/' -i config.yaml
                           module load singularity
                           module load slurm-drmaa
                           snakemake -s workflow/Snakefile --use-singularity --profile .tests/integration2/profiles/slurm  --singularity-args " -B /beegfs-storage "
                       """
                }
            }
        }
    }
    post {
        success {
             deleteDir()
        }
        cleanup {
            dir("${workspace}@tmp") {
                deleteDir()
            }
            dir("${workspace}@script") {
                deleteDir()
            }
        }
    }
}
