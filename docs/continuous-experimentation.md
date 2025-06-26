# Experiment

The aim of our experiment is to improve the user experience by bringing a dark look to the user interface (UI). To do so, we:
- Switch to a darker theme to highlight the button
- Add a button animation on hover
- Spread out version information

To test if our modifications are more effective, we measure if users click the new button interface more quickly than previously.

## Implementated aspects:
- Changed the UI, as described above.
- Implemented Sticky sessions
- Implemented a 90/10 traffic split.


## Hypothesis (Expected Effect)
Our interface change will reduce the average time it takes a user to submit their feedback.

## Experiment Metric
We have a `time_to_click_seconds` metric. This measures the time it takes a user to click the button since the page is first loaded. 

## Experiment Visualization

In our grafana dashboard, we average this to obtain an `average_time_to_click_seconds`, so that we can extend this experiment to multiple users.

## Acceptance Critera
We will accept the `Canary version` if and only if it provides an average decrease of 20% to the `average_time_to_click_seconds` metric.


## Trying out the Experiment
To try out the experiment, you need to upload the Grafana dashboard via the Grafana user interface. You may find the dashboard [here](../monitoring/dashboards/Experimentation%20dashboard.json).


