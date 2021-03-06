#!/bin/bash -ex

version_tag() {
  if [ ! "${VERSION_TAG+x}" = "x" ] ; then git --git-dir "${KUBE_ROOT:-../}/.git" describe; fi
}

conf=($(docker-machine config "hyperquick-${1:-"1"}"))

exec docker "${conf[@]}" run --tty --interactive \
  --net=host --pid=host --privileged=true \
  --volume=/var/run/docker.sock:/var/run/docker.sock:rw \
  --volume=/var/lib/docker:/var/lib/docker:rw \
  --volume=/dev:/dev \
  --volume=/sys:/sys:ro \
  --volume=/var/run:/var/run:rw \
  --volume=/run:/run:rw \
    "errordeveloper/hyperquick:node-$(version_tag)" \
      --api-servers="https://10.99.0.254:443" \
      --kubeconfig="/etc/kubernetes/kubelet.conf" \
      --request-tls-cert=true --cert-dir=/tmp --v=9
