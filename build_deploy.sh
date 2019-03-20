#!/usr/bin/env bash
# PoC reasons only
# TODO: rewrite to Makefile or packer or ansible

docker run --rm -ti -v `pwd`/:/project -w /project golang:1.12 bash -c "go test && go build"
for FILE in ./aws_env/*
do
  packer build -var-file=$FILE packer.json
done

gcloud auth configure-docker --project practical-scion-165616
docker build . -t gcr.io/practical-scion-165616/morze:latest
docker push gcr.io/practical-scion-165616/morze:latest
rm morze
