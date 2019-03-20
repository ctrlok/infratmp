# Requirements
packer, terraform, gcloud, kubectl, docker

# Build artifacts
```
bash ./build_deploy.sh
```

# Application

You can find code in `main.go` file.
Tests in `main_test.go`
Benchmarks in `parse_colon_test.go`

# Deploy new version

## AWS
Change dir to terraform, update ami version in `main.tf` with new, recieved from ./build_deploy.sh
And run
```
terraform plan
terraform apply
```

## Google cloud
```
kubectl apply -f kubernetes/deploy.yml
kubectl apply -f kubernetes/service.yml
```

I didn't found how I can assing static global address to network load balancer
created by kubernetes service, and we need to use static global ip address
because it support anycast. Right now that feature supported only for
ingress controllers in GKE (http only). Possible we can create additional
balancer with terraform.

For supporting geolocation routing in GKE we can use Route53 with latency based
routing. I'm not sure it will works wee, but better than nothing.
