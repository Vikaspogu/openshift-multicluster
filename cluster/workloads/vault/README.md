# vault


## Application deployment

Patch the restricted SCC and, will add it to the service account in the application namespace

```bash
oc patch scc restricted --type='merge' -p '{"volumes":["configMap","csi","downwardAPI","emptyDir","persistentVolumeClaim","projected","secret"]}'
```
