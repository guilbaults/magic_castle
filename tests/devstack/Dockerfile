FROM centos:7
RUN yum -y install epel-release; \
yum -y install golang curl bats sshpass git jq wget unzip; \
yum clean all;
RUN wget -q https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip; \
unzip terraform_0.12.20_linux_amd64.zip; \
mv terraform /usr/local/sbin
