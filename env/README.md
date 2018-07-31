# ENV

## Build example

```
$ docker build -t linkernetworks/tensorflow --build-arg BASE_IMAGE=tensorflow/tensorflow:1.9.0-py3 .
```

```
$ docker build -t linkernetworks/caffe --build-arg BASE_IMAGE=bvlc/caffe:cpu --build-arg PYTHON=python2 .
```