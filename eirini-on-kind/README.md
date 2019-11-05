# eirini-on-kind

TODO this is a placeholder until I can go over all the work I did earlier and make sure that there aren't any secrets or other weird things left in this. Previously I had goofed around enough to get things to work on kubernetes as deployed on vSphere via PKS, buuuut even then it was just goofing.

The goal is to make this work on KIND (kubernetes in docker); e.g., kubernetes that can be ran on someone's laptop

this prooobably won't completely work locally on `kind`, and if it does, it'll be super slow

recent inspiration:
- https://github.com/paulczar/helmfile-eirini/blob/master/values/eirini/values.yaml.gotmpl
- https://github.com/SUSE/catapult
- https://github.com/SUSE/kubecf
