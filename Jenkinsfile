import groovy.transform.Field

@Field def buildPython2 = true

def dockerLogin() {
    script {
        withCredentials([
            usernamePassword(
                credentialsId: 'docker_hub_linkernetworks',
                usernameVariable: 'DOCKER_USER',
                passwordVariable: 'DOCKER_PASS'
            )
        ]) {
            sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
        }
    }
}

def pullImage(String tag) {
    script {
        // Use a credentials at https://jenkins.linkernetworks.co/credentials/store/system/domain/_/credential/docker_hub_linkernetworks/
        docker.image(tag).pull()
    }
}

def buildImage(String tag, String dir, dockerfile = 'Dockerfile') {
    script {
        docker.build(tag, "-f ${dir}/${dockerfile} ${dir}").push()
    }
}

def buildImageWithVariant(String tag, String dir, String variant) {
    script {
        docker.build("${tag}-${variant}", "-f ${dir}/Dockerfile.${variant} ${dir}").push()
    }
}

def dirNames (path) {
    return findFiles(
        glob: path + '/**/Dockerfile'
    ).collect { dockerfile ->
        new File(dockerfile.getPath()).getParentFile()
    }.collect { dir ->
        dir.getName()
    }
}


pipeline {
    agent none
    options {
        timestamps()
        // timeout(time: 1, unit: 'HOURS')
        // retry(1)
        // turn on this if this job can start only if there is no other job running
        disableConcurrentBuilds()
    }

    parameters {
        booleanParam(
            name: 'BuildBaseImages',
            defaultValue: false,
            description: 'If true, jenkins will build all base images'
        )
        booleanParam(
            name: 'BuildMinimalImage',
            defaultValue: false,
            description: 'If true, jenkins will build all minimal images'
        )
    }

    environment {
        SUBMIT_TOOL_NAME = 'aurora'
    }
    stages {
        stage('Base Image') {
            failFast false

            parallel {
                stage('Default') {
                    when {
                        beforeAgent true
                        expression { -> params.BuildBaseImages }
                    }
                    agent any
                    steps {
                        script {
                            // Use a credentials at https://jenkins.linkernetworks.co/credentials/store/system/domain/_/credential/docker_hub_linkernetworks/
                            withCredentials([
                                usernamePassword(
                                    credentialsId: 'docker_hub_linkernetworks',
                                    usernameVariable: 'DOCKER_USER',
                                    passwordVariable: 'DOCKER_PASS'
                                )
                            ]) {
                                sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                            }
                            docker.build('linkernetworks/base-notebook:master', 'base/base-notebook').push()
                        }
                    }
                }

                stage('Python 2') {
                    when {
                        beforeAgent true
                        expression { -> params.BuildBaseImages }
                    }
                    agent any
                    steps {
                        tool name: 'Default', type: 'git'
                        dockerLogin()
                        script {
                            docker.build("linkernetworks/base-notebook:master", "-f base/base-notebook/Dockerfile.py2 base/base-notebook").push()
                        }
                    }
                }
            }
        }

        stage('Minimal Notebooks') {

            failFast false

            parallel {

                stage('default') {
                    when {
                        beforeAgent true
                        expression { -> params.BuildBaseImages }
                    }
                    agent any
                    steps {
                        dockerLogin()
                        pullImage "linkernetworks/base-notebook:master"
                        buildImage "linkernetworks/minimal-notebook:master", "base/minimal-notebook"
                    }
                }

                stage('gpu') {
                    when {
                        beforeAgent true
                        expression { -> params.BuildBaseImages }
                    }
                    agent any
                    steps {
                        dockerLogin()
                        pullImage "linkernetworks/base-notebook:master"
                        buildImage "linkernetworks/minimal-notebook:master-gpu", "base/minimal-notebook", "Dockerfile.gpu"
                    }
                }

                stage('cuda80') {
                    when {
                        beforeAgent true
                        expression { -> params.BuildBaseImages }
                    }
                    agent any
                    steps {
                        dockerLogin()
                        pullImage "linkernetworks/base-notebook:master"
                        buildImage "linkernetworks/minimal-notebook:master-cuda80", "base/minimal-notebook", "Dockerfile.cuda80"
                    }
                }

                stage('cuda90') {
                    when {
                        beforeAgent true
                        expression { -> params.BuildBaseImages }
                    }
                    agent any
                    steps {
                        dockerLogin()
                        pullImage "linkernetworks/base-notebook:master"
                        buildImage "linkernetworks/minimal-notebook:master-cuda90", "base/minimal-notebook", "Dockerfile.cuda90"
                    }
                }
            }
        }


        stage('Environments') {

            failFast false

            parallel {
                stage('caffe') {
                    agent any
                    steps {
                        dockerLogin()
                        pullImage "linkernetworks/minimal-notebook:master"
                        pullImage "linkernetworks/minimal-notebook:master-gpu"
                        script {
                            dirNames("env/caffe").each {
                                buildImage "linkernetworks/caffe:${it}", "env/caffe/${it}"
                                buildImageWithVariant "linkernetworks/caffe:${it}", "env/caffe/${it}", "gpu"
                            }
                        }
                    }
                }

                stage('caffe2') {
                    agent any
                    steps {
                        dockerLogin()
                        pullImage "linkernetworks/minimal-notebook:master"
                        pullImage "linkernetworks/minimal-notebook:master-gpu"
                        script {
                            dirNames("env/caffe2").each {
                                buildImage "linkernetworks/caffe2:${it}", "env/caffe2/${it}"
                                buildImageWithVariant "linkernetworks/caffe2:${it}", "env/caffe2/${it}", "gpu"
                            }
                        }
                    }
                }

                stage('tensorflow') {
                    agent any
                    steps {
                        dockerLogin()
                        pullImage "linkernetworks/minimal-notebook:master"
                        pullImage "linkernetworks/minimal-notebook:master-gpu"
                        script {
                            dirNames("env/tensorflow").each {
                                buildImage "linkernetworks/tensorflow:${it}", "env/tensorflow/${it}"
                                buildImageWithVariant "linkernetworks/tensorflow:${it}", "env/tensorflow/${it}", "gpu"
                            }
                        }
                    }
                }

                stage('pytorch') {
                    agent any
                    steps {
                        dockerLogin()
                        pullImage "linkernetworks/minimal-notebook:master"
                        pullImage "linkernetworks/minimal-notebook:master-gpu"
                        script {
                            dirNames("env/pytorch").each {
                                buildImage "linkernetworks/pytorch:${it}", "env/pytorch/${it}"
                                buildImageWithVariant "linkernetworks/pytorch:${it}", "env/pytorch/${it}", "gpu"
                            }
                        }
                    }
                }

                stage('mxnet') {
                    agent any
                    steps {
                        dockerLogin()
                        pullImage "linkernetworks/minimal-notebook:master"
                        pullImage "linkernetworks/minimal-notebook:master-gpu"
                        script {
                            dirNames("env/mxnet").each {
                                buildImage "linkernetworks/mxnet:${it}", "env/mxnet/${it}"
                                buildImageWithVariant "linkernetworks/mxnet:${it}", "env/mxnet/${it}", "gpu"
                            }
                        }
                    }
                }

                stage('datascience') {
                    agent any
                    steps {
                        dockerLogin()
                        pullImage "linkernetworks/minimal-notebook:master"
                        pullImage "linkernetworks/minimal-notebook:master-gpu"
                        script {
                            dirNames("env/datascience").each {
                                buildImage "linkernetworks/datascience:${it}", "env/datascience/${it}"
                                buildImageWithVariant "linkernetworks/datascience:${it}", "env/datascience/${it}", "gpu"
                            }
                        }
                    }
                }

                stage('cntk') {
                    agent any
                    steps {
                        dockerLogin()
                        pullImage "linkernetworks/minimal-notebook:master"
                        pullImage "linkernetworks/minimal-notebook:master-gpu"
                        script {
                            dirNames("env/cntk").each {
                                buildImage "linkernetworks/cntk:${it}", "env/cntk/${it}"
                                buildImageWithVariant "linkernetworks/cntk:${it}", "env/cntk/${it}", "gpu"
                            }
                        }
                    }
                }

                stage('chainer') {
                    agent any
                    steps {
                        dockerLogin()
                        pullImage "linkernetworks/minimal-notebook:master"
                        pullImage "linkernetworks/minimal-notebook:master-gpu"
                        script {
                            dirNames("env/chainer").each {
                                buildImage "linkernetworks/chainer:${it}", "env/chainer/${it}"
                                buildImageWithVariant "linkernetworks/chainer:${it}", "env/chainer/${it}", "gpu"
                            }
                        }
                    }
                }
            }
        }
    }
}
