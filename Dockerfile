FROM julia:0.6.2


MAINTAINER Naelson Douglas

# Julia
#RUN wget https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.2-linux-x86_64.tar.gz
#RUN tar -xvf julia*.tar.gz
#RUN rm julia*.tar.gz
#RUN mv julia* julia
#RUN mv julia ~/julia
#RUN export PATH=$PATH:/root/julia/bin

#RUN apt-get install -y cmake 
#RUN apt-get install -y hdf5-tools

# Docker
RUN apt update
RUN apt install -y hdf5-tools
RUN apt install -y libgomp1
RUN apt install -y python-pip
RUN pip install scikit-learn
RUN pip install tabulate
#RUN apt-get install -y apt-transport-https ca-certificates curl software-properties-common
#RUN apt-get install -y apt-transport-https ca-certificates 
#RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
#RUN apt-key fingerprint 0EBFCD88
#RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
#RUN apt update
#RUN apt-get install -y docker-ce

# sshd 
 RUN apt-get install -y openssh-server
 RUN mkdir /var/run/sshd \
	 && echo 'AuthorizedKeysFile %h/.ssh/authorized_keys' >> /etc/ssh/sshd_config \
     && sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd \
     && sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
     && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
	 && echo 'root:root' |chpasswd
 EXPOSE 22
 CMD    ["/usr/sbin/sshd", "-D"]
 # SSH key
RUN ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa -q -N ""
#RUN mkdir -p $HOME/.ssh \
#	&& chmod 700 $HOME/.ssh \
RUN cat $HOME/.ssh/id_rsa.pub > $HOME/.ssh/authorized_keys \
	&& chmod 600 $HOME/.ssh/authorized_keys 

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

#TODO uncomment the first comment column
# #
# # DML stuff
# #
#RUN git clone https://github.com/NaelsonDouglas/DistributedMachineLearningThesis.git
# # adding packages
RUN julia -e 'Pkg.add("CSV")'
RUN julia -e 'Pkg.add("DataFrames")'
RUN julia -e 'Pkg.add("Clustering")'
RUN julia -e 'Pkg.add("Distributions")'
RUN julia -e 'Pkg.add("MultivariateStats")'
RUN julia -e 'Pkg.add("Debug")'
RUN julia -e 'Pkg.add("HDF5")'
RUN julia -e 'Pkg.add("Mocha")'
RUN julia -e 'Pkg.add("DataFrames")'
RUN julia -e 'Pkg.add("Distances")'
RUN julia -e 'Pkg.add("Logging")'
RUN julia -e 'Pkg.add("ArgParse")'
RUN julia -e 'Pkg.add("Stats")'
RUN julia -e 'Pkg.add("Graphs")'
RUN julia -e 'Pkg.add("LightGraphs")'
# # pinning packages
RUN julia -e 'Pkg.pin("CSV", v"0.2.5")'
RUN julia -e 'Pkg.pin("DataFrames", v"0.11.7")'
RUN julia -e 'Pkg.pin("Mocha", v"0.3.1")'
RUN julia -e 'Pkg.pin("Clustering", v"0.7.0")'
RUN julia -e 'Pkg.pin("MultivariateStats", v"0.3.0")'
RUN julia -e 'Pkg.pin("Debug", v"0.1.5")'
RUN julia -e 'Pkg.pin("Distributions", v"0.15.0")'
#TODO Pkg.clone("https://github.com/ararslan/OperatingSystems.jl.git")

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/root/julia/bin/"
CMD ["/usr/sbin/sshd", "-D"]
