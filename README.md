# deployments

personal BOSH deployments, k8s clusters, etc.

This is a scratchpad space for me to test out deploying things, so there's not really maintained doc... or any doc. My goal is to make things as declarative and "single-processed" as possible, e.g. avoiding a bunch of bash scripts and stuff. Both BOSH and k8s are all about declarative config and convergence loops rather than imperative commands (at least theoretically) so the deployment options should be the same.

## yugabyte

I love [yugabyte](https://github.com/yugabyte/yugabyte-db) and you should too. There's a quick cute lil' example of deploying it on k8s using `helm`.

## kubecf && cf-for-k8s

In `kubernetes/` there are demos of deploying both [`kubecf`](https://github.com/cloudfoundry-incubator/kubecf) and [`cf-for-k8s`](https://github.com/cloudfoundry/cf-for-k8s) on [`kind`](https://github.com/kubernetes-sigs/kind)

- `kubecf` uses `helmfile` to deploy, and it stands up locally in about 25 minutes
- `cf-for-k8s` doesn't use `helm` primarily, so it's a specific process
