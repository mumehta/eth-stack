FROM ubuntu:20.04
# Maintainer munishmehta

RUN apt-get update && apt-get install -y openssh-server iputils-ping vim iproute2 net-tools
RUN mkdir /var/run/sshd
RUN echo 'root:P@55w0rd' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
EXPOSE 22 3306 4444 4567 4568

CMD ["/usr/sbin/sshd", "-D"]

