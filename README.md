To reproduce EBUSY issue inside docker for ansible atomic_move, run the following command:

This will reproduce what I consider an issue with ansible service module : if you start
or restart a service with the service module, then running in ansible check mode
on a server for which you do not have installed this service yet, it will fail with error :

    no service or tool found for: <your service>

To reproduce the issue :

```bash
#> docker build .
Sending build context to Docker daemon 3.072 kB
Step 1 : FROM debian:wheezy
 ---> 34a0b91d4fe9
Step 2 : RUN DEBIAN_FRONTEND=noninteractive     apt-get update &&    apt-get -y dist-upgrade
 ---> Using cache
 ---> 9dd8c541a3bf
Step 3 : RUN DEBIAN_FRONTEND=noninteractive     apt-get install python-pip python-dev sudo aptitude git libffi-dev libssl-dev -y
 ---> Using cache
 ---> e7e9ffa579f2
Step 4 : RUN apt-get clean
 ---> Using cache
 ---> cfa62b801b62
Step 5 : RUN pip install PyYAML jinja2 paramiko six ansible
 ---> Using cache
 ---> 0ebc2f82cf5b
Step 6 : COPY apache.yml /tmp/ansible/apache.yml
 ---> Using cache
 ---> 94376059565c
Step 7 : RUN ansible-playbook -i localhost, -c local /tmp/ansible/apache.yml --check
 ---> Running in 2a4607ce62da

PLAY [all] *********************************************************************

TASK [setup] *******************************************************************
ok: [localhost]

TASK [apt] *********************************************************************
changed: [localhost]

TASK [no need but I would like to restart apache] ******************************
fatal: [localhost]: FAILED! => {"changed": false, "failed": true, "msg": "no service or tool found for: apache2"}
        to retry, use: --limit @/tmp/ansible/apache.retry

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=1   

```

