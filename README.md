# deployments

## archive note Nov. 02, 2023

I don't care about "proper organization" as much anymore since I've learned that corporate deployment operations will always be a beautiful bespoke disaster anyway. So just do what's easiest to maintain.

---

NOTE: currently the most active workspace cluster is `aws/us-east-2/sandbox/cf-for-k8s-demo`

`k8s` deployments. These are for experimentation and demonstrations of stitching together systems. Emphasis on being as declarative and `git`-driven as technically possible. Emphasis on being `kind`/`minikube`-friendly. Emphasis on accounting for multiple environments. Trying to work out ideas of promoting from environment to environment. Conceptually this focuses on clusters as a whole; deployments might be built, configured, and applied independently, but the end-result emphasizes the cumulative result of everything happening on the cluster.

Ideally, the discrete processes of building, configuring, and applying will be self-contained as much as possible and not require significant additional steps which wouldn't be possible to re-create on an individual's workspace. Ideally, a CI/CD system (like `concourse`, etc.) would really only be an orchestrator, rather than used to apply additional functions or values which aren't otherwise captured here in this repository. This makes it easier to predict and reproduce what build outputs will look like without having significant dependance on a specific system (like `spinnaker`, etc.); it means that whatever system is used (like ... `jenkins`? etc.?) just has to orchestrate the different "functions", like "build", "configure", "apply", etc. That makes it much easier to swap out, and reproduce what's happening locally. We'll see to what extent that's possible, but that's the ideal state.

## why we care about the aggregate cluster state

Let's say we want to use `cert-manager` to generate `lets-encrypt` certificates for `cf-for-k8s` as part of it's use of `istio`. We need `cert-manager` on the cluster. There's a dependency. Let's say we want to use `harbor` for image storage for `cf-for-k8s`; there's a dependency. Let's say we want to use an `istio` `virtual-service` for `harbor`; there's a dependency. Let's say we want to use `external-dns` to have all the dns used by all these components; there's a dependency. Let's say we want to use the `crds` used by `prometheus-operator` to monitor other components via a `service-monitor` and such; there's a dependency. Let's say we want to use `minibroker` on the cluster for `cf-for-k8s` to provision services in the `cf marketplace`; there's a dependency.

And so on and so forth.

We care about the aggregate state because it's impractical to think about everything as discretes. And that's okay. Individual systems _should_ be discrete to allow better cross-system usage, for individual systems to be configured and upgraded on their own, for more flexibility in use-cases, and just in general for better conceptual cognitive mapping. But to think that `harbor` can exist independently from `cf-for-k8s` can exist independently from a credential manager (e.g. `cert-manager`) is impractical.

The configuration of, and ordering of, these discrete deployments working together is important when they're aggregate together to all live together on the cluster.
