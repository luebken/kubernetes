# Custom Guestbook example 

This example shows how to build you own Guestbook image and deploy it into Kubernetes.

For a detailed description of the Guestbook example the [README.md](README.md) and [_src/README.md](_src/README.md)

> Note: Currently this is a rough TLDR version with just the commands. If there is interest a detailed version might be added later. Please comment here: https://github.com/luebken/kubernetes/pull/1

## Prerequisites

* Have a Kubernetes cluster running. e.g. with Vagrant
* Have Docker running and an Docker Hub account
* For ease of use have github.com/andreasjansson/envtpl installed


## Create the Redis master

    # create the replication controller
    $ kubectl create -f redis-master-controller.yml
    replicationcontrollers/redis-master
    # create the service
    $ kubectl create -f redis-master-service.yml
	service "redis-master" created

## Create the Redis slave

    # create the replication controller
    $ kubectl create -f redis-slave-controller.yml
	replicationcontroller "redis-slave" created
    # kubectl create -f redis-slave-service.yml
	service "redis-slave" created

## Build the guestbook image

	cd _src
	# change something in the guestbook image e.g. change the <title> in the index.html
	sed -i '' 's/Guestbook/My-Oh-My-Guestbook/' public/index.html
	# build and push the guestbook image. replace `luebken` with your docker username
	cd _src
	./script/release.sh latest luebken
	cd ..

## Create guestbook controller
	
	# replace {{ USERNAME }} in `guestbook-controller.yml.tpl` and save to `guestbook-controller.yml`
	# e.g. with github.com/andreasjansson/envtpl
	USERNAME=luebken envtpl < guestbook-controller.yml.tpl > guestbook-controller.yml
	$ kubectl create -f guestbook-controller.yml
	replicationcontroller "guestbook" created


## Create the guestbook service for Vagrant
	
	# replace {{ SERVICE_TYPE }} in `guestbook-service.yml.tpl` and save to guestbook-service.yml
	# e.g. with github.com/andreasjansson/envtpl
	SERVICE_TYPE=NodePort envtpl < guestbook-service.yml.tpl > guestbook-service.yml
	$ kubectl create -f guestbook-service.yml
	You have exposed your service on an external port on all nodes in your
	cluster.  If you want to expose this service to the external internet, you may
	need to set up firewall rules for the service port(s) (tcp:30423) to serve traffic.

	See http://releases.k8s.io/release-1.1/docs/user-guide/services-firewalls.md for more details.
	service "guestbook" created

## Expose the guestbook out of Vagrant
		
	# get the minion virtualbox name
	$ VBoxManage list vms
	"kubernetes-117_master_1455702219437_34697" {6003e484-4333-42de-aa24-359cbf1d67e6}
	"kubernetes-117_minion-1_1455702358000_49974" {779dc587-c927-4d7c-8330-edfccb2e968f}
	# expose the port from the service above
	VBoxManage controlvm kubernetes-117_minion-1_1455702358000_49974 natpf1 rule1,tcp,,30423,,30423

## Verify

	# open app in browser
	$ open http://localhost:30423
	# debug / verify
	$ kubectl get svc
	...
	$ kubectl get rc
	...
	$ kubectl get pods
	...
    $ kubectl describe pods guestbook