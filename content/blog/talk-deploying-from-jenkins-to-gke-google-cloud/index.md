---
title: "Talk: Deploying from Jenkins to GKE in Google Cloud"
description: "I talk about the nitty-gritty of using Jenkins to deploy to Google Cloud"
date: 2021-02-17T08:00:00+08:00
images:
- blog/talk-deploying-from-jenkins-to-gke-google-cloud/meta.png
summary: In this talk, I talk about the nitty-gritty of using Jenkins to deploy to Google Cloud. I also explore using Workload Identity to associate a Kubernetes service account with a Google Cloud service account.
draft: false
tags:
  - jenkins
  - gke
  - google cloud
toc: false
---
## Introduction

In this talk, I talk about the nitty-gritty of using Jenkins to deploy to GKE in Google Cloud. I also explore using Workload Identity to associate a Kubernetes service account with a Google Cloud service account.

## Slides

<iframe class="block mb-6" src="https://docs.google.com/presentation/d/e/2PACX-1vSEoqISwkMzEFpVdeaj7WOKXixQ5hMybE7w5cBD4dybrDCdBuSO4vVWpUv7J8BzRs4eZquUYU5_VfaY/embed?start=false&loop=false&delayms=3000" frameborder="0" width="960" height="569" allowfullscreen="true" mozallowfullscreen="true" webkitallowfullscreen="true"></iframe>

## Video

<iframe class="block mb-6" width="560" height="315" src="https://www.youtube.com/embed/YAW1mQ6Qg0E?start=1170" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Resources

- [Demo code on GitHub](https://github.com/ernsheong/jenkins-gke-demo)
- [Installing Jenkins](https://www.jenkins.io/doc/book/installing/)
- [Google Cloud: Get authentication credentials for the cluster](https://cloud.google.com/kubernetes-engine/docs/quickstart#get_authentication_credentials_for_the_cluster)
- [Google Cloud: Using Workload Identity](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity)