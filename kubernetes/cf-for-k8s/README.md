# cf-for-k8s

So if you look in `kubecf` you'll notice that it works through `helmfile`, i.e. a series of helm charts. There are pros and cons to `helm` in general, and not everything on planet earth uses helm, and that's okay.

`cf-for-k8s` uses numerous tools from [`k14s`](https://github.com/k14s), which has an incredible collection of composable k8s and deployment tooling.

This deployment will be a little different from others and will require a bit more shell scripting, which again, that's okay. We'll figure it out. Or we won't, I don't know, who knows anything anymore, I don't, no one does.
