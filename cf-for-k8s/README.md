# cf-for-k8s

So if you look in `kubecf` you'll notice that it works through `helmfile`, i.e. a series of helm charts. There are pros and cons to `helm` in general, and not everything on planet earth uses helm, and that's okay. `cf-for-k8s` uses numerous tools from [`k14s`](https://github.com/k14s), which has an incredible collection of composable k8s and deployment tooling. This deployment will be a little different from others and will require a bit more shell scripting, which again, that's okay. We'll figure it out. Or we won't, I don't know, who knows anything anymore, I don't, no one does.

We're going to try structuring this based on `ytt` overlays and `helm` templating.

## values, credentials, and you

Be mindful this places the output of `./generate-values` and `ytt` formatting, which all include all sorts of fun credentials, in `rendered/cf/*.yml`.

These contain credentials and will be picked up by `git`; I'm keeping it under version control because I'm curious about the diff history over time, but for anything serious, wow please do not allow those credentials to be checked into `git`, that's not great.
