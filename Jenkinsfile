pipeline {
    agent any
    stages {
        stage('submodule update') {
            steps {
                sh 'git submodule update --init'
            }
        }
        stage('sageteamail:arm64') {
            docker { image 'clickable/ci-16.04-arm64:6.24.0' }
            steps {
                sh 'clickable build'
                archiveArtifacts(artifacts: 'build/$ARCH_TRIPLET/*.click', fingerprint: true, onlyIfSuccessful: true)
            }
        }
    }
}