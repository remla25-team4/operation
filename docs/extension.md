# Extension Proposal: Simplifying Local Kubernetes Deployment with Lightweight Alternatives

## Identified Shortcoming

One of the most error-prone aspects of our current project setup is the local deployment of the Kubernetes cluster using Vagrant and VirtualBox, especially in Assignment 2. The process is fragile, resource-intensive, and consistently fails across multiple team members due to factors like:lLimited disk space (as little as 1 GB free space causes complete failure), vagrant provisioning inconsistencies and manual intervention requirements (e.g., `vagrant destroy` + retry cycles).

**Example error messages repeatedly encountered include:**

* `Guest communication could not be established! This is usually because SSH is not running...`
* `No space left on device @ fptr_finalize_flush`
* `fatal: [192.168.56.100] UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: ssh: connect to host 192.168.56.100 port 22: No route to host", "unreachable": true}`
* `Timed out while waiting for the machine to boot. This means that Vagrant was unable to communicate with the guest machine within the configured (\"config.vm.boot_timeout\" value) time period.`
* `dpkg was interrupted, you must manually run 'sudo dpkg --configure -a' to correct the problem.`

This negatively impacts our overall productivity and delays testing and iteration cycles.It created blocked progress on core tasks due to repeated provisioning failures and increased the amount of time wasted debugging unrelated tooling errors rather than focusing on release engineering goals.

## Proposed Extension

Those errors are specific to Vagrant/VirtualBox provisioning (networking, disk space, booting delays). Using kind or k3d bypasses all of that, since the cluster runs directly in Docker on the host. No SSH, no VM boot, no port forwarding, no provisioning steps. We propose to replace the current Vagrant + VirtualBox Kubernetes setup with a lightweight, container-based Kubernetes distribution, such as:

* [k3d](https://k3d.io) — runs [k3s](https://k3s.io) in Docker containers
* [kind](https://kind.sigs.k8s.io) — runs Kubernetes in Docker for CI and development

- Peiro Sajjad et al. (2017) demonstrate that [containers have much lower overhead than virtual machines](https://dl.acm.org/doi/10.1145/3094405.3094409), making them more efficient for development workflows where fast iteration and minimal resource usage are important.

- [kind](https://kind.sigs.k8s.io/) (Kubernetes IN Docker) eliminates the need for full VMs by running Kubernetes clusters in Docker containers, helping avoid common `vagrant up` failures like SSH timeouts (`no route to host`) and disk space issues tied to VirtualBox VM provisioning.

- [k3d](https://k3d.io/) runs lightweight [k3s](https://k3s.io/) Kubernetes clusters inside Docker, making cluster creation faster and reducing the chance of errors caused by heavy virtualization, such as `Vagrantfile` misconfigurations or storage limits on VM disk images.

- This is also supported by academic work such as [“Lightweight Kubernetes for Resource-Constrained Devices: Performance Evaluation of k3s and Alternatives” (arXiv:2504.03656)](https://arxiv.org/pdf/2504.03656), which highlights the performance and usability benefits of container-based Kubernetes solutions like k3s and kind in settings with limited storage and compute capacity.



While this approach does deviate slightly from Assignment 2’s original requirements which use Vagrant to provision actual virtual machines with Ansible the important function is still achieved. . Assignment 2’s guidelines involve provisioning real virtual machines using `vagrant up --provision` and configuring them with Ansible. With k3d or kind, we don’t provision actual VMs, don’t use Ansible, and lose SSH access and OS-level control. However, we still achieve the core learning goal of the assignment: setting up and running a working multi-node Kubernetes cluster locally, just in a lighter, container-based environment with improved speed and stability.

### Experimenting Plan to See if it Works Better

To test whether switching from Vagrant + VirtualBox to a lightweight container-based Kubernetes setup improves reliability we can test out with the following steps:

### Setup

- Host machine: Single machine used for all tests to eliminate hardware variability.

- Allocated resources (Vagrant baseline):
  - 2 vCPUs per VM  
  - 4 GB RAM per VM
  - Resource guidelines from Kublr can  give useful context: ["For a minimal Kublr Platform installation you should have one master node with 4GB memory and 2 CPU and worker node(s) with total 10GB + 1GB × (number of nodes) and 4.4 + 0.5 × (number of nodes) CPU cores."]()

- kind/k3d setup: Uses shared host resources; resource usage monitored via `docker stats`.

### Methadology

- Baseline (Vagrant + VirtualBox):
  - Run `vagrant destroy -f && vagrant up --provision` for each test iteration.
  - After successful setup, verify Kubernetes is working with `kubectl get nodes`.
  - Record time from `vagrant up` to successful node readiness.

- Alternative (kind/k3d):
  - Run `kind create cluster` or `k3d cluster create`.
  - Deploy Helm charts as with the baseline.
  - Record time from cluster creation to successful `kubectl get nodes`.

- Repetitions: Repeat each setup 5 times to account for variation.

### Metrics

- Average time to first successful `kubectl get nodes`
- Standard deviation of setup time
- Number of provisioning errors (per run)
- Subjective feedback on clarity/frustration level (rated 1–5)

### Analysis

- Report mean with standard deviation for setup time
- Compare setups using a basic paired t-test (if assumptions met) or descriptive comparison
- Discuss setup trade-offs based on logs and observationsovisioning errors encountered during setup


### Experiment Design

* Use a single machine to eliminate hardware variation as a fator.
* Run the baseline setup (Vagrant + Ansible) and the proposed setup (kind or k3d) sequentially on the same host.
* Measure time taken from initial setup to successful `kubectl get nodes`.
* Take not of any errors or interruptions found during provisioning.


## Conclusion

The current Vagrant + VirtualBox stack seems to be outdated and unsuitable for modern lightweight development (+ a common issue for many developers on stackoverflow). Replacing it with kind or k3d streamlines the development workflow, reduces setup pain, and enables faster experimentation, benefiting both our project and future similar deployments.

