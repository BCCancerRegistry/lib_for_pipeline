FROM nvidia/cuda:11.1.1-base-ubi8
FROM apache/airflow:2.7.2
ARG VERSION=1.0.14
COPY BCCancer-${VERSION}-py3-none-any.whl /tmp/
RUN pip install /tmp/BCCancer-${VERSION}-py3-none-any.whl
RUN pip install --force-reinstall torch>=2.0.1+cu117 --extra-index-url https://download.pytorch.org/whl/cu117
#USER root
#RUN curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc

#Debian 11
#RUN curl https://packages.microsoft.com/config/debian/11/prod.list | tee /etc/apt/sources.list.d/mssql-release.list

#RUN apt-get update &&  ACCEPT_EULA=Y apt-get install -y msodbcsql17 &&  ACCEPT_EULA=Y apt-get install -y mssql-tools && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && source ~/.bashrc &&  apt-get install -y unixodbc-dev &&  apt-get install -y libgssapi-krb5-2
#RUN apt install -y krb5-config
#RUN apt-get install -y krb5-user
#COPY krb5.conf /etc/krb5.conf
