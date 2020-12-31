---
title: Why Cloud SQL Makes Sense
description: Why you may want to consider Cloud SQL over self-hosting your database in Compute Engine.
date: 2020-12-31T08:00:00+08:00
images:
- blog/why-cloud-sql-makes-sense/meta.jpg
summary: I explore why Cloud SQL may make more sense despite being costlier than self-hosting your database in Compute Engine.
draft: false
tags:
  - google cloud
  - cloud sql
  - postgres
  - mysql
---

{{< figure src="./meta.jpg" alt="A nice library" caption="A managed and orderly Cloud SQL database." >}}

## Introduction

In a previous blog post, I explored how you can [run a Postgres instance for cheap using Compute Engine](https://joncloudgeek.com/blog/deploy-postgres-container-to-compute-engine/) in Google Cloud. As non-US users may know, Cloud SQL or most managed database services out there are actually rather expensive.

In this blog post, I want to mention many things left unsaid about compromises you have to make when self-hosting a database in Compute Engine (or any self-managed VM), compared to using a managed database service such as Cloud SQL or its counterparts in other clouds. Some of these compromises have serious consequences, so do read on.

## Key Advantages of Cloud SQL (vs. self-hosting a database in Compute Engine)

1. **Cloud SQL Proxy for secure database communication**

   When self-hosting a database in Compute Engine, it is left as an exercise to you to setup SSL connections to encrypt client/server communications for increased security. Without SSL, connecting to your Compute Engine database directly essentially means communicating over plain-text (which is less of a problem if you are communicating from within the same Google Cloud network, but convenience also implies lesser security within the network).

   Setting up database SSL correctly appears to be a detailed topic by itself, and admittedly one which I have never looked into closely (yet). An accompaniment to Cloud SQL, [Cloud SQL Proxy](https://cloud.google.com/sql/docs/mysql/sql-proxy) is a mini-program (script) that you run in your local machine or in your application code, allowing secure communication with your Cloud SQL instance _without the need to manually provision and manage SSL certificates_.

    Which begs the question, why does Cloud SQL use a proxy as the recommended way to connect instead of giving an HTTPS endpoint to cloud users like what Amazon RDS does? I suspect it has to do with the complexity surrounding SSL certificate management and also certificate expiration that could potentially cause catastrophic downtimes? So maybe Google Cloud just avoided the issue completely for most people, though within Cloud SQL there also appears to be ways to register and generate client certificates manually (which I have never used before, yet), but the recommendation is to use Cloud SQL proxy no matter where your application is hosted at.

2. **First class native integration with Google Cloud products (aka no need to pay for dedicated VPC connection with Cloud SQL Proxy)**

   Cloud SQL is a first class database product in Google Cloud. Particularly, if you are using Cloud Run or Cloud Functions, these products support Cloud SQL Proxy natively without much effort to the developer (and it's free).

   On the contrary, if you are using Cloud Run or Cloud Functions and want to connect to a database in Compute Engine (without leaving the Google Cloud network), you have to set up [Serverless VPC Access](https://cloud.google.com/vpc/docs/serverless-vpc-access) which essentially means that you are paying for a [phantom `e2-micro` instance](https://cloud.google.com/vpc/docs/configure-serverless-vpc-access#pricing) that serves as a connector for every 100 Mbps of throughput, not to mention egress rates (previously it was an `f1-micro`, phantom because you can't just go and edit/delete it but it actually lives within your project). Why so? Because Cloud Run and Cloud Function instances run in a different and separate Google-managed VPC network outside your project VPC. And Google Cloud decided to charge users who want to bridge that VPC gap on their own.

    You could also of course connect to your database instance via the public network route, at the cost of increased latency and higher exposure. But you still have to revisit the SSL configuration mentioned above otherwise your app will be talking to the database via plain-text.

3. **Cloud SQL takes automatic backups of your database**

    It does this by default, though you could turn it off (but why?). In Compute Engine, you could enable [scheduled snapshots](https://cloud.google.com/compute/docs/disks/scheduled-snapshots) to automatically back up zonal and regional persistent disks. However, there is a technical difference between backing up database data and backing up a persistent disk where the database data sits on, though I might be wrong since I am not aware how Cloud SQL actually handles the database data (it might be a managed persistent disk). Nonetheless, there are risks of disk and VM corruption with the snapshot approach, albeit rare.

4. **Cloud SQL database storage scales automatically**

    I don't know about you, but my app going down because the persistent disk containing the app database has become full has happened to me before. With Cloud SQL, you can allow it to automatically scale storage without any human interference.

    On a separate note, bear in mind that if you enable point-in-time recovery the storage usage can increase dramatically even with little database activity.

5. **Easy HA and replication**

    Setting up a high availability configuration as well as database replication (read replicas) are easily achieved via the Cloud Console, which is otherwise a more complex manual setup (in my imagination as a lazy developer).

And many more.

## Summary

I could rattle off a longer list, but that would simply boil down to [all the features that Cloud SQL has to offer](https://cloud.google.com/sql/docs/mysql/concepts), including point-in-time recovery, easily restoring an instance from a backup, nice Cloud Console UI to perform many database operations, as well as out-of-the-box charts to know what is going on in your database, which would otherwise be sitting opaquely in your Compute Engine instance.

There is a time and place for hosting and maintaining your own database in Compute Engine. But do consider some of the above points, especially if you value reliability and convenience above simply getting the cheapest price.

For enterprise and serious production environments, there is almost no question but to use Cloud SQL exclusively over self-managed databases. Free up your engineers to deal with more productive stuff other than the overhead expense of managing a database.