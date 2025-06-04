# Extension Proposal: Simplifying Local Kubernetes Deployment with Lightweight Alternatives

### Team 4

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

For our experiment, we want to be testing the following things:
- Setup time and reliability
- User Experience


### Setup

- Host machine: Single machine used for all tests to eliminate hardware variability.
- The machine should have more than sufficient memory (> 12 GB RAM, >6 CPU cores) to run both setups without running into resource constraints.

Baseline Configuration
  - 3 nodes (ctrl + node 1 + node 2 like in the assignments)
  - 2 vCPUs per VM  
  - 4 GB RAM per VM

Test Configuration
  - One configuration for kind and another for k3d. Each test also includes 3 nodes (ctrl + node 1 + node 2)
  - Resource guidelines from Kublr can  give useful context: ["For a minimal Kublr Platform installation you should have one master node with 4GB memory and 2 CPU and worker node(s) with total 10GB + 1GB × (number of nodes) and 4.4 + 0.5 × (number of nodes) CPU cores."](https://docs.kublr.com/installation/hardware-recommendation/)
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

- Repeat each setup at least 30 times to get a robust set of measurements that accounts for any variation in the results.

### Metrics

- `Setup time` per iteration: time taken (s) for all nodes to join the cluster and become ready
- `Average setup time`: Mean time taken (s) for all nodes to join the cluster and become ready over 30 iterations
- `Standard deviation setup time`: Standard deviation of time taken (s) for all nodes to join the cluster and become ready over 30 iterations
- `# provisioning failures per configuration`: Count of iterations that did not complete successfully on its own
- `Completion Rate per configuration (%)`: (Number of successful iterations / 30) * 100.
- `Error logs`: Any error messages encountered during setup
- `Subjective Feedback (Average rating)`: The tester provides a rating (1-5 scale, where 1 = Very Frustrating/Difficult, 5 = Very Smooth/Easy) for the setup experience of each iteration, this is then averaged over 30.

### Next steps

- Report the above metrics collected from the baseline and alternative setups.
- Compare setups using a basic paired t-test between numerical results from the baseline and alternative setups.
- Discuss any additional observations or qualitative feedback from our testers.
- Conclude whether switching to kind or k3d is beneficial for our project and whether it should be recommended for future assignments.

## Conclusion

The current Vagrant + VirtualBox stack seems to be outdated and unsuitable for modern lightweight development (+ a common issue for many developers on stackoverflow). Replacing it with kind or k3d has the potential to streamline the development workflow, reduce setup troubles, and enables faster experimentation, benefiting both our project and similar future deployments.


