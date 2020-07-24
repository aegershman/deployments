# _rendered

I'm not 100% sure how this is going to work; I'm trying to achieve some sense of "unified single state descriptor" which represents the final aggregate state of all the configuration parts and pieces, which can be `kapp apply`'d once all the individual deployments and vendored, built, and configured, and then applied in the same context-- which is a single cluster.

The rationale is that there are multiple cross-deployment dependencies, such as `grafana` having a `virtual-service` which relies on the `istio` configuration of `cf-for-k8s`. Or the need to define deployments in certain orders (like `external-dns` before `cf-for-k8s`), or `namespaces` with certain labels (`istio-injection: disabled`), and it just makes more sense to have all of this be setup in the same context. They're often all dependent on each other to some degree, so let's just try having the structure of all individual deployments render themselves to the best of their abilities, and then the final conglomeration of deployments and configuration ends up in a unified `_rendered`, which gets updated with `kapp`.

In this way, although we make changes on individual deployments, we're thinking about the endstate of the conglomeration of all these deployments being the "whole state" of the kubernetes cluster.

## tl;dr

we should think about this in terms of the aggregate state of the cluster, not individual deployments which happens to be colocated on the same kubernetes cluster. no deployment is an island.
