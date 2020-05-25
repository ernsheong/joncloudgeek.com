---
title: Cost-effective way to run a Postgres instance in Google Cloud
description: Run Postgres in Google Cloud in the cheapest way possible, the easy way.
date: 2020-05-25T08:00:00+08:00
images:
- blog/deploy-postgres-container-to-compute-engine/meta.jpg
summary: Cost-effective way to run a Postgres instance in Google Cloud, easily.
draft: false
tags:
  - compute engine
  - postgres
  - container
---

{{< figure src="./meta.jpg" alt="An elephant" caption="Postgres in a container" >}}


In this blog post, I will explore running a Postgres instance in a container within Compute Engine for a fraction of what it costs to run in Cloud SQL.

## Disclaimer

The information provided in this blog post is provided as is, without warranty of any kind, express or implied. By following the following steps in this blog post I do not guarantee that your database will be free from any sort of failures or data losses.

## Scenario

[Cloud SQL](https://cloud.google.com/sql) is kind of expensive:

* `f1-micro` gives you a weak instance with only 0.25 vCPU burstable to 1 vCPU, from $9.37.
* `g1-small` is still 0.5 vCPU burstable to 1 vCPU, but the price jumps to from $27.25.
* Let's not even talk about the non-shared vCPU standard instances.

For toy project or production projects that just don't need that power, Cloud SQL is overkill, at least the price is overkill.

This blog post is for smaller projects that need Postgres but without Cloud SQL, and without the maintenance hassle of running commands to manually install Postgres.

## Get started

1. Sign up for [Google Cloud](https://console.cloud.google.com/). Free trial gives you $300 credits lasting one year.
1. [Create a project](https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project) to house your related resources.
1. Navigate to [Compute Engine](https://console.cloud.google.com/compute/instances).

## Create a compute instance running a Postgres container


1. Click on **Create**.

{{< figure src="./click-create.png" alt="Click on Create" caption="Click Create" width="500" >}}

2. Select the E2 series and the `e2-micro` machine type. E2 series is a cost-optimized series of compute engine instances. Read more about it in the [launch blog post](https://cloud.google.com/blog/products/compute/google-compute-engine-gets-new-e2-vm-machine-types). `e2-micro` is like `f1-micro`, but with **2 shared vCPU**, which is good enough for almost any small project, but not compromising like the weak `f1-micro` (which hangs / throttles when you try to do too much CPU work).

    The `e2-micro` starts from **$6.11/month**.

{{< figure src="./select-e2.png" alt="Select E2 instance." caption="Select e2-micro" width="450" >}}

3. Check **Deploy a container image to this VM instance**. This will cause Compute Engine to only run the given image (next step) in the compute instance. Each compute instance can only run a single container using this method, and since we have sized our instance to only have just enough resources, this is totally fine.

{{< figure src="./check-container.png" alt="Check Deploy a container image to this VM instance." caption="Check this to deploy a container image to our Compute Engine instance" width="450" >}}

4. Choose a Postgres image from the Marketplace:

    1. Search for Postgres in Marketplace.

        {{< figure src="./marketplace-postgres-search.png" alt="Check Deploy a container image to this VM instance." caption="Search for Postgres in Marketplace" width="750" >}}

    1. Select a Postgres version.

        {{< figure src="./marketplace-postgres-results.png" alt="Check Deploy a container image to this VM instance." caption="Choose your desired Postgres version" width="650" >}}

    1. Click on **Show Pull Command** to retrieve the image URL.

        If you click on **Get Started with Postgresql 11** it will bring you to a Github page with more (important) information.

        Notably you want to take note of the list of [Environment Variables](https://github.com/GoogleCloudPlatform/postgresql-docker/blob/master/11/README.md#environment-variables) understood by the container image.

        {{< figure src="./show-pull-command.png" alt="Click on Show Pull Command" caption="Show Pull Command" width="650" >}}

    1. Copy the image URL:

    {{< figure src="./copy-image-url.png" alt="Copy the image url" caption="Copy the image url" width="650" >}}

5. Paste the image URL into previous Compute Engine step. Set the minimum necessary environment variables. The default user is **postgres**. POSTGRES_DB is arguably unnecessary, you can already create it manually after instance creation.

    {{< figure src="./set-image-env-var.png" alt="Set the image and environment variables" caption="Set the image and environment variables" width="450" >}}

6. **[VERY IMPORTANT]** Mount a directory and point it at where the container stores data. **IF YOU DO NOT DO THIS, WHEN YOUR INSTANCE REBOOTS OR STOPS FOR WHATEVER REASON, ALL DATA DISAPPEARS.**

    {{< figure src="./mount-volume.png" alt="Mount a volume at the Postgres data directory" caption="Mount a volume at the Postgres data directory" width="450" >}}

    It is somewhat container intuitive, usually in the command line we state the host path first, and then the mount path. Here **Mount path** (the container directory) comes first, and **Host path** (the OS directory) comes second.

    Click **Done**.

7. Some optional settings to configure:

    {{< figure src="./secure-boot.png" alt="Turn on Secure Boot" caption="Turn on Secure Boot" width="450" >}}
    {{< figure src="./uncheck-delete-boot-disk.png" alt="Uncheck Delete boot disk when instance is deleted" caption="Uncheck Delete boot disk when instance is deleted" width="450" >}}

8. Click **Create**.

## Add a Firewall rule to connect to this instance

By default, post 5432 is blocked in a Google Cloud project. To allow connections from your local machine, do the following:

1. Go to **Firewall rules**.

    {{< figure src="./search-firewall.png" alt="Search for firewall and click on Firewall rules (VPC network)" caption="Search for firewall and click on Firewall rules (VPC network)" width="450" >}}

1. Select **Create Firewall Rule**.
1. Name, **allow-postgres** (or anything you like)
1. In **Target tags**, add `allow-postgres`.
1. In **Source IP ranges**, add `0.0.0.0/0`. Or Google "my ip" and paste in the result (safer but cumbersome, IP changes frequently).
1. In **Specific protocols and ports**, add `5432` in **tcp**.
1. Click **Create**.
1. Go back to the DB instance, click **Edit**.
1. Add the `allow-postgres` network tag:

    {{< figure src="./add-network-tag.png" alt="Add the allow-postgres network tag" caption="Add the allow-postgres network tag" width="450" >}}

1. Click **Save**. Your instance is now accessible from your local machine.

## Migrate data to new DB

1. Dump your current DB data:

       pg_dump -d mydb -h db.example.com -U myuser --format=plain --no-owner --no-acl  \
         | sed -E 's/(DROP|CREATE|COMMENT ON) EXTENSION/-- \1 EXTENSION/g' > mydb-dump.sql

1. Get the external IP of our new DB:

    {{< figure src="./get-external-ip.png" alt="Copy the external IP of the new instance" caption="Copy the external IP of the new instance" width="850" >}}

1. Use the external IP to `psql` to the instance. When prompted, paste the DB password from `POSTGRES_PASSWORD` earlier.

       psql -h [EXTERNAL_IP] -U postgres mydb < mydb-dump.sql

1. Your DB is now ready. When creating the DB, note the internal hostname for this instance:

    {{< figure src="./note-hostname.png" alt="Note the instance internal hostname" caption="Note the instance internal hostname" width="450" >}}

    You can use this internal hostname to talk to this DB from within your VPC (another Compute Engine instance, Cloud Run, GKE, etc.). If that fails, then you can fallback to the **Internal IP** (previous step screenshot).

1. **[HIGHLY RECOMMENDED]** Stop (shut down) your DB instance and start it again. Connect to your instance via `psql` (note that the External IP would likely change). Check that all your data is intact.

1. Remove `allow-postgres` from your instance **Network tags** (Edit, remove, Save). Your instance is no longer publicly accessible. By default, all internal network ports are open in Firewall rules.

## Closing Remarks

In this blog post, we have successfully created a Postgres instance from a container image in Compute Engine. We configured a firewall rule to connect to that instance from our local machine using a network tag, and we removed that network tag to lock up access to that instance. We also used the instance External IP to connect to it and restore dumped SQL data from our old instance (with the firewall rule in place).

If you are confident about the needs and performance of your application, you can choosed to downgrade the instance to `f1-micro` to save another $2/month. Eventually GCP will come along and tell you that your instance is over-utilized (you can ignore or reject the warning). Note that all the risk is yours if your DB instance hangs because it is CPU-starved. There is an increased risk to cheap in the cloud.

Alternatively, there is a Postgres [**Google Click to Deploy**](https://console.cloud.google.com/marketplace/details/click-to-deploy-images/postgresql) option in the Marketplace. This will run Postgres in Debian OS, not a container. And you also cannot run it in an E2 instance (only N1 is supported). But it is probably more production ready, I presume.

Also highly recommended is that you take [**scheduled snapshots**](https://cloud.google.com/compute/docs/disks/scheduled-snapshots) of the boot disk of the DB instance. This is important for data recovery and backups. Usually Cloud SQL takes are of this for you, but we need to handle it ourselves since we are DIY-ing here.