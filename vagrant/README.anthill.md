# Hacking/Demo on Anthill

1. `./up.sh`
2. `./anthill.sh`
3. `vagrant ssh master -c "sudo su"`
   1. `cd ~/anthill/hack/deploy`
   2. `./deploy.sh`
   3. `cd ~/gluster-csi-driver/pkg/glusterfs/deploy/kubernetes`
   4. `for yaml in *; do kubectl create -f $yaml; done`
