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

Both of these tools eliminate the need for separate VMs and avoid the massive overhead of VirtualBox. It is known that developers, using these tools, can bring up a full cluster in seconds using a one-liner. For example, according to the [Loft Labs comparison blog](https://loft.sh/blog/k3d-vs-kind/), k3d starts a cluster up to 3x faster and uses significantly less memory.

This is also supported by academic work such as [“Lightweight Kubernetes for Resource-Constrained Devices: Performance Evaluation of k3s and Alternatives” (arXiv:2504.03656)](https://arxiv.org/pdf/2504.03656), which highlights the performance and usability benefits of container-based Kubernetes solutions like k3s and kind in settings with limited storage and compute capacity.

Plus, as discussed in a [StackOverflow thread](https://stackoverflow.com/questions/66617718/kind-vs-minikube-vs-k3d), developers have found kind and k3d to be better suited for scripting and auotomation.

### Experimenting Plan to See if it Works Better

To test whether switching from Vagrant + VirtualBox to a lightweight container-based Kubernetes setup improves reliability we can test out with the following steps:

1. Remove the current Vagrant and VirtualBox-based setup.
2. Install [`kind`](https://kind.sigs.k8s.io) or [`k3d`](https://k3d.io).
3. Spin up a cluster locally with a single command:

   ```bash
   kind create cluster --name remla-test
   ```
4. Deploy the project using the existing Helm charts (pointing to the local Docker-based cluster).



## Experimental Validation

To validate that this change improves the development experience, we propose the following:

### Hypothesis

Using kind or k3d will reduce setup time and provisioning failure rate significantly.

### Metrics

* Time to first successful deployment 
* Number of provisioning errors encountered during setup


### Experiment Design

* Have a team member to follow the original setup (Vagrant)
* Have a team member to follow the proposed setup (kind/k3d)
* Measure success rate, time taken, and subjective experience


## Conclusion

The current Vagrant + VirtualBox stack seems to be outdated and unsuitable for modern lightweight development (+ a common issue for many developers on stackoverflow). Replacing it with kind or k3d streamlines the development workflow, reduces setup pain, and enables faster experimentation, benefiting both our project and future similar deployments.

