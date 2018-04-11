# tensorflow-alexnet-trainer

## Build Docker

### Build

```
docker build -f Dockerfile -t asia.gcr.io/linker-aurora/caffe-notebook .
```

### Run
```
docker run -d -v /workspace:/workspace -p 8888:8888 asia.gcr.io/linker-aurora/caffe-notebook start-notebook.sh --NotebookApp.base_url=/v1 --NotebookApp.token=''
```
