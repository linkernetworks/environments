
![docker pulls](https://img.shields.io/docker/pulls/linkernetworks/caffe.svg) ![docker stars](https://img.shields.io/docker/stars/linkernetworks/caffe.svg) [![](https://images.microbadger.com/badges/image/linkernetworks/caffe.svg)](https://microbadger.com/images/linkernetworks/caffe "linkernetworks/caffe image metadata")


## Build Docker

### Build

```
docker build -f Dockerfile -t asia.gcr.io/linker-aurora/caffe-notebook .
```

### Run
```
docker run -d -v /workspace:/workspace -p 8888:8888 asia.gcr.io/linker-aurora/caffe-notebook start-notebook.sh --NotebookApp.base_url=/v1 --NotebookApp.token=''
```
