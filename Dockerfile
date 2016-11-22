FROM debian:wheezy

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update &&\
    apt-get -y dist-upgrade

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install python-pip python-dev sudo aptitude git libffi-dev libssl-dev -y

RUN apt-get clean
RUN pip install PyYAML jinja2 paramiko six ansible

COPY apache.yml /tmp/ansible/apache.yml
RUN ansible-playbook -i localhost, -c local /tmp/ansible/apache.yml --check
