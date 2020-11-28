FROM ubuntu:latest

RUN apt update
RUN apt install -y curl gnupg2 ca-certificates lsb-release
RUN echo "deb http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list
RUN curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
RUN apt-key fingerprint ABF5BD827BD9BF62
RUN apt update
RUN apt install -y nginx

WORKDIR /root

EXPOSE 80

COPY ./html /usr/share/nginx/html

ENTRYPOINT ["nginx", "-g", "daemon off;"]
