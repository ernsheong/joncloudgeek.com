---
title: "Talk: Deploying from Jenkins to GKE in Google Cloud"
description: "The nitty-gritty of using Jenkins to deploy to GKE in Google Cloud"
date: 2021-02-17T08:00:00+08:00
images:
- blog/talk-deploying-from-jenkins-to-gke-google-cloud/meta.png
summary: In this talk, I talk about the nitty-gritty of using Jenkins to deploy to GKE in Google Cloud. I cover how to use GKE as the dynamic job runner for your Jenkins jobs. I also explore using Workload Identity to associate a Kubernetes service account with a Google Cloud service account.
draft: false
tags:
  - jenkins
  - gke
  - google cloud
  - "Talks"
toc: false
---

*This talk was presented on Feb 17, 2021 via DevOps Malaysia. Some methods in the talk may have become obsolete or replaced with better best practices*.

## Introduction

In this talk, I talk about the nitty-gritty of using Jenkins to deploy to GKE in Google Cloud. I cover how to use GKE as the dynamic job runner for your Jenkins jobs. I also explore using Workload Identity to associate a Kubernetes service account with a Google Cloud service account.

## Slides

<iframe class="block mb-6" src="https://docs.google.com/presentation/d/e/2PACX-1vSEoqISwkMzEFpVdeaj7WOKXixQ5hMybE7w5cBD4dybrDCdBuSO4vVWpUv7J8BzRs4eZquUYU5_VfaY/embed?start=false&loop=false&delayms=3000" frameborder="0" width="960" height="569" allowfullscreen="true" mozallowfullscreen="true" webkitallowfullscreen="true"></iframe>

## Video

<iframe class="block mb-6" width="560" height="315" src="https://www.youtube.com/embed/YAW1mQ6Qg0E?start=1170" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Resources

- [Demo code on GitHub](https://github.com/ernsheong/jenkins-gke-demo)
- [Installing Jenkins](https://www.jenkins.io/doc/book/installing/)
- [Kubernetes plugin for Jenkins](https://plugins.jenkins.io/kubernetes/)
- [Setting up Jenkins on GKE](https://cloud.google.com/solutions/jenkins-on-kubernetes-engine-tutorial)
- [Continuous deployment to Google Kubernetes Engine using Jenkins](https://cloud.google.com/solutions/continuous-delivery-jenkins-kubernetes-engine)
- [Google Cloud: Get authentication credentials for the cluster](https://cloud.google.com/kubernetes-engine/docs/quickstart#get_authentication_credentials_for_the_cluster)
- [Google Cloud: Using Workload Identity](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity)