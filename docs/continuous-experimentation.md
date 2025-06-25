# Experiment

The aim of our experiment is to improve the user experience by bringing a more intuitive look to the user interface (UI). To do so, we:
- Switch the button colour to yellow
- Make the button smaller
- Place it on the right hand side of the text box

To test if our implementation is more intuitive, we measure if users click the new button interface more quickly than previously.

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

TODO: put screenshot of grafana dashboard here

## Acceptance Critera
We will accept the `Canary version` if and only if it provides an average decrease of 20% to the `average_time_to_click_seconds` metric.


## Trying out the Experiment
To try out the experiment, you need to upload the Grafana dashboard via the Grafana user interface. You may find the dashboard [here](../monitoring/dashboards/Experimentation%20dashboard.json).


