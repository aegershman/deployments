# yugabyte-on-kind

## debugging and troubleshooting

```sh
# For master nodes:
kubectl -n yugabyte logs -f -lapp=yb-master

# For tservers:
kubectl -n yugabyte logs -f -lapp=yb-tserver

# For everything at once:
# For tservers:
kubectl -n yugabyte logs -f -lchart=yugabyte --max-log-requests=10
```
