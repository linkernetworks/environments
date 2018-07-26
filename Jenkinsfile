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

def shouldDeploy () {
    return env.BRANCH_NAME == 'master'
}

def getBranchTag () {
    return env.BRANCH_NAME.replaceAll("[^A-Za-z0-9.]", "-").toLowerCase()
}

def slack(color, message) {
    echo "${message}"
    slackSend channel: '#09_jenkins',
        color: color,
        message:
            "<${JOB_DISPLAY_URL}|environments> » " +
            "<${env.JOB_URL}|${env.BRANCH_NAME}> » " +
            "<${env.RUN_DISPLAY_URL}|${env.BUILD_DISPLAY_NAME}> ${message}"

    if (!shouldDeploy() || color != 'danger') {
        return
    }

    slackSend channel: '#01_aurora',
        color: color,
        message:
            "<${JOB_DISPLAY_URL}|environments> » " +
            "<${env.JOB_URL}|${env.BRANCH_NAME}> » " +
            "<${env.RUN_DISPLAY_URL}|${env.BUILD_DISPLAY_NAME}> ${message} <!here>"
}

class ImageConfig {
    String  tag        = ""
    String  folder     = ""
    String  dockerfile = "Dockerfile"
    String  baseImage  = ""
    String  cpu        = "500m"
    boolean push       = false
}

def getStages(configs) {
    return configs.collectEntries { config ->
        [(config.tag): {
            retry (3) {
                timeout(90) {
                    def label = "environments-pod-${UUID.randomUUID().toString()}"
                    podTemplate(label: label, nodeUsageMode: 'EXCLUSIVE', yaml: """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: docker
    image: docker:dind
    imagePullPolicy: Always
    securityContext:
      privileged: true
    tty: true
    command: [ "sh", "-c", "apk add bash && dockerd-entrypoint.sh" ]
    resources:
      requests:
        cpu: ${config.cpu}
"""
                    ) {
                        node (label) {
                            checkout scm
                            container ('docker') {
                                // wait util docker service ready
                                waitUntil {
                                    0 == sh(script:"docker run --rm hello-world", returnStatus:true)
                                }
                            }
                            container ('docker') {
                                if (config.baseImage != "") {
                                    docker.image(config.baseImage).pull()
                                }
                                def image = docker.build(
                                    config.tag,
                                    "--file ${config.folder}/${config.dockerfile} " +
                                    (config.baseImage == "" ? "" : "--build-arg BASE_IMAGE=${config.baseImage} ") +
                                    "${config.folder} "
                                )
                                if (config.push) {
                                    dockerLogin()
                                    image.push()
                                }
                            }
                        }
                    }
                }
            }
        }]
    }
}


pipeline {
    agent none
    options {
        timestamps()
        disableConcurrentBuilds()
    }
    parameters {
        booleanParam(
            name: 'BuildBaseImages',
            defaultValue: false,
            description: 'If true, jenkins will build all base images. ' +
                'If current branch is master, jenkins discare this parameter and always build base images.'
        )
    }
    stages {
        stage('base') {
            when {
                expression { -> params.BuildBaseImages || shouldDeploy() }
            }
            steps {
                script {
                    parallel getStages([
                        new ImageConfig(
                            tag: "linkernetworks/base-notebook:${branchTag}",
                            folder: "base/base-notebook",
                            push: true,
                        ), new ImageConfig(
                            tag: "linkernetworks/base-notebook:${branchTag}-py2",
                            folder: "base/base-notebook",
                            dockerfile: "Dockerfile.py2",
                            push: true,
                        ),
                    ])
                }
            }
        }

        stage('minimal CPU') {
            when {
                expression { -> params.BuildBaseImages || shouldDeploy() }
            }
            steps {
                script {
                    parallel getStages([
                        new ImageConfig(
                            tag: "linkernetworks/minimal-notebook:${branchTag}",
                            folder: "base/minimal-notebook",
                            baseImage: "linkernetworks/base-notebook:${branchTag}",
                            push: true,
                        ),
                    ])
                }
            }
        }

        stage('minimal GPU') {
            when {
                expression { -> params.BuildBaseImages || shouldDeploy() }
            }
            steps {
                script {
                    parallel getStages([
                        new ImageConfig(
                            tag: "linkernetworks/minimal-notebook:${branchTag}-gpu",
                            folder: "base/minimal-notebook",
                            dockerfile: "Dockerfile.gpu",
                            baseImage: "linkernetworks/minimal-notebook:${branchTag}",
                            push: true,
                        ), new ImageConfig(
                            tag: "linkernetworks/minimal-notebook:${branchTag}-cuda80",
                            folder: "base/minimal-notebook",
                            dockerfile: "Dockerfile.cuda80",
                            baseImage: "linkernetworks/minimal-notebook:${branchTag}",
                            push: true,
                        ), new ImageConfig(
                            tag: "linkernetworks/minimal-notebook:${branchTag}-cuda90",
                            folder: "base/minimal-notebook",
                            dockerfile: "Dockerfile.cuda90",
                            baseImage: "linkernetworks/minimal-notebook:${branchTag}",
                            push: true,
                        ),
                    ])
                }
            }
        }

        stage('environments') {
            steps {
                script {
                    parallel getStages([
                        new ImageConfig(
                            tag: "linkernetworks/caffe:1.0",
                            folder: "env/caffe/1.0",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/caffe:1.0-gpu",
                            folder: "env/caffe/1.0",
                            dockerfile: "Dockerfile.gpu",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/caffe2:0.8",
                            folder: "env/caffe2/0.8",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}",
                            push: shouldDeploy(),
                            cpu: "3500m",
                        ), new ImageConfig(
                            tag: "linkernetworks/caffe2:0.8-gpu",
                            folder: "env/caffe2/0.8",
                            dockerfile: "Dockerfile.gpu",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}-cuda90",
                            push: shouldDeploy(),
                            cpu: "3500m",
                        ), new ImageConfig(
                            tag: "linkernetworks/tensorflow:1.3",
                            folder: "env/tensorflow/1.3",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/tensorflow:1.3-gpu",
                            folder: "env/tensorflow/1.3",
                            dockerfile: "Dockerfile.gpu",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}-gpu",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/tensorflow:1.4",
                            folder: "env/tensorflow/1.4",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/tensorflow:1.4-gpu",
                            folder: "env/tensorflow/1.4",
                            dockerfile: "Dockerfile.gpu",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}-gpu",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/tensorflow:1.5.1",
                            folder: "env/tensorflow/1.5.1",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/tensorflow:1.5.1-gpu",
                            folder: "env/tensorflow/1.5.1",
                            dockerfile: "Dockerfile.gpu",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}-cuda90",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/tensorflow:1.6",
                            folder: "env/tensorflow/1.6",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/tensorflow:1.6-gpu",
                            folder: "env/tensorflow/1.6",
                            dockerfile: "Dockerfile.gpu",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}-cuda90",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/tensorflow:1.7",
                            folder: "env/tensorflow/1.7",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/tensorflow:1.7-gpu",
                            folder: "env/tensorflow/1.7",
                            dockerfile: "Dockerfile.gpu",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}-cuda90",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/tensorflow:1.8",
                            folder: "env/tensorflow/1.8",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/tensorflow:1.8-gpu",
                            folder: "env/tensorflow/1.8",
                            dockerfile: "Dockerfile.gpu",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}-cuda90",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/tensorflow:1.9",
                            folder: "env/tensorflow/1.9",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/tensorflow:1.9-gpu",
                            folder: "env/tensorflow/1.9",
                            dockerfile: "Dockerfile.gpu",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}-cuda90",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/pytorch:0.3.1",
                            folder: "env/pytorch/0.3.1",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/pytorch:0.3.1-gpu",
                            folder: "env/pytorch/0.3.1",
                            dockerfile: "Dockerfile.gpu",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}-cuda90",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/pytorch:0.4.0",
                            folder: "env/pytorch/0.4.0",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/pytorch:0.4.0-gpu",
                            folder: "env/pytorch/0.4.0",
                            dockerfile: "Dockerfile.gpu",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}-cuda90",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/mxnet:1.1",
                            folder: "env/mxnet/1.1",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/mxnet:1.1-gpu",
                            folder: "env/mxnet/1.1",
                            dockerfile: "Dockerfile.gpu",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}-gpu",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/datascience:1.0",
                            folder: "env/datascience/1.0",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/datascience:1.0-gpu",
                            folder: "env/datascience/1.0",
                            dockerfile: "Dockerfile.gpu",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}-gpu",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/cntk:2.5",
                            folder: "env/cntk/2.5",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/cntk:2.5-gpu",
                            folder: "env/cntk/2.5",
                            dockerfile: "Dockerfile.gpu",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}-cuda90",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/chainer:3.5",
                            folder: "env/chainer/3.5",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}",
                            push: shouldDeploy(),
                        ), new ImageConfig(
                            tag: "linkernetworks/chainer:3.5-gpu",
                            folder: "env/chainer/3.5",
                            dockerfile: "Dockerfile.gpu",
                            baseImage: "linkernetworks/minimal-notebook:${params.BuildBaseImages ? branchTag : 'master'}-gpu",
                            push: shouldDeploy(),
                        ),
                    ])
                }
            }
        }
    }
    post{
        success {
            slack('good', "Successed")
        }
        failure {
            slack('danger', "Failed")
        }
        aborted {
            slack('warning', "Aborted")
        }
    }
}
