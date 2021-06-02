# Configuring Kubernetes Dashboard

```bash
kubectl apply -f dashboard.yaml
```
verify that dashboard component has sucessully deployed
```bash
kubectl get all -n kubernetes-dashboard
```
## Acessing the Dashboard
we will access the dashboard with loadbalancer service

```bash
kubectl edit service/kubernetes-dashboard -n kubernetes-dahboard
```
change the type from ClusterIP to LoadBalancer

## Check LB's IP
```bash
kubectl get svc -n kubernetes-dashboard
```
try to access https://$loadbalancer-ip

## There are 2 option to sign in
1. Using Token
2. Using kubeconfig file

## 1.  Token
```bash
kubectl apply -f token/dashboard-admin.yaml
```
see the secret from admin-user
```bash
kubectl get secret -n kubernetes-dashboard
```
see the detail of admin-user secret
```bash
kubectl describe secret admin-user-token-$hash -n kubernetes-dashboard
```
copy the output of a long string of seemingly random characters and paste into token field on kubernetes dashboard 

#Optional
## 2. kubeconfig file

Create the service account
```bash
kubectl create -f sa.yaml
```

This will use your personal account to create the service account. 

Fetch the name of the secrets used by the service account
This can be found by running the following command:

```bash
kubectl describe serviceAccounts svcs-acct-dply
```
output
```bash
Name:                   svcs-acct-dply
Namespace:          default
Labels:             <none>
Annotations:            <none>

Image pull secrets: <none>
Mountable secrets:  svcs-acct-dply-token-h6pdj
Tokens:             svcs-acct-dply-token-h6pdj
```

Note down the Mountable secrets information which has the name of the secret that holds the token

Fetch the token from the secret
Using the Mountable secrets value, you can get the token used by the service account. Run the following command to extract this information:
```bash
kubectl describe secrets svcs-acct-dply-token-h6pdj
```
output
```bash
Name:               svcs-acct-dply-token-h6pdj
Namespace:      default
Labels:         <none>
Annotations:    kubernetes.io/service-account.name=svcs-acct-dply
        kubernetes.io/service-account.uid=c2117d8e-3c2d-11e8-9ccd-42010a8a012f

Type:   kubernetes.io/service-account-token

Data
====
ca.crt:     1115 bytes
namespace:  7 bytes
token:      eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6InNoaXBwYWJsZS1kZXBsb3ktdG9rZW4tN3Nwc2oiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoic2hpcHBhYmxlLWRlcGxveSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6ImMyMTE3ZDhlLTNjMmQtMTFlOC05Y2NkLTQyMDEwYThhMDEyZiIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OnNoaXBwYWJsZS1kZXBsb3kifQ.ZWKrKdpK7aukTRKnB5SJwwov6PjaADT-FqSO9ZgJEg6uUVXuPa03jmqyRB20HmsTvuDabVoK7Ky7Uug7V8J9yK4oOOK5d0aRRdgHXzxZd2yO8C4ggqsr1KQsfdlU4xRWglaZGI4S31ohCApJ0MUHaVnP5WkbC4FiTZAQ5fO_LcCokapzCLQyIuD5Ksdnj5Ad2ymiLQQ71TUNccN7BMX5aM4RHmztpEHOVbElCWXwyhWr3NR1Z1ar9s5ec6iHBqfkp_s8TvxPBLyUdy9OjCWy3iLQ4Lt4qpxsjwE4NE7KioDPX2Snb6NWFK7lvldjYX4tdkpWdQHBNmqaD8CuVCRdEQ
```
This will output the token information that looks something like above. Note down the **token** value

Get the certificate info for the cluster
Every cluster has a certificate that clients can use to encryt traffic. Fetch the certificate and write to a file by running this command. In this case, we are using a file name cluster-cert.txt

```bash
kubectl config view --flatten --minify > cluster-cert.txt
cat cluster-cert.txt
```
output

```bash
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURDekNDQWZPZ0F3SUJBZ0lRZmo4VVMxNXpuaGRVbG15a3AvSVFqekFOQmdrcWhraUc5dzBCQVFzRkFEQXYKTVMwd0t3WURWUVFERXlSaVl6RTBOelV5WXkwMk9UTTFMVFExWldFdE9HTmlPUzFrWmpSak5tUXlZemd4TVRndwpIaGNOTVRnd05EQTVNVGd6TVRReVdoY05Nak13TkRBNE1Ua3pNVFF5V2pBdk1TMHdLd1lEVlFRREV5UmlZekUwCk56VXlZeTAyT1RNMUxUUTFaV0V0T0dOaU9TMWtaalJqTm1ReVl6Z3hNVGd3Z2dFaU1BMEdDU3FHU0liM0RRRUIKQVFVQUE0SUJEd0F3Z2dFS0FvSUJBUURIVHFPV0ZXL09odDFTbDBjeUZXOGl5WUZPZHFON1lrRVFHa3E3enkzMApPUEQydUZyNjRpRXRPOTdVR0Z0SVFyMkpxcGQ2UWdtQVNPMHlNUklkb3c4eUowTE5YcmljT2tvOUtMVy96UTdUClI0ZWp1VDl1cUNwUGR4b0Z1TnRtWGVuQ3g5dFdHNXdBV0JvU05reForTC9RN2ZpSUtWU01SSnhsQVJsWll4TFQKZ1hMamlHMnp3WGVFem5lL0tsdEl4NU5neGs3U1NUQkRvRzhYR1NVRzhpUWZDNGYzTk4zUEt3Wk92SEtRc0MyZAo0ajVyc3IwazNuT1lwWDFwWnBYUmp0cTBRZTF0RzNMVE9nVVlmZjJHQ1BNZ1htVndtejJzd2xPb24wcldlRERKCmpQNGVqdjNrbDRRMXA2WXJBYnQ1RXYzeFVMK1BTT2ROSlhadTFGWWREZHZyQWdNQkFBR2pJekFoTUE0R0ExVWQKRHdFQi93UUVBd0lDQkRBUEJnTlZIUk1CQWY4RUJUQURBUUgvTUEwR0NTcUdTSWIzRFFFQkN3VUFBNElCQVFCQwpHWWd0R043SHJpV2JLOUZtZFFGWFIxdjNLb0ZMd2o0NmxlTmtMVEphQ0ZUT3dzaVdJcXlIejUrZ2xIa0gwZ1B2ClBDMlF2RmtDMXhieThBUWtlQy9PM2xXOC9IRmpMQVZQS3BtNnFoQytwK0J5R0pFSlBVTzVPbDB0UkRDNjR2K0cKUXdMcTNNYnVPMDdmYVVLbzNMUWxFcXlWUFBiMWYzRUM3QytUamFlM0FZd2VDUDNOdHJMdVBZV2NtU2VSK3F4TQpoaVRTalNpVXdleEY4cVV2SmM3dS9UWTFVVDNUd0hRR1dIQ0J2YktDWHZvaU9VTjBKa0dHZXJ3VmJGd2tKOHdxCkdsZW40Q2RjOXJVU1J1dmlhVGVCaklIYUZZdmIxejMyVWJDVjRTWUowa3dpbHE5RGJxNmNDUEI3NjlwY0o1KzkKb2cxbHVYYXZzQnYySWdNa1EwL24KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
    server: https://35.203.181.169
  name: gke_jfrog-200320_us-west1-a_cluster
contexts:
- context:
    cluster: gke_jfrog-200320_us-west1-a_cluster
    user: gke_jfrog-200320_us-west1-a_cluster
  name: gke_jfrog-200320_us-west1-a_cluster
current-context: gke_jfrog-200320_us-west1-a_cluster
kind: Config
preferences: {}
users:
- name: gke_jfrog-200320_us-west1-a_cluster
  user:
    auth-provider:
      config:
        access-token: ya29.Gl2YBba5duRR8Zb6DekAdjPtPGepx9Em3gX1LAhJuYzq1G4XpYwXTS_wF4cieZ8qztMhB35lFJC-DJR6xcB02oXXkiZvWk5hH4YAw1FPrfsZWG57x43xCrl6cvHAp40
        cmd-args: config config-helper --format=json
        cmd-path: /Users/ambarish/google-cloud-sdk/bin/gcloud
        expiry: 2018-04-09T20:35:02Z
        expiry-key: '{.credential.token_expiry}'
        token-key: '{.credential.access_token}'
      name: gcp
```

Copy two pieces of information from here **certificate-authority-data** and **server**

## Create a kubeconfig file
From the steps above, you should have the following pieces of information

token
certificate-authority-data
server

Create a file called sa-config and paste this content on to it

## kubeconfig
```bash
apiVersion: v1
kind: Config
users:
- name: svcs-acct-dply
  user:
    token: <replace this with token info>
clusters:
- cluster:
    certificate-authority-data: <replace this with certificate-authority-data info>
    server: <replace this with server info>
  name: self-hosted-cluster
contexts:
- context:
    cluster: self-hosted-cluster
    user: svcs-acct-dply
  name: svcs-acct-context
current-context: svcs-acct-context
```
Save it as sa-config.cfg
## Copy the file to $HOME/.kube

If you want your client to use this context, copy sa-config to $HOME/.kube and you can configure kubectl to use the context

```bash
kubectl config --kubeconfig=$HOME/.kube/sa-config set-context svcs-acct-context
```

## Create ClusterRoleBinding 
with cluster-admin bind to service account  svcs-acct-dply so that kubeconfig have permission as cluster-admin
```bash
kubectl apply -f clusterrolebinding.yaml
```
now you have sa-config.cfg, you can upload that file in kubeconfig field on kubernetes-dashboard.

source :
- https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
- https://upcloud.com/community/tutorials/deploy-kubernetes-dashboard/
- http://docs.shippable.com/deploy/tutorial/create-kubeconfig-for-self-hosted-kubernetes-cluster/