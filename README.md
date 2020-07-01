# deployments

k8s deployments, focused on being `kind`/`minikube`-friendly. These are for experimentation and demonstrations of stitching together systems.

Each folder is it's own grouping of one-or-more deployments. So for example, a folder for `cf-for-k8s` might have `cf-for-k8s` _and_ `prometheus` and `harbor` and `minibroker`, etc. Or the `concourse` folder will be `concourse` _and_ `jaeger` and `prometheus` and `so-on` and `so-on` and `etc.` The groupings are whatever fits thoughts and needs.

Sometimes I leave commented notes and links scattered in yaml documents, which is a little arbitrary. Sometimes I put down values in the `values.yml` which are the same value as what ships by default, but I'm putting it there because it serves as a reminder about what the default value is or what the configurable options are.

## structure

Yeah this is about to get a little wild and unruly:

```sh
./foundations/{iaas}/{region}/{environment}/{cluster_name}/deployments/{deployment_grouping}
```

If a folder starts with an underscore, such as `_rendered/` or `_common`, it implies the contents of the folder is not for humans to modify-- only for build scripts, vendoring, or the output of build scripts.
