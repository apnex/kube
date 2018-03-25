#!/bin/bash
#curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt
#docker pull gcr.io/google_containers/hyperkube:v1.1.2
echo 1 > /proc/sys/vm/overcommit_memory
echo 1 > /proc/sys/kernel/panic_on_oops
echo 10 > /proc/sys/kernel/panic
swapoff -a
source <(kubectl completion bash)

#gcr.io/google_containers/etcd:3.2.14 \
docker run -d \
    --net=host \
    gcr.io/google_containers/etcd:2.0.9 \
    /usr/local/bin/etcd \
        --addr=127.0.0.1:4001 \
        --bind-addr=0.0.0.0:4001 \
        --data-dir=/var/etcd/data

#   -v /var/run/docker.sock:/var/run/docker.sock \

docker run -d \
	--net=host \
	--privileged \
	--volume=/sys:/sys:rw \
	--volume=/sys/fs/cgroup:/sys/fs/cgroup:rw \
	--volume=/:/rootfs:ro \
	--volume=${PWD}/master.json:/etc/kubernetes/manifests/master.json:ro \
	--volume=${PWD}/kubeconfig.cfg:/tmp/kubeconfig.cfg:ro \
	--volume=/var/lib/docker/:/var/lib/docker:rw \
	--volume=/var/lib/kubelet/:/var/lib/kubelet:rw \
	--volume=/var/run:/var/run:rw \
gcr.io/google_containers/hyperkube:v1.9.3 \
/hyperkube kubelet \
	--containerized \
	--kubeconfig=/tmp/kubeconfig.cfg \
	--require-kubeconfig \
	--pod-manifest-path=/etc/kubernetes/manifests \
	--cgroups-per-qos=false \
	--enforce-node-allocatable="" \
	--runtime-cgroups=/systemd/system.slice \
	--kubelet-cgroups=/systemd/system.slice \
	--allow-privileged=true \
	--cgroup-driver=systemd \
	--fail-swap-on=false \
	--v=4 \
	--address=0.0.0.0 \
	--enable-server \
	--hostname-override=127.0.0.1

docker run -d \
	--net=host \
	--privileged \
	-v /lib/modules/4.13.16-100.fc25.x86_64:/lib/modules/4.13.16-100.fc25.x86_64:ro \
	-v /var/run/dbus:/var/run/dbus:ro \
gcr.io/google_containers/hyperkube:v1.9.3 \
/hyperkube proxy \
        --master=http://127.0.0.1:8080 \
	--proxy-mode=iptables \
        --v=4
