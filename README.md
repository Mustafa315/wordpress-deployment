# Terraform to launch a WordPress application that supports HTTPS access

* setup of Terraform for deploying a Minikube Kubernetes cluster.
* Three Helm charts will be released by the Kubernetes cluster. WordPress helm chart, MySQL helm chart, and cert-manager helm chart.
* Wordpress volume persistence (PVC) to store Wordpress files on it.
* Make a bash script that passes the Kubernetes cluster ip to the Ingress as an output.
* NodePort Service creation on the WordPress helm chart.
* Utilising Self-signed certificate that is not issued by a certificate authority.
* Golang is used to create terraform test, and it is successful when it returns status code of 200 (Time stamp we created).
* Establishing a CD tool using Github Actions.

### Prerequisites
* [Terraform](https://www.terraform.io/downloads.html)
* [Go](https://golang.org/dl/)

### Run
* Initializing terraform modules.
 ```sh
  terraform init
  ``` 

* Check what changes will occur once ran.
 ```sh
  terraform plan
  ``` 

* Apply changes.
 ```sh
  terraform apply -auto-approve
  ``` 

* Creating PVC
 ```sh
  metadata:
  name: wordpress-pvc
  annotations:
    "helm.sh/hook": "pre-install"
    "helm.sh/hook-weight": "1"
  spec:
   storageClassName: standard
   accessModes:
     - ReadWriteOnce
   resources:
     requests:
       storage: 200Mi
   ```

* Installing PVC to store Wordpress files.
 ```sh
  args:
          - echo starting;
            curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar;
            chmod +x wp-cli.phar;
            mv wp-cli.phar /usr/local/bin/wp;
            wp core install --url=localhost --title="WordPress" --admin_user=admin --admin_password=password --admin_email=admin@test.com --allow-root --path=/var/www/html
        volumeMounts:
        - name: wordpress
          mountPath: /var/www/html
      volumes:
        - name: wordpress
          persistentVolumeClaim:
            claimName: wordpress-pvc
      restartPolicy: OnFailure
   ```

* Passing the cluester IP through bash script to Ingress.
 ```sh
  function extract_data() {
  my_ip=$(minikube ip)
  jq -n --arg my_ip "$my_ip" '{"my_ip":"'$my_ip'"}'
  }
  ``` 

* Run Terratest manually as a test to ensure.  
 ```sh
  cd test
  go test -v
  ``` 

* Using http-helper.
 ```sh
  http_helper.HttpGetWithRetryWithCustomValidation(t, "https://"+url, &tlsConfig, maxRetries, timeBetweenRetries, validate)
  ```

### Github actions 
* Workflow is configured to run once a push.
 ```sh
  on:
    push: {}
  ```


### About Questions: 
## How would you manage secrets inside? 
* By using Kubernetes External Secrets :
* Kubernetes External Secrets store information outside the Kubernetes cluster while still allowing Kubernetes resources to use them. They are stored in an external service that Kubernetes interacts with to read and write secrets.

## What tooling would you use? 
* Terraform variables from github secrets can be used with the cluster and the cloud to access external secrets.
* We can also use External Secrets Operator (ESO), ESO is a Kubernetes Operator that interacts with external providers.

| Concept | Summary | 
| ------  | ------- |
|Kubernetes Secrets |  Secrets are Kubernetes objects that contain sensitive data such as credentials, API keys, etc.<br>Kubernetes Secrets are the default construct for managing sensitive data in Kubernetes.|
| ------  | ------- |
| Kubernetes External Secrets  | Kubernetes External Secrets store sensitive data outside the Kubernetes cluster.<br>External providers such as HashiCorp Vault and AWS Secrets Manager handle entire secret lifecycle management.<br>Kubernetes cluster objects such as pods can reference these externally stored secrets. |
| ------  | ------- |
| External Secrets Operator (ESO) | External Secrets Operator (ESO) is a Kubernetes Operator that interacts with external providers.<br>ESO uses APIs these external providers provide and fetches the secrets stored in external backends.<br>ESO is compatible with several secrets providers such as AWS Secrets Manager, HashiCorp Vault, Azure Key Vault, etc. |

## Describe your approach for deploying and managing “Addons” applications that enable, automate or facilitate setups on Kubernetes. 
* by using Argo CD
* Argo CD is a Kubernetes controller, responsible for continuously monitoring all running applications and comparing their live state to the desired state specified in the Git repository. 

