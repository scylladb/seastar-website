+++
date = "2017-02-05T07:51:49+01:00"
title = "Frequently Asked Questions"
draft = false
+++


## What’s the Difference Between the Seastar Model and the Reactive Programming Model?
Seastar futures/promises/continuations (f-p-c) are a subset of reactive programming.

Seastar performance derives from the sharded, cooperative, non-blocking, micro-task scheduled design, and f-p-c are a friendlier way of feeding tasks to the scheduler.

Seastar’s f-p-c do have some optimizations relative to other f-p-c designs. They trade off thread safety, which is unneeded due to the sharded design, for scheduling efficiency, and have a very low memory footprint.

## How is Seastar Different from mTCP?
mTCP is a user-level TCP stack written over DPDK (or netmap). It aims to solve many of the same problems that Seastar does, including CPU-locality of connections, unnecessary locks and sharing, and system call overhead. mTCP provides a new application API, but does not provide a new framework to manage asynchrony the way that Seastar does.

## What Version of DPDK does Seastar Work With?
Seastar requires DPDK version 1.8.0 or later.

## Is Seastar Available as a Package for any Linux Distribution?
Not yet. If you are interested in packaging Seastar for your favorite distribution, please post to the list.

## What is the Seastar License?
Seastar is open source, and released under the Apache License, Version 2.0.

## Where can I ask a question not covered here?
Post to the [seastar-dev mailing list](https://groups.google.com/forum/?hl=en#!forum/seastar-dev).