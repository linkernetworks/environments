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

def buildImage(String tag, String dir, String dockerfile = 'Dockerfile') {
    script {
        docker.build(tag, "-f ${dir}/${dockerfile} ${dir}").push()
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
                        script {
                            ['1.0'].each {
                                buildImage "linkernetworks/caffe:${it}", "env/caffe/${it}"
                            }
                        }
                    }
                }

                stage('caffe2') {
                    agent any
                    steps {
                        dockerLogin()
                        script {
                            ['0.8'].each {
                                buildImage "linkernetworks/caffe2:${it}", "env/caffe2/${it}"
                            }
                        }
                    }
                }

                stage('tensorflow') {
                    agent any
                    steps {
                        dockerLogin()
                        script {
                            ['1.8', '1.7', '1.6', '1.5.1', '1.4', '1.3'].each {
                                buildImage "linkernetworks/tensorflow:${it}", "env/tensorflow/${it}"
                            }
                        }
                    }
                }

                stage('pytorch') {
                    agent any
                    steps {
                        dockerLogin()
                        script {
                            ['0.3.1', '0.4.0'].each {
                                buildImage "linkernetworks/pytorch:${it}", "env/pytorch/${it}"
                            }
                        }
                    }
                }

                stage('mxnet') {
                    agent any
                    steps {
                        dockerLogin()
                        script {
                            ['1.1'].each {
                                buildImage "linkernetworks/mxnet:${it}", "env/mxnet/${it}"
                            }
                        }
                    }
                }

                stage('datascience') {
                    agent any
                    steps {
                        dockerLogin()
                        script {
                            ['1.0'].each {
                                buildImage "linkernetworks/datascience:${it}", "env/datascience/${it}"
                            }
                        }
                    }
                }

                stage('cntk') {
                    agent any
                    steps {
                        dockerLogin()
                        script {
                            ['2.5'].each {
                                buildImage "linkernetworks/cntk:${it}", "env/cntk/${it}"
                            }
                        }
                    }
                }
            }
        }
    }
}
