---
title: "What Cloud Native Is and Isn't"
description: "TODO"
date: 2019-10-01T08:00:00+08:00
# images:
# - blog/what-is-anthos-by-google-cloud/anthos-bridge-between-on-prem-and-gcp.jpg
# summary: Anthos is Google Kubernetes Engine (GKE) deployed to both on-premises or in the cloud. But it comes with an enterprise-only price tag.
draft: false
tags:
  - cloud native
---

## Introduction

**Cloud native** is a phrase we are beginning to hear more and more in recent days. From a language standpoint, "cloud native" seems to imply that some applications do not fit very well in the cloud (like a tourist in a foreign land), while other _cloud native applications_ are very much at home and thriving in the cloud (like a citizen of a country). In fact, _cloud native applications_ (citizens) are most at home in _cloud native infrastructures_ (countries).

## Citizen-Country Analogy

Let's stretch this citizen-country analogy a bit further. There are many countries, and many citizens who, in most cases, belong to only one particular country. Not all countries are the same, though generally they share certain characteristics that make them a country: flag, immigration, government, shared culture/language. Likewise there are probably many ways to do _cloud native infrastructure_, and while there may be differences in implementation and details, they share the same distinctive set of characteristics and principles.

Secondly, a citizen of a particular country may visit another country and live there for many years. However, even after being in another country for a decade, that citizen would probably still say that he is more at home in his home country. Likewise, a particular application is always written in such a way that the application is more at home and _able to take fuller advantage of the infrastructure_ in a certain infrastructure than in another infrastructure.

## Official definition?

There is actually a foundation called the **Cloud Native Computing Foundation (CNCF)** that champions cloud native technologies to "enable cloud portability without vendor lock-in" ([CNCF FAQ](https://www.cncf.io/about/faq/)). Its mission is "to make cloud native computing ubiquitous."

{{< figure src="./cncf-logo.png" alt="CNCF Logo" caption="Cloud Native Computing Foundation (CNCF)" width="120" >}}

The [CNCF Cloud Native Definition v1.0](https://github.com/cncf/toc/blob/master/DEFINITION.md) says (words in bold are mine for emphasis):

> Cloud native technologies empower organizations to build and run **scalable applications** in modern, dynamic environments such as **public, private, and hybrid clouds**. **Containers, service meshes, microservices, immutable infrastructure, and declarative APIs** exemplify this approach.

> These techniques enable **loosely coupled systems** that are **resilient, manageable, and observable**. Combined with robust **automation**, they allow engineers to make high-impact changes frequently and predictably with minimal toil.

> The Cloud Native Computing Foundation seeks to drive adoption of this paradigm by fostering and sustaining an ecosystem of **open source, vendor-neutral projects**. We democratize state-of-the-art patterns to make these innovations accessible for everyone.

I think the "official definition" is helpful to us to clarify what cloud native is and isn't. Let's take a look at what traits are non-negotiable from this definition:

**Non-negotiable**: Scalable applications, public/private/hybrid clouds, loosely coupled systems, resilient & manageable & observable, automation, open-source & vendor-neutral

**Negotiable**: Containers, service meshes, microservies, immutable infrastructure, declaractive APIs (although these are "examplary")

{{< figure src="./cncf-platinum.png" alt="CNCF Platinum Members" caption="CNCF Platinum Members" width="750" >}}

## What Cloud Native Isn't

It is often instructive, when trying to understand a complex subject, to first start off by exploring what the subject _isn't_.

1. **Cloud native isn't just about running applications in a public cloud**. After all, you could simply "lift and shift" VMs from your own datacenter to EC2 in the cloud (infrastructure-as-a-service), and virtually nothing else in your IT processes changed.
1. **Cloud native is not about running applications in containers**. For instance, running applications in containers per se (e.g. via `docker run`) is not really that much of a gain compared to running the application straight in the VM itself.
1. **Cloud native doesn't mean you only run a container orchestrator**, e.g. Kubernetes. After all, it is possible to use a container orchestrator in a way that is not intended, locking in applications to a specific set of servers. It _is_, however, a big step forward in the right direction.
1. **Cloud native is not about microservices**. While microservices have benefits such as allowing shorter development cycles on a smaller feature set, monolithic applications can also have the same benefits when done properly, and can also benefit from cloud native infrastructure.
1. **Cloud native is not about infrastructure as code**. Infrastructure as code, such as Ansible, Chef, and Puppet, automates infrastructure in a particular domain-specific language (DSL). TODO
