node {
    def commit
    try {
        stage 'checkout'
        checkout scm

        //assign git commit sha1 as build description
        sh 'git rev-parse --short HEAD > commit'
        commit = readFile('commit').trim()
        currentBuild.description = commit

        stage 'build'
        sh "./gradlew -Dorg.gradle.daemon=true -Dorg.gradle.parallel=false -PrepositoryBranchName=${env.BRANCH_NAME} --stacktrace --debug clean build pushDocker"

    } finally {
        echo 'Build finished'
    }
}
