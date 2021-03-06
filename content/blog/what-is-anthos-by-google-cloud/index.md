---
title: "What is Anthos by Google Cloud?"
description: "Anthos is Google Cloud’s gambit to gain market share in the enterprise."
date: 2019-09-27T15:37:50+08:00
images:
- blog/what-is-anthos-by-google-cloud/anthos-bridge-between-on-prem-and-gcp.jpg
summary: Anthos is Google Kubernetes Engine (GKE) deployed to both on-premises or in the cloud. But it comes with an enterprise-only price tag.
draft: false
tags:
  - google cloud
  - anthos
---

{{< figure src="./anthos-bridge-between-on-prem-and-gcp.jpg" alt="Anthos, the bridge between on-prem and Google Cloud" caption="Anthos, the bridge between on-prem and Google Cloud." >}}

## Introduction

It's no secret that Google Cloud is still catching up with AWS and Azure in terms of market share. [Anthos](https://cloud.google.com/anthos/), first announced at Google Cloud Next in April 2019, is Google Cloud's gambit to gain market share in the enterprise.

Even as of this year, [80% of workloads are still on-premises](https://www.ibm.com/blogs/cloud-computing/2019/03/05/20-percent-cloud-transformation/). With Anthos, Google is hitting this need by giving enterprises a _uniform interface_ that abstracts away the complexity of deploying to on-premises and/or in the cloud.

In other words, Anthos is [Google Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine) deployed either on-premises or in the cloud (including third-party clouds like AWS and Azure). As far as enterprise developers are concerned, everything should be running on **containers**, and where these containers end up at (on-premises or cloud) is just a matter of configuration on Anthos. It brings enterprises toward the utopia of write once, run anywhere, without learning diffirent environments and APIs.

{{< figure src="./anthos.png" alt="Anthos by Google Cloud" caption="Anthos by Google Cloud" width="300" >}}

## Anthos Components

Anthos is really a **branding name for a collection of software components** rather than a piece of software by itself. Collectively, the components work together to achieve the above. Let's take a look at the components that make up Anthos (according to their [documentation](https://cloud.google.com/anthos/docs/components)):

* **GKE On-Prem**. "GKE On-Prem is hybrid cloud software that brings Google Kubernetes Engine (GKE) to on-premises data centers. With GKE On-Prem, you can create, manage, and upgrade Kubernetes clusters in your on-prem environment and connect them to Google Cloud Platform Console." (https://cloud.google.com/gke-on-prem/docs/overview)

* **GKE**. GKE is Google Cloud's managed Kubernetes offering. Given that Kubernetes originated from Google, GKE is arguably the best managed offering for Kubernetes out there.

* **Migrate for Anthos**. "A tool to containerize existing applications to run on GKE." Basically a fancy name for scripts that help you generate Kubernetes yaml configs for your existing VMs.

* **Multi-cluster management overview**. A lacklustre name to represent a collection of tools to connect between your GKE On-Prem with other clusters on the Google Cloud Platform.

* **Anthos Config Management**. The one configuration to rule over Kubernetes clusters both on-premises and in the cloud.

* **Istio**. "Istio is an open platform to connect, secure, control, and monitor microservices." (https://cloud.google.com/istio/docs/)

* **Stackdriver**. Google Cloud's managed logging and monitoring solution.

* **Cloud Run**. Deploy serverless containers. In the context of Anthos, you can deploy your serverless containers to GKE On-Prem or in the cloud.

* **Kubernetes apps on GCP Marketplace**. You can even install Kubernetes containers found in GCP Marketplace to your GKE On-Prem.

* **Traffic Director**. GCP's fully-managed traffic control plane for service meshes. This gives you an idea of what it does: "Traffic Director allows you to easily deploy global load balancing across clusters and VM instances in multiple regions and offload health checking from the sidecar proxies" (https://cloud.google.com/traffic-director/docs/traffic-director-concepts)


## Technicals

GKE On-Prem requires a VMware vSphere environment, along with a layer 4 network load balancer.

As for site-to-site connection between on-premises and cloud, the options are either Cloud VPN, Dedicated Interconnect or Partner Interconnect.

## Pricing

Here's where we get into the juicier parts of the discussion. The [Anthos Pricing page](https://cloud.google.com/anthos/pricing/) redirects to "Contact sales". That implies $$$$.

However, in [Anthos FAQ](https://cloud.google.com/anthos/docs/faq/), we get an indication of the pricing:

> Anthos will be available to enterprises via a term-based monthly subscription, entitling users to ongoing updates and security patches across hybrid environments.

> Anthos can be purchased in blocks of 100 vCPUs requiring a minimum one year term (at $100 per vCPU/month). These vCPUs can be allocated in any combination across environments. Please contact sales for pricing.

> The pricing listed above is in addition to core infrastructure charges including, but not limited to CPU, networking, infrastructure support, etc.

In other words, it starts from **$10,000 per month**.

There's a problem with that. I think that even the largest of Malaysian enterprises would not want to spend RM45,000/month on something like this. The target market for Anthos is not just enterprise, but enterprise with a big E, for which $10,000/month is pocket change. Think the likes of HSBC, which Google shows off as an early customer in the [Anthos launch blog post](https://cloud.google.com/blog/topics/hybrid-cloud/new-platform-for-managing-applications-in-todays-multi-cloud-world).

## The Good

The promise of Anthos sounds compelling, but I can't speak on behalf of Enterprise.

### No new hardware necessary

Anthos is a software solution. Companies do not need to buy hardware from Google in order to leverage Anthos. They can start with their existing on-premises machines.

### On-Premises

Writing once and running it anywhere you choose, here today, there tomorrow, and back here again the day after, is now possible with Anthos. Enterprises can plan out their timelines for gradual migration to the cloud, while maintaining the ability to keep workloads on-premises for compliance and other reasons.

And they can now do all this using the cutting-edge managed Kubernetes offering from Google, with Istio and other bells and whistles, while maintaining presence on-premises. It's an enterprise's dream, perhaps?

### Development and Operations

Developers get to run GKE on-premises. Operations gets a single unified dashboard and configuration for their applications, not to mention a whole lot less work mitigating server problems given that Kubernetes is more robust and has self-healing and auto-scaling capabilities.

### Security

Anthos Config Management allows centralized cluster configuration. Istio provides code-free securing of microservices.

## The Bad

### GKE vs Anthos Lines Blurred

Over the past few weeks the lines between what is GKE and what is Anthos have blurred. It seems that some parts of GKE have been absorbed into Anthos and placed behind the Anthos paywall, such as the examples shown below. I believe that at this stage, GCP is still trying to figure out the exact pricing of GKE add-ons for non-Anthos users, but it could also be the case that GCP effectively draws a strict line between vanilla GKE and Anthos-branded GKE add-ons, requiring payment to use the latter.

### Cloud Run on GKE is no more?

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">What&#39;s the verdict now? Lay devs can&#39;t run Cloud Run in their own GKE cluster without an Anthos subscription? Not sure if many are affected, but the choice was nice to have, and now gone?</p>&mdash; Jonathan Lin 👨🏻‍💻🇲🇾 (@ernsheong) <a href="https://twitter.com/ernsheong/status/1177415240092241921?ref_src=twsrc%5Etfw">September 27, 2019</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

When Cloud Run was announced, it had an option in the Console to deploy to "Cloud Run on GKE". Today, it just says "Cloud Run for Anthos". Cloud Run is in Beta, so Google has the right to make such changes, but the trend seems to be making the add-on features of GKE a part of Anthos, which presumably requires a subscription of some sort (this is unclear in the documentation).

{{< figure src="./cloud-run-for-anthos.png" alt="Cloud Run for Anthos" width="500" caption="You must have Cloud Run for Anthos enabled in your cluster. Do I have to pay for that?" >}}

### Binary Authorization, not available on GKE without Anthos?

With [Binary Authorization](https://cloud.google.com/binary-authorization/), images are to be signed by trusted authorities during development, and these signatures are validated on deployment. This was touted as a security feature at a local Cloud Summit event recently. But it seems clear right now that this feature will only be part of an Anthos subscription:

> The General Availability (GA) version of Binary Authorization is a feature of the Anthos platform. Use of Binary Authorization is included in the Anthos subscription. Please contact your sales representative to enroll in Anthos.

### A bad sign for GKE and GCP

All these does not harbinger well for GKE itself. Google wants to reach out to the Enterprise, but it should _not_ alienate non-Enterprise users who are already champions of GKE as the best managed Kubernetes offering. Granted, you can't really make everyone happy all the time, but taking away or limiting features from the vanilla GKE core is a bad taste that makes us think twice about recommended GKE to others.

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">GCP is treading dangerously. IMO, purely-GKE customers (no on-prem) should not be subject to the “Anthos tax”. Withholding features in Anthos from purely-GKE customers is a slippery slope that might backfire as people realize GKE itself is handicapped on purpose.</p>&mdash; Jonathan Lin 👨🏻‍💻🇲🇾 (@ernsheong) <a href="https://twitter.com/ernsheong/status/1177455606589878272?ref_src=twsrc%5Etfw">September 27, 2019</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## Comparison with AWS and Azure offerings

From what I gather, the VMware vSphere requirement plays well with existing setups on-premises. In other words, customers would not need to purchase new hardware in order to leverage Anthos.

In contrast, [AWS Outposts](https://aws.amazon.com/outposts/) and [Azure Stack](https://azure.microsoft.com/en-us/overview/azure-stack/) require you to purchase hardware from AWS or Azure in order to leverage their hybrid cloud solutions.

AWS Outposts [FAQs](https://aws.amazon.com/outposts/faqs/):

> Q: Can I reuse my existing servers in an Outpost?

> A: No, AWS Outposts leverages AWS designed infrastructure, and is only supported on proprietary AWS hardware that is optimized for secure, high-performance, and reliable operations.

Azure Stack - [How to Buy](https://azure.microsoft.com/en-us/overview/azure-stack/how-to-buy/):

> Azure Stack is sold as an integrated hardware system, with software pre-installed on validated hardware.

However, it seems that with AWS Outposts and Azure Stack you can use many more service offerings from AWS and Azure, whilst with Anthos you are limited to basically GKE On-Prem and GKE itself.

## Summary

Anthos is Google Cloud's gambit to lure enterprises to use Google Cloud with a single consistent interface for application deployment to both on-premises or in the cloud. Google Cloud is betting that containers will be king in the enterprise world. If Google plays it right, the rewards via Anthos will be great, and Anthos has the potential to be the Trojan Horse of the cloud wars.

At the same time, with Anthos, Google Cloud risks alienating users of GKE by withholding Anthos-only features from GKE users. GKE is one of Google Cloud's strongest offerings. Google Cloud should not handicap GKE in other to hide features behind Anthos.

## Related Links

* What’s Going on with GKE and Anthos? https://bravenewgeek.com/whats-going-on-with-gke-and-anthos/
* Everything You Want To Know About Anthos - Google's Hybrid And Multi-Cloud Platform https://www.forbes.com/sites/janakirammsv/2019/04/14/everything-you-want-to-know-about-anthos-googles-hybrid-and-multi-cloud-platform/
* How Google’s Anthos Is Different from AWS and Azure Hybrid Clouds https://www.datacenterknowledge.com/google-alphabet/how-google-s-anthos-different-aws-and-azure-hybrid-clouds
* Introducing Anthos: An entirely new platform for managing applications in today's multi-cloud world https://cloud.google.com/blog/topics/hybrid-cloud/new-platform-for-managing-applications-in-todays-multi-cloud-world
* Anthos simplifies application modernization with managed service mesh and serverless for your hybrid cloud https://cloud.google.com/blog/topics/hybrid-cloud/anthos-simplifies-application-modernization-with-managed-service-mesh-and-serverless-for-your-hybrid-cloud