FROM golang:1.16-alpine3.14

ENV TERRAFORM_VERSION=1.0.4

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh build-base
RUN cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin
