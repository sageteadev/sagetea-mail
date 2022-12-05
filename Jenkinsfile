pipeline {
    agent any
    stages {
        stage('sageteamail:arm64') {
            agent {
                docker {
                    image 'clickable/ci-16.04-arm64:6.24.0'
                    // Run the container on the node specified at the
                    // top-level of the Pipeline, in the same workspace,
                    // rather than on a new node entirely:
                    reuseNode true
                }
            }
            steps {
                sh 'git submodule update --init'
                sh 'clickable build'
                archiveArtifacts(artifacts: 'build/$ARCH_TRIPLET/*.click', fingerprint: true, onlyIfSuccessful: true)
            }
        }
    }
}