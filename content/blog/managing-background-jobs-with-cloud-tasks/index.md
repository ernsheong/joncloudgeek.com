---
title: Managing background jobs with Cloud Tasks
description: Use Cloud Tasks to manage your background jobs at scale, without drowning your worker.
date: 2020-06-15T08:00:00+00:00
images:
- blog/managing-background-jobs-with-cloud-tasks/meta.jpg
summary: Use Cloud Tasks to manage your background jobs at scale, without drowning your worker.
draft: false
tags:
  - google cloud
  - cloud tasks
  - devops
---

{{< figure src="./meta.jpg" alt="A queue" caption="A queue." >}}

In this blog post, I will give an overview of [Cloud Tasks](https://cloud.google.com/tasks) with the aim of enabling you to start using it in your own applications.

## Introduction

[Cloud Tasks](https://cloud.google.com/tasks) is a fully managed service that allows you to **execute**, **dispatch**, and **deliver** a large number of distributed tasks. Use Cloud Tasks to perform work asynchronously outside of a user or service-to-service request cycle.

Well, that's a paraphrase of the [documentation intro](https://cloud.google.com/tasks/docs). What exactly is Cloud Tasks? In a nutshell, **Cloud Tasks helps you manage queues of tasks** that are performed outside a request cycle (in the background).

{{< figure src="./cloud-tasks-logo.png" alt="Cloud Tasks" caption="Cloud Tasks" width="150" >}}

## Overview

A **task** is the **encapsulation of information representing an independent piece of work** that triggers a request to a **handler** to complete the task (handler is the code that runs on a certain endpoint **target**). The task remains in the **queue** which persists the task until the triggered handler completes with a successful status code. If the handler suffers from a failure or an error, the queue will retry the task again later (with backoff). It will also rate-limit the number of concurrent tasks that is simultaneously executed, hence saving your worker endpoint from certain "drowning" otherwise.

As a simple example, sending an email based on a user action should ideally be done asynchronously as a task, allowing you to return from the request more quickly, and ensuring that the email is actually sent in the event of a failure in the sender gateway.

You will first create and configure the queue, which is then managed by Cloud Tasks. Complexities associated with task management such as latency, server crashes, resource consumption limitations, and retry management is handled by Cloud Tasks.

Each task is made up of:

* **A unique name** (generated for you by client SDKs, usually)
* **Configuration information** (e.g. url, timeout, HTTP method)
* (optional) **Payload** of data necessary to process the request. The payload is send in the request body, thus handlers that process tasks with payloads must use POST or PUT as the HTTP method.

## Relationship with App Engine

Historically, Cloud Tasks had its origins in App Engine. Indeed, if you use the first generation App Engine standard environment, you should use Cloud Tasks via the App Engine Task Queue API (if you are new to App Engine standard you should use the second generation instead). All other users (second generation App Engine standard, App Engine flex, Compute Engine, Cloud Run, etc.) should use the Cloud Tasks API, which we are interested in.

At time of writing, Cloud Tasks requires you to have a project with App Engine configured. **The App Engine app hosts the Cloud Task queues that are created** (note that this "App Engine app" is really internal Google infrastructure that is somewhat coupled with App Engine, but you can disable App Engine in your project). Particularly, the App Engine app is **located in a specific region which serves the location of your queues in Cloud Tasks**. Hence, you should give some thought to where your App Engine app is going to be, because once it is set for your project you cannot change it without creating another project. This limitation kinda sucks because it would be nice to just be able to spin up queues wherever I like, like how I can spin up a function in Cloud Functions in any supported region.

Note that, because of this, disabling App Engine in your project will cause Cloud Tasks to stop working, whether or not you use App Engine handlers or HTTP handlers (see next section).

## Targets

{{< figure src="./target.png" alt="A target" caption="A target." width="175" >}}

The endpoints that process the tasks are called **targets**, where the **handlers** are defined. Cloud Tasks supports two types of targets:

* (Generic) **HTTP targets** are hosted at any generic HTTP endpoint.
* **App Engine targets** are hosted in a service on App Engine.

In both cases, all handlers must send a `2xx` HTTP response code before a certain timeout. For HTTP targets, the deadline is 10 minutes by default (extendable to 30 minutes). For App Engine targets, the deadline depends on the [scaling type of the service](https://cloud.google.com/tasks/docs/creating-appengine-handlers#timeouts).

In this blog post, I will solely focus on HTTP targets, as it is the more generic and likely use case for most users.

## Create a queue

1. Create a Cloud Tasks queue via the Cloud SDK:

    ```bash
    gcloud tasks queues create [QUEUE_ID]
    ```

1. Use `describe` to inspect your queue:

    ```bash
    gcloud tasks queues describe [QUEUE_ID]
    ```

    The output should be something like:

    ```bash
    name: projects/[PROJECT_ID]/locations/[LOCATION_ID]/queues/[QUEUE_ID]
     rateLimits:
       maxBurstSize: 100
       maxConcurrentDispatches: 1000
       maxDispatchesPerSecond: 500.0
     retryConfig:
       maxAttempts: 100
       maxBackoff: 3600s
       maxDoublings: 16
       minBackoff: 0.100s
     state: RUNNING
    ```

    Note the available configuration above which we will explore below: `maxBurstSize`, `maxConcurrentDispatches`, `maxDispatchedPerSecond`, `maxAttempts`, `maxBackoff`, `maxDoublings`, and `minBackoff`.

## Configuring a queue

There are three aspects to configuring your queues:

  * **Rate limits** allow you to define the maximum rate and maximum number of concurrent tasks that can be dispatched by a queue.
  * **Retry parameters** allow you to specify the maximum number of times to retry failed tasks, set a time limit for retry attempts, and control the interval between attempts.
  * **Routing** (App Engine targets only, not covered here)

### Rate-limit parameters

Cloud Tasks uses the [token bucket algorithm](https://en.wikipedia.org/wiki/Token_bucket) to enforce rate-limiting. In essence, we have a bucket that have a fixed capacity of tokens. A token represents a single unit added to the bucket at a fixed rate. Note that a token does _not_ represent a task, it is just a token.

Conceptually:

1. A token is added to the bucket every 1/_r_ seconds, at rate _r_.
1. The bucket can hold at the most _b_ tokens. If a token arrives when the bucket is full, it is discarded.
1. When a **task** is scheduled, if there is at least 1 token in the bucket, a token is removed from the bucket, and the task is executed. If no tokens are available in the bucket, no tokens are removed from the bucket, and the task remains on the queue.

    If multiple tasks are generated within a short time, the tasks are dispatched concurrently subject to token availability, up to the value set in `maxConcurrentDispatches`.


Therefore, we now have a better understanding of what we are configuring:
* `maxDispatchesPerSecond` is the rate at which _tokens_ are continuously added into the bucket. While related, is it *not* the rate at which tasks are dispatched (they are equivalent only if there is a relatively steady flow of tasks, or if there is a backlog in the queue).
* `maxConcurrentDispatches` is the maximum number of tasks in the queue that can run at once (concurrency).
* `maxBurstSize` is the **bucket size**. It is set automatically by Cloud Tasks API based on `maxDispatchesPerSecond` (you cannot change it). Cloud Tasks will set this to a number that ensures an efficient rate for managing bursts. It is possible to change this number manually by using a `queue.yaml`, but this is not generally recommended (see [Using Queue Management versus queue.yaml](https://cloud.google.com/tasks/docs/queue-yaml) for more information).

Use `update` to configure the above via Cloud SDK:

```bash
gcloud tasks queues update [QUEUE_ID] \
  --max-dispatches-per-second=[MAX_DISPATCHES_PER_SECOND] \
  --max-concurrent-dispatches=[MAX_CONCURRENT_DISPATCHES]
```

### Retry parameters

If a task fails (e.g. handler timeout, handler error), Cloud Tasks will retry the task with exponential backoff according to the parameters shown below.

Unlike rate-limits, retry paramaters are more straightforward, so let's jump straight into it:

```bash
gcloud tasks queues update [QUEUE_ID] \
  --max-attempts=[MAX_ATTEMPTS] \
  --min-backoff=[MIN_BACKOFF] \
  --max-backoff=[MAX_BACKOFF] \
  --max-doublings=[MAX_DOUBLINGS] \
  --max-retry-duration=[MAX_RETRY_DURATION]
```

where:

* `MAX_ATTEMPTS` is the maximum number of attempts for a task, including the first attempt. You can allow unlimited retries by setting this flag to `unlimited`.
* `MIN_BACKOFF` is the minimum amount of time to wait between retry attempts. The value must be a string that ends in "s", such as 5s.
* `MAX_BACKOFF` is the maximum amount of time to wait between retry attempts. The value must be a string that ends in "s", such as 5s.
* `MAX_DOUBLINGS` is the maximum number of times that the interval between failed task retries will be doubled before the increase becomes constant.
* `MAX_RETRY_DURATION` is the maximum amount of time for retrying a failed task. The value must be a string that ends in "s", such as 5s.

## Scheduling a task

You would usually create a task using one of the [Google Cloud Client Libraries](https://cloud.google.com/apis/docs/cloud-client-libraries) from within your own server application.

Below is a code sample for Node.js (see [Creating HTTP Target tasks](https://cloud.google.com/tasks/docs/creating-http-target-tasks#node.js) for source and samples in other languages):

```js
const { CloudTasksClient } = require('@google-cloud/tasks');

// Instantiates a client.
const client = new CloudTasksClient();

// Construct the fully qualified queue name.
// TODO(developer): Uncomment these lines and replace with your values.
// const project = 'my-project-id';
// const queue = 'my-queue';
// const location = 'us-central1';
const parent = client.queuePath(project, location, queue);

const task = {
  httpRequest: {
    httpMethod: 'POST',
    url: 'https://example.com/taskhandler', // Full URL path to task handler endpoint
  },
};

const payload = 'Hello World!'
task.httpRequest.body = Buffer.from(payload).toString('base64');

if (inSeconds) {
  // The time when the task is scheduled to be attempted.
  task.scheduleTime = {
    seconds: inSeconds + Date.now() / 1000,
  };
}

// Send create task request.
const request = {parent, task};
const [response] = await client.createTask(request);
```

Interestingly, you can schedule a task in the future with `scheduleTime`. Also, with `dispatchDeadline` you can change the default timeout for the task handler. See the [documentation](https://googleapis.dev/nodejs/tasks/latest/google.cloud.tasks.v2.Task.html) for more options.

Once a task is created, attempts will be made to call the task handler at the given URL. There is nothing special about the task handler, but it will have to anticipate the format of the request (JSON or otherwise?) in the request body (if present). In other words, it is just like any HTTP handler in your API.

The task **name** is not given explicitly here, so the client library will generate one for us. I did not test this out, but I expect that if I generated the task name myself, subsequent task creations with the same name will be **deduplicated**. This feature might be useful in your use case.

## Security

The biggest security concern which I will address here is ensuring that no one else but Cloud Tasks is allowed to invoke the task handlers.

In the case of **App Engine targets**, this is easy. App Engine will set [specific headers](https://cloud.google.com/tasks/docs/creating-appengine-handlers#reading_app_engine_task_request_headers) such as `X-AppEngine-TaskName` and `X-AppEngine-QueueName`, which are set internally and if an attacker tries to set it externally it will be removed by App Engine. If any of the headers are present in your task handler, you can trust that the request is a Cloud Tasks request.

In the case of **HTTP targets**, however, [similar headers](https://cloud.google.com/tasks/docs/creating-http-target-tasks#handler) are also set by Cloud Tasks, but they are for information only and cannot be trusted as sources of identity. Instead, you need to [validate an OIDC token](https://developers.google.com/identity/protocols/oauth2/openid-connect?#validatinganidtoken) provided by Cloud Tasks. This is out of the scope of this blog post for now; I may come back and update later.

## Cloud Tasks vs Cloud Pub/Sub

{{< figure src="./cloud-pubsub.png" alt="Pub/Sub" caption="Pub/Sub" width="120" >}}

**Pub/Sub** decouples publishers of events and subscribers to those events. Publishers do not need to know anything about their subscribers; the invocation is **implicit**.

Cloud Tasks is aimed at **explicit** invocation where the publisher retains full control of execution. Particularly, the publisher specifies and endpoint where the message is to be delivered.

In addition to this philosophical difference, Cloud Tasks provides the following mechanisms that aren't supported by Pub/Sub:

* Scheduling specific delivery times
* Delivery rate controls
* Configurable retries
* Access and management of individual tasks in a queue
* Task/message creation deduplication

On the other hand, Pub/Sub allows for the following which are not supported by Cloud Tasks:

* Batch insertion of messages
* Multiple handlers per message
* Max size of message is 10MB vs. 100KB in Cloud Tasks
* No upper limit to the delivery rate vs. limit of 500 qps/queue in Cloud Tasks
* Global availability vs. Regional availability in Cloud Tasks

See [Choosing between Cloud Tasks and Pub/Sub](https://cloud.google.com/tasks/docs/comp-pub-sub) for a more detailed comparison.

## Cloud Tasks vs Cloud Scheduler

{{< figure src="./cloud-scheduler.png" alt="Cloud Scheduler" caption="Cloud Scheduler" width="120" >}}

The main difference is that Cloud Scheduler initiates actions on a fixed periodic schedule (cron), which Cloud Tasks initiates actions from a queue, which is usually populated from a user or service request.

Cloud Scheduler does not retry a failed cron job, while Cloud Tasks retries a task until it succeeds.

I like to use Cloud Scheduler to trigger a periodic job that creates a bunch of tasks in Cloud Tasks in one go, delegating rate-limit, concurrency, and retry handling to Cloud Tasks.

See [Cloud Tasks versus Cloud Scheduler](https://cloud.google.com/tasks/docs/comp-tasks-sched) for a more detailed comparison.

## Summary

Cloud Tasks is GCP's fully managed solution for handling queues of background jobs (tasks). It provides rate-limiting and retry capabilities that are not present in Pub/Sub. Before reaching out for Pub/Sub you may want to consider if Cloud Tasks suits your application's use case better.

Cloud Tasks also provides a great alternative to third-party queues such as Resque or Sidekiq, if not better. Unlike these third-party queues, there are no workers or queues to manage; it is serverless apart from the task handlers which you will have to provide.