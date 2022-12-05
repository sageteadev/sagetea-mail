pipeline {
    agent any
    stages {
        stage('sageteamail:arm64') {
        agent { dockerfile true }
            steps {
                sh 'git submodule update --init'
                sh 'clickable build'
                archiveArtifacts(artifacts: 'build/$ARCH_TRIPLET/*.click', fingerprint: true, onlyIfSuccessful: true)
            }
        }
    }
}