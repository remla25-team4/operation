# Restaurant Sentiment Analysis - Group 4

The operations repository is used to run the complete Restaurant Sentiment Analysis application of Group 4. It includes the configuration to deploy the necessary services using Docker Compose.

This app will allow the user to enter short restaurant reviews via our UI. These reviews are processed by our app service, which forwards them to our model which the classifies the sentiment (positive or negative).

---





## How to run our application for Assignment 1
### Requirements

* Docker installed
* Docker Compose (comes with modern Docker)
* Internet access to pull public images and download the model

### Quick start

1. Clone this repository:

```bash
git clone https://github.com/remla25-team4/operation.git
cd operation
```

2. Make sure the `.env` file exists (already included)

3. Start the application:

You have two options:

a. Run in foreground (shows logs)

```bash
docker compose up
```

This starts the services and shows logs in your terminal. You can then press `CTRL+C` to stop the application

b. Run in background (detached mode)

```bash
docker compose up -d
```
This runs the containers in the background. To view logs: `docker compose logs -f` and to stop everything: `docker compose down`


The app will start two services:

* `app` (frontend + backend) at [http://localhost:3001](http://localhost:3001)
* `model-service` (ML API) internally at `http://localhost:8080`

---

### Environment Configuration

Variables defined in the `.env` file:

```env
MODEL_URL="https://github.com/remla25-team4/model-training/raw/main/models/naive_bayes.joblib"
MODEL_SERVICE_URL=http://localhost:8080
```

* `MODEL_URL` points to the trained model file
* `MODEL_SERVICE_URL` tells the app where to find the model API

---


## How to run our application for Assignment 2
### Requirements
* VirtualBox installed
* Vagrant installed
* Ansible installed
* SSH enabled (please copy your public key to `operation/public-keys`)

### Steps to start the Kubernetes cluster
1. Clone the operations repository (if not already):

```bash
git clone https://github.com/remla25-team4/operation.git
cd operation
```

2. Start the virtual machines with Vagrant
```bash
vagrant up --provision
```

3. Finalize setup with finalization.yml
```bash
ansible-playbook -u vagrant -i 192.168.56.100, finalization.yml
```

4. Add hostname to enable access in the browser
```bash
sudo nano /etc/hosts
```
Once open, paste this line at the end

`192.168.56.90   dashboard.local`

 then save and exit.

5. Load kubeconfig to all your terminal sessions

Depending on what terminal you are using:
```bash
nano ~/.bashrc
```

if you are using bash or 

```bash
nano ~/.zshrc
```

if you are using zsh.

Copy the full path of the file named `kubeconfig` in this repository that should be generated after running step 3.

Then paste this line at the end of your `.bashrc`/`.zshrc`:
`export KUBECONFIG=path/to/your/operation/kubeconfig`

Save and exit then:
```bash
source ~/.bashrc
```
to make the changes permanent.


5. Obtain access token
```bash
kubectl -n kubernetes-dashboard create token admin-user
```
Use the token displayed on screen to access the kubernetes dashboard at dashboard.local. 

**Note:** make sure to visit the site using https.

## How to run our application for Assignment 3
### Prerequisites

1.  **Kubernetes Cluster:** A running Kubernetes cluster by following the instructions from a2.
2.  **Helm:** Helm v3 installed. Verify with `helm version`.

### Chart Location
The Helm chart is located in the `operations/restaurant-sentiment/` directory of this repository.

The primary way to configure the deployment is by modifying the `operations/restaurant-sentiment/values.yaml` file.

Key values you might want to customize:

* **`app.image.tag`**: The tag for the `app` service Docker image (default: `latest`).
* **`modelService.image.tag`**: The tag for the `model-service` Docker image (default: `latest`).
* **`modelService.env.MODEL_URL`**: **Crucial.** The URL from which the `model-service` will download the machine learning model.
    * Default: `"https://github.com/remla25-team4/model-training/raw/main/models/naive_bayes.joblib"`
* **`ingress.host`**: The hostname for accessing the application via Ingress (default: `"restaurant.local"`). You will likely need to update your local `/etc/hosts` file to point this hostname to your Ingress controller's external IP.
* **`replicaCount`**: Number of replicas for each deployment (default: `1`).
* **`imagePullPolicy`**: Default is `Always` to ensure the latest image is pulled.
* **`app.configData`**: Data to populate the `app` service's ConfigMap.
* **`app.secretData`** Data to populate the `app` services's secrets.
* **`modelService.containerPort` / `modelService.env.PORT`**: Port the model service listens on (default: `8080`).

### Installation Steps

1.  **Navigate to the Helm chart directory (optional, can also install from root):**
    ```bash
    cd restaurant-sentiment
    ```

2. **Install the Helm chart:**
    Choose a release name (e.g., `restaurant-sentiment`) and a namespace (e.g., `default`).
    If you are inside the `operations/restaurant-sentiment` directory:
    ```bash
    helm install restaurant-sentiment . --namespace default
    ```
    Wait for a minute or two for the containers to fully deploy within the cluster to proceed with accessing the application.
    You can also run `kubectl get pods -n default -l app.kubernetes.io/instance=restaurant-sentiment -w` to see the deployment status
### Accessing the Application

1.  **Get the External IP of your Ingress Controller:**
    ```bash
    kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
    ```
    This IP is provided by MetalLB in the A2 setup. (default: 192.168.56.90)

2.  **Update Your Local `/etc/hosts` File:**
    On your local machine (the one from which you want to access the application), edit your `/etc/hosts` file (e.g., `sudo nano /etc/hosts` on Linux/macOS, or an equivalent for Windows located at `C:\Windows\System32\drivers\etc\hosts`). Add an entry mapping the `ingress.host` (from `values.yaml`, e.g., `restaurant.local`) to the external IP obtained in the previous step.
    Example:
    ```
    192.168.56.90  dashboard.local restaurant.local
    ```

3.  **Open in Browser:**
    Open your web browser and navigate to the configured host (e.g., `http://restaurant.local`).

### Prometheus Monitoring
1. **Navigate to the Helm chart directory (optional, can also install from root):**
    ```bash
    cd monitoring
    ```
2. **Install the Helm chart:**
    Choose a release name (e.g., `monitoring`) and a namespace (e.g., `default`).
    If you are inside the `operations/monitoring` directory:
    ```bash
    helm install monitoring . --namespace default -f values.yaml --replace # you might have to try twice
    ```
    Wait for a minute or two for the containers to fully deploy within the cluster to proceed with accessing the application.
    You can also run `kubectl get pods -n default -l app.kubernetes.io/instance=monitoring -w` to see the deployment status

### Accessing the prometheus and grafana dashboards
1. **Update Your Local `/etc/hosts` File:**
    On your local machine (the one from which you want to access the application), edit your `/etc/hosts` file (e.g., `sudo nano /etc/hosts` on Linux/macOS, or an equivalent for Windows located at `C:\Windows\System32\drivers\etc\hosts`). Add an entry mapping the `ingress.host` (from `values.yaml`, e.g., `prometheus.local`) to the external IP obtained in the previous step from the app installation.
    Example:
    ```
    192.168.56.90  dashboard.local restaurant.local prometheus.local grafana.local
    ```
2.  **Open in Browser:**

    Open your web browser and navigate to the configured host (e.g., `http://prometheus.local` or `http://grafana.local`).
3. **Logging into Grafana:**
    To log into Grafana, use `admin` for the username and `admin` for the password.

4. **Import Grafana dashboard:** You may import our Grafana dashboard. To do so, import the `Restaurant sentiment dashboard.json` that may be found under the `monitoring/dashboards/`.

    Open your web browser and navigate to the configured host (e.g., `http://prometheus.local`).


## How to run our application for Assignment 4

Instructions for cloning model-training repo, running DVC, etc.
Link to: https://github.com/remla25-team4/model-training


## How to run our application for Assignment 5
### Usage Instructions

This guide explains how to deploy the v1 and v2 (canary) versions of the application using Istio for traffic management.

### Prerequisites

* Kubernetes cluster running (You have followed all previous steps).
* Istio installed.
* Deployment namespace (e.g., `default`) enabled for Istio sidecar injection:
    ```bash
    kubectl label namespace default istio-injection=enabled
    ```

### Step 1: Deploy App

This deploys the main version of `app` alongside a canary release and `model-service`, with Istio configurations (Gateway, DestinationRules, VirtualServices for 90/10 split and consistent routing).

1.  Change directory to '/istio':
    ```bash
    cd istio
    ```

2.  Apply `app.yml`:
    ```bash
    kubectl apply -f app.yml
    ```

3.  Apply `app-canary.yml`:
    ```bash
    kubectl apply -f app-canary.yml
    ```
4.  Wait for pods to be ready:
    ```bash
    kubectl get pods -n default -w
    ```
    The 90/10 traffic split defined in `app.yml` (and reaffirmed in `app-canary.yml`) will now route 10% of traffic to `app-v2`.

### Step 2: Access the Application

1.  Get the Istio Ingress Gateway address:
    ```bash
    kubectl get svc istio-ingressgateway -n istio-system
    ```
2.  Copy the `EXTERNAL-IP` and paste it in your browser.

### Step 3: Choose Routing Strategy

For this assignment, we have implemented both the option to route traffic with weights (v1: 90% / v2: 10%) and sticky sessions (odd userids always get v1 and even userids get v2)

To enable weighted routing:

```bash
kubectl apply -f weighted-routing.yml
```

To enable sticky routing:

```bash
kubectl apply -f sticky-routing.yml
```

Note: To test the correctness of the routing behavior, you can use the following command:

```bash
curl -H "userid: 1" 192.168.56.91/api/versions
```

For weighted routing, you should see that an older version of app is displayed most of the time.

For sticky routing, if the userid value is odd, the app version will always be the older one (v1) and will not change if userid stays the same
If the userid is changed to an even numberm the app version should now be the newer one (v2).


### step 4: Rate-limiting

To enable rate-limiting run:
```bash
kubectl apply -f rate-limit.yml
```

## Related Repositories 



| Repo                                                              | Purpose                               |
| ----------------------------------------------------------------- | ------------------------------------- |
| [model-training](https://github.com/remla25-team4/model-training) | Trains the ML model and publishes it  |
| [model-service](https://github.com/remla25-team4/model-service)   | Wraps the trained model in a REST API |
| [lib-ml](https://github.com/remla25-team4/lib-ml)                 | Shared data preprocessing code        |
| [lib-version](https://github.com/remla25-team4/lib-version)       | Shared version metadata utility       |
| [app](https://github.com/remla25-team4/app)                       | Frontend and backend for user input   |

---
### Pointers to Relevant Files

| File                                                                                                                                | Description                                                       |
| ----------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------- |
| `docker-compose.yml`                                                                                                                | launches both app and model-service containers                    |
| `.env`                                                                                                                              | defines the required runtime environment variables                    |
| [`model-service/app/main.py`](https://github.com/remla25-team4/model-service/blob/main/app/main.py)                                 | Loads the model and defines the REST API                          |
| [`app/index.js`](https://github.com/remla25-team4/app/blob/main/index.js)                                                           | main backend server for serving frontend and routing API requests |
| [`app/app-frontend/src/App.js`](https://github.com/remla25-team4/app/blob/main/app-frontend/src/App.js)                             | main React component rendered to user                             |
| [`model-training/model_code/create_model.py`](https://github.com/remla25-team4/model-training/blob/main/model_code/create_model.py) | Core model training logic                                         |
| [`model-training/models/naive_bayes`](https://github.com/remla25-team4/model-training/blob/main/models/naive_bayes)                 | stored trained model used in production                           |
| [`lib-ml/preprocessing.py`](https://github.com/remla25-team4/lib-ml/blob/main/preprocessing.py)                                     | Text preprocessing logic used during training and inference       |

---



## Progress Log

### Assignment 1 (06/05/2025)

* Created all required repositories in a GitHub organization.
* Trained and versioned a sentiment model with Niave Bayes for restaurant reviews.
* Set up reusable libraries (`lib-ml`, `lib-version`).
* Built and containerized both app and model-service.


### Assignment 2 (12/05/2025)

* Provisioned a multi-node Kubernetes cluster using Vagrant and Ansible (1 controller and 2 worker)
* Installed core elements such as: Flannel, Helm, MetalLB, Ingress Controller 
* Automated cluster configuration with Ansible playbooks for all nodes
* Prepared the environment for Kubernetes-based deployment of the sentiment analysis application.~~
