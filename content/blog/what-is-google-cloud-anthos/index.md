---
title: "What Is Anthos? [Google Cloud]"
date: 2019-09-27T15:37:50+08:00
draft: false
tags:
  - google cloud
  - anthos
---

{{< figure src="./anthos-bridge-between-on-prem-and-gcp.jpg" alt="Anthos, the bridge between on-prem and Google Cloud" caption="Anthos, the bridge between on-prem and Google Cloud" >}}

## Introduction

It's no secret that Google Cloud is still catching up with AWS and Azure in terms of market share. [Anthos](https://cloud.google.com/anthos/), first announced at Google Cloud Next in April 2019, is Google Cloud's gambit to gain market share in the enterprise.

Even as of this year, [80% of workloads are still on-premises](https://www.ibm.com/blogs/cloud-computing/2019/03/05/20-percent-cloud-transformation/). With Anthos, Google is hitting this need by giving enterprises a _uniform interface_ that abstracts away the complexity of deploying to on-premises and/or in the cloud.

In other words, Anthos is [Google Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine) deployed either on-premises or in the cloud (including third-party clouds like AWS and Azure). As far as enterprise developers are concerned, everything should be running on containers, and where these containers end up at (on-premises or cloud) is just a matter of configuration on Anthos. It brings enterprises toward the utopia of write once, run anywhere, without learning diffirent environments and APIs.

## Anthos Components

Anthos is really a branding name for a collection of software components rather than a piece of software by itself. Collectively, the components work together to achieve the above. Let's take a look at the components that make up Anthos (according to their [documentation](https://cloud.google.com/anthos/docs/components)):

1. **GKE On-Prem**<br>
I'll let the docs speak for itself: "GKE On-Prem is hybrid cloud software that brings Google Kubernetes Engine (GKE) to on-premises data centers. With GKE On-Prem, you can create, manage, and upgrade Kubernetes clusters in your on-prem environment and connect them to Google Cloud Platform Console." (https://cloud.google.com/gke-on-prem/docs/overview)
1. **GKE**<br>
GKE is Google Cloud's managed Kubernetes offering. Given that Kubernetes originated from Google, GKE is one of the best managed offerings for Kubernetes out there.
1. **Migrate for Anthos**<br>
"A tool to containerize existing applications to run on GKE." Basically a fancy name for scripts that help you generate Kubernetes yaml configs for your existing VMs.
1. **Multi-cluster management overview**<br> A lacklustre name to represent a collection of tools to connect between your GKE On-Prem with other clusters on the Google Cloud Platform.
1. **Anthos Config Management**<br> The one configuration to rule over Kubernetes clusters both on-premises and in the cloud.
1. **Istio**<br>"Istio is an open platform to connect, secure, control, and monitor microservices." (https://cloud.google.com/istio/docs/)
1. **Stackdriver**<br>Google Cloud's managed logging and monitoring solution.
1. **Cloud Run**<br>Deploy serverless containers. In the context of Anthos, you can deploy your serverless containers to GKE On-Prem or in the cloud.
1. **Kubernetes apps on GCP Marketplace**<br>You can even install Kubernetes containers found in GCP Marketplace to your GKE On-Prem.
1. **Traffic Director**<br>GCP's fully-managed traffic control plane for service meshes. This gives you an idea of what it does: "Traffic Director allows you to easily deploy global load balancing across clusters and VM instances in multiple regions and offload health checking from the sidecar proxies" (https://cloud.google.com/traffic-director/docs/traffic-director-concepts)

## Pricing

Here's where we get into the juicier parts of the discussion. The [Anthos Pricing page](https://cloud.google.com/anthos/pricing/) redirects to "Contact sales". That implies $$$$.

However, in [Anthos FAQ](https://cloud.google.com/anthos/docs/faq/), we get an indication of the pricing:

> Anthos will be available to enterprises via a term-based monthly subscription, entitling users to ongoing updates and security patches across hybrid environments.

> Anthos can be purchased in blocks of 100 vCPUs requiring a minimum one year term (at $100 per vCPU/month). These vCPUs can be allocated in any combination across environments. Please contact sales for pricing.

> The pricing listed above is in addition to core infrastructure charges including, but not limited to CPU, networking, infrastructure support, etc.

In other words, it starts from **$10,000 per month**.

There's a problem with that. I think that even the largest of Malaysian enterprises would not want to spend RM45,000/month on something like this. The target market for Anthos is not just enterprise, but enterprise with a big E, for which $10,000/month is pocket change. Think the likes of HSBC, which Google shows off as an early customer in the [Anthos launch blog post](https://cloud.google.com/blog/topics/hybrid-cloud/new-platform-for-managing-applications-in-todays-multi-cloud-world)

## The Good

The promise of Anthos sounds compelling, but I can't speak on behalf of Enterprise.

Writing once and running it anywhere you choose, here today, there tomorrow, and back here again the day after, is now possible with Anthos. Enterprises can plan out their timelines for gradual migration to the cloud, while maintaining the ability to keep workloads on-premises for compliance and other reasons.

And they can now do all this using the cutting-edge managed Kubernetes offering from Google, with Istio and other bells and whistles, while maintaining presence on-premises. It's an enterprise's dream, perhaps?

## The Bad

### Cloud Run on GKE is no more?

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">What&#39;s the verdict now? Lay devs can&#39;t run Cloud Run in their own GKE cluster without an Anthos subscription? Not sure if many are affected, but the choice was nice to have, and now gone?</p>&mdash; Jonathan Lin 👨🏻‍💻🇲🇾 (@ernsheong) <a href="https://twitter.com/ernsheong/status/1177415240092241921?ref_src=twsrc%5Etfw">September 27, 2019</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

When Cloud Run was announced, it had an option in the Console to deploy to "Cloud Run on GKE". Today, it just says "Cloud Run for Anthos". Cloud Run is in Beta, so Google has the right to make such changes, but the trend seems to be making the add-on features of GKE a part of Anthos, which presumably requires a subscription of some sort (this is unclear in the documentation).

{{< figure src="./cloud-run-for-anthos.png" alt="Cloud Run for Anthos" width="500" caption="You must have Cloud Run for Anthos enabled in your cluster. Do I have to pay for that?" >}}

### Binary Authorization, not available on GKE

With [Binary Authorization](https://cloud.google.com/binary-authorization/), images are to be signed by trusted authorities during development, and these signatures are validated on deployment. This was touted as a security feature at a local Cloud Summit event recently. But it seems clear right now that this feature will only be part of an Anthos subscription:

> The General Availability (GA) version of Binary Authorization is a feature of the Anthos platform. Use of Binary Authorization is included in the Anthos subscription. Please contact your sales representative to enroll in Anthos.

### A bad sign for GKE and GCP

All these does not harbinger well for GKE itself. Google wants to reach out to the Enterprise, but it should _not_ alienate non-Enterprise users who are already champions of GKE as the best managed Kubernetes offering. Granted, you can't really make everyone happy all the time, but taking away or limiting features from the vanilla GKE core is a bad taste that makes us think twice about recommended GKE to others.

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">GCP is treading dangerously. IMO, purely-GKE customers (no on-prem) should not be subject to the “Anthos tax”. Withholding features in Anthos from purely-GKE customers is a slippery slope that might backfire as people realize GKE itself is handicapped on purpose.</p>&mdash; Jonathan Lin 👨🏻‍💻🇲🇾 (@ernsheong) <a href="https://twitter.com/ernsheong/status/1177455606589878272?ref_src=twsrc%5Etfw">September 27, 2019</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## Comparison with AWS and Azure offerings

A great topic for another blog post. Stay tuned!

## Summary

Anthos is Google Cloud's gambit to lure enterprises to use Google Cloud with a single consistent interface for application deployment to both on-premises or in the cloud. Google Cloud is betting that containers will be king in the enterprise world. If Google is right, the rewards via Anthos are great, and Anthos has the potential to be the Trojan Horse of the cloud wars.

At the same time, with Anthos, Google Cloud risks alienating users of GKE by withholding Anthos-only features from GKE users. GKE is one of Google Cloud's strongest offerings. Google Cloud should not handicap GKE in other to hide features behind Anthos.

## Relevant Links

1. What’s Going on with GKE and Anthos? https://bravenewgeek.com/whats-going-on-with-gke-and-anthos/
1. Everything You Want To Know About Anthos - Google's Hybrid And Multi-Cloud Platform https://www.forbes.com/sites/janakirammsv/2019/04/14/everything-you-want-to-know-about-anthos-googles-hybrid-and-multi-cloud-platform/
1. Introducing Anthos: An entirely new platform for managing applications in today's multi-cloud world https://cloud.google.com/blog/topics/hybrid-cloud/new-platform-for-managing-applications-in-todays-multi-cloud-world
1. Anthos simplifies application modernization with managed service mesh and serverless for your hybrid cloud https://cloud.google.com/blog/topics/hybrid-cloud/anthos-simplifies-application-modernization-with-managed-service-mesh-and-serverless-for-your-hybrid-cloud