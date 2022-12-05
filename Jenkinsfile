pipeline {
    agent {
        docker { image 'clickable/ci-16.04-arm64:6.24.0' }.inside
    }
    stages {
        stage('sageteamail:arm64') {
            steps {
                sh 'git submodule update --init'
                sh 'clickable build'
                archiveArtifacts(artifacts: 'build/$ARCH_TRIPLET/*.click', fingerprint: true, onlyIfSuccessful: true)
            }
        }
    }
}