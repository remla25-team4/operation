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

```bash
docker compose up
```


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

### Steps to start the Kubernetes cluster
1. Clone the operations repository (if not already):

```bash
git clone https://github.com/remla25-team4/operation.git
cd operation
```

2. Start the virtual machines with Vagrant
```bash
vagrant up
```
---


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


