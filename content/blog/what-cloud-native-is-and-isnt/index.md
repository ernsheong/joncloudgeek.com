---
title: "What Cloud Native Is and Isn't"
description: "Cloud native is the new buzzword in town. What is it exactly?"
date: 2019-10-12T08:00:00+08:00
images:
- blog/what-cloud-native-is-and-isnt/high-performance-in-cloud.jpg
summary: Cloud native is a loaded phrase that can mean many things to many people. In this article, we take on the challenge of gleaning reasonable guiding principles and traits of cloud native infrastructure and applications.
draft: false
tags:
  - cloud native
---

{{< figure src="./high-performance-in-cloud.jpg" alt="Fighter jets in the sky" caption="High performance applications in the cloud." >}}

## Introduction

**Cloud native** is a phrase we are beginning to hear more and more in recent days. From a language standpoint, "cloud native" seems to imply that some applications do not fit very well in the cloud (like a tourist in a foreign land), while other _cloud native applications_ are very much at home and thriving in the cloud (like a citizen of a country). In fact, _cloud native applications_ (citizens) are most at home in _cloud native infrastructures_ (countries).

## Citizen-Country Analogy

Let's stretch this citizen-country analogy a bit further. There are many countries, and many citizens who, in most cases, belong to only one particular country. Not all countries are the same, though generally they share certain characteristics that make them a country: flag, immigration, government, shared culture/language. Likewise there are probably many ways to do _**cloud native infrastructure**_, and while there may be differences in implementation and details, they share the same distinctive set of characteristics and principles.

Secondly, a citizen of a particular country may visit another country and live there for many years. However, even after being in another country for a decade, that citizen would probably still say that he is more at home in his home country, and able to better take advantage of the benefits of citizenship that are bestowed to him at home. Likewise, a particular ***cloud native application*** is always written in such a way that the application is more at home and _able to take fuller advantage of the infrastructure_ in a certain *native* infrastructure than in another infrastructure.

In essence, when we talk about cloud native, we need to address what it means for both **infrastructure** and **applications** to be cloud native.

## Official definition?

There is actually a foundation called the **Cloud Native Computing Foundation (CNCF)** that champions cloud native technologies to "enable cloud portability without vendor lock-in" ([CNCF FAQ](https://www.cncf.io/about/faq/)). Its mission is "to make cloud native computing ubiquitous."

{{< figure src="./cncf-logo.png" alt="CNCF Logo" caption="Cloud Native Computing Foundation (CNCF)" width="120" >}}

The [CNCF Cloud Native Definition v1.0](https://github.com/cncf/toc/blob/master/DEFINITION.md) says (words in bold are mine for emphasis):

> Cloud native technologies empower organizations to build and run **scalable applications** in modern, dynamic environments such as **public, private, and hybrid clouds**. **Containers, service meshes, microservices, immutable infrastructure, and declarative APIs** exemplify this approach.

> These techniques enable **loosely coupled systems** that are **resilient, manageable, and observable**. Combined with robust **automation**, they allow engineers to make high-impact changes frequently and predictably with minimal toil.

> The Cloud Native Computing Foundation seeks to drive adoption of this paradigm by fostering and sustaining an ecosystem of **open source, vendor-neutral projects**. We democratize state-of-the-art patterns to make these innovations accessible for everyone.

I think the "official definition" is helpful to us to clarify what cloud native is and isn't. Let's take a look at what traits are non-negotiable from this definition:

1. **Non-negotiable**: Scalable applications, public/private/hybrid clouds, loosely coupled systems, resilient & manageable & observable, automation, open-source & vendor-neutral
1. **Negotiable**: Containers, service meshes, microservies, immutable infrastructure, declaractive APIs (although these are "exemplary")

{{< figure src="./cncf-platinum.png" alt="CNCF Platinum Members" caption="CNCF Platinum Members (Source: CNCF Website)" width="750" >}}

Many of the points that follow borrow heavily from many of the points made from  Chapter 1 of the book, *Cloud Native Infrastructure*, by Kris Nova and Justin Garrison, which can be found [here](https://www.oreilly.com/library/view/cloud-native-infrastructure/9781491984291/ch01.html).


## What Cloud Native _Isn't_

It is often instructive, when trying to understand a complex subject, to first start off by exploring what the subject _isn't_.

1. **Cloud native isn't just about running applications in a public cloud**. After all, you could simply "lift and shift" VMs from your own datacenter to EC2 or Compute Engine in the cloud (infrastructure-as-a-service), and virtually nothing was gained from it  .
1. **Cloud native is not about running applications in containers**. For instance, running applications in containers per se (e.g. via `docker run`) is not really that much of a gain compared to running the application straight in the VM itself.
1. **Cloud native doesn't mean you only run a container orchestrator**, e.g. Kubernetes. After all, it is possible to use a container orchestrator in a way that is not intended, locking in applications to a specific set of servers. It _is_, however, a big step forward in the right direction.
1. **Cloud native is not about microservices**. While microservices have benefits such as allowing shorter development cycles on a smaller feature set, monolithic applications can also have the same benefits when done properly, and can also benefit from cloud native infrastructure.
1. **Cloud native is not about infrastructure as code**. Infrastructure as code, such as Ansible, Chef, and Puppet, automates infrastructure in a particular domain-specific language (DSL). However, using these tools often merely automate one server at a time, and do not actually manage applications better.

## What Cloud Native _Is_

Since cloud native applications and cloud native infrastructure are separate but related concerns, I'll discuss them separately.

### What Cloud Native Infrastructure _Is_

1. **Cloud native infrastructure is hidden behind useful abstractions**. There would not really be a "cloud" if all you get is access to bare metal APIs.
1. **Cloud native infrastructure is controlled by APIs**. As above, the abstractions are to be provided for via an API.
1. **Cloud native infrastructure is managed by software**. Cloud native infrastructure is not user-managed, it is self-managing by software.
1. **Cloud native infrastructure is optimized for running applications**. The chief aim of cloud native infrastructure is to run applications for the user.

In other words, cloud native infrastructure behaves very much like a platform-as-a-service (PaaS) offering.

While the CNCF would like to advocate for "open-source" and "vendor-neutral" solutions as its definition of cloud native (see above), I think that such a definition would preclude what many in industry already consider to be cloud native. Examples of this are AWS Lambda, AWS Elastic Container Service (ECS), AWS Fargate, which are all decidedly proprietary with no open source equivalents, but many still consider them to be cloud native. Hence I think the list is a good guiding principle on what is cloud native in general.

**Kubernetes** is the poster child of cloud native infrastructure which checks all the boxes above while being open-source and vendor neutral. However, we would be very wrong to conclude that Kubernetes is the only way to having a cloud native infrastructure. In fact, I would even dare to say that trying to manage your own Kubernetes is not in line with the principles of cloud native, because in many ways you are managing it *yourself*.

{{< figure src="./kubernetes.svg" alt="Kubernetes logo" caption="Kubernetes" width="180">}}

### What Cloud Native Applications _Are_

A cloud native application is designed to run on a cloud native infrastructure platform with the following four key traits:

1. **Cloud native applications are resilient**. *Resiliency* is achieved when failures are treated as the norm rather than something to be avoided. The application takes advantage of the dynamic nature of the platform and should be able to recover from failure.
1. **Cloud native applications are agile**. *Agility* allows the application to be deployed quickly with short iterations. Often this requires applications to be written as microservices rather than monoliths, but having microservices is not a requirement for cloud native applications.
1. **Cloud native applications are operable**. *Operability* concerns itself with the qualities of a system that make it work well over its lifetime, not just at deployment phase. An operable application is not only reliable from the end-user point of view, but also from the vantage of the operations team. Examples of operable software is one which operates without needing application restarts or server reboots, or hacks and workarounds that are required to keep the software running. Often this means that the application itself should expose a health check in order for the infrastructure it is running on to query the state of the application.
1. **Cloud native applications are observable**. *Observability* provides answers to questions about application state. Operators and engineers should not need to make conjectures about what is going on in the application. Application logging and metrics are key to making this happen.

The above list suggests that cloud native applications impact the infrastructure that would be necessary to run such applications. Many responsibilities that have been traditionally handled by infrastucture have moved into the  application realm.

## Summary

Cloud native is a loaded term which is easily misused by many marketing departments. Everyone claims that their infrastructure solutions are cloud native, but I believe that a guiding rule of thumb (in line with everything that has been mentioned above) is that being cloud native should enable your organization to leverage cloud infrastructure in a way that is **cost-effective** and **resource-effective**, that is to say, waste and spend as little (time, effort, and money) as possible while achieving more optimum and faster results, *compared to the most optimal state and performance that today's technology allows*; it is a continuum rather than a binary state. In my view, that is really what it means to be cloud native.

## Related Links

1. Cloud Native Infrastructure (Chapter 1) https://www.oreilly.com/library/view/cloud-native-infrastructure/9781491984291/ch01.html
2. What is Operability? https://blog.softwareoperability.com/what-is-operability/