# Restaurant Sentiment Analysis – Operations

This operation repository is used to run the complete Restaurant Sentiment Analysis application for the REMLA course at TU Delft for Group 4. It includes the configuration to deploy all necessary services using Docker Compose.

The application allows a user to enter short restaurant reviews via our UI. These reviews are processed our app service, which forwards them to a our model that classifies the sentiment (positive or negative).

---

## How to Run the Application

### ⚙️ Requirements

* Docker installed
* Docker Compose (comes with modern Docker)
* Internet access to pull public images and download the model

### ▶️ Quick start

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

The application will start two services:

* `app` (frontend + backend) at [http://localhost:3001](http://localhost:3001)
* `model-service` (ML API) internally at `http://model-service:8080`

---

## Environment Configuration

The following variables are defined in the `.env` file:

```env
MODEL_URL=https://github.com/remla25-team4/model-training/raw/main/models/naive_bayes
MODEL_SERVICE_URL=http://model-service:8080
```

* `MODEL_URL` points to the trained model file
* `MODEL_SERVICE_URL` tells the app where to find the model API

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
### 🔎 Pointers to Relevant Files

* [`docker-compose.yml`](docker-compose.yml): Defines how to run the application services.
* [`model-service/app/main.py`](https://github.com/remla25-team4/model-service/blob/main/app/main.py):Contains the logic to load and serve the trained model.
* [`model-service/openapi.yaml`](https://github.com/remla25-team4/model-service/blob/main/openapi.yaml): OpenAPI schema for the REST endpoints.
* [`model-training/model_code`](https://github.com/remla25-team4/model-training/tree/main/model_code): Training logic and preprocessing pipeline.
* [`model-training/models/naive_bayes`](https://github.com/remla25-team4/model-training/blob/main/models/naive_bayes): The stored ML model file downloaded at runtime.
## Progress Log

### Assignment 1

* Created all required repositories in a GitHub organization.
* Trained and versioned a sentiment model for restaurant reviews.
* Set up reusable libraries (`lib-ml`, `lib-version`).
* Built and containerized both app and model-service.

---

## Notes

* The system uses REST APIs internally to communicate.

