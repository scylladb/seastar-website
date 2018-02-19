+++
date = "2017-02-05T07:51:49+01:00"
title = "Home"
draft = false
+++


Seastar is an advanced, open-source C++ framework for high-performance server applications on modern hardware. Seastar is used in [Scylla](http://www.scylladb.com/), a high-performance NoSQL database compatible with Apache Cassandra. Applications using Seastar can run on [Linux](http://kernel.org/) or [OSv](http://osv.io/).

Seastar is the first framework to bring together a set of extreme architectural innovations, including:

* [Shared-nothing design](/shared-nothing): Seastar uses a shared-nothing model that shards all requests onto individual cores.
* [High-performance networking](/networking): Seastar offers a choice of network stack, including conventional Linux networking for ease of development, DPDK for fast user-space networking on Linux, and native networking on OSv.
* [Futures and promises](/futures-promises): An advanced new model for concurrent applications that offers C++ programmers both high performance and the ability to create comprehensible, testable high-quality code.
* [Message passing](/message-passing): A design for sharing information between CPU cores without time-consuming locking

# Getting Started with Seastar

Source code is available from the [Seastar repository on GitHub](https://github.com/scylladb).

[Seastar documentation](http://docs.seastar-project.org/) is available on the web or within the source code.

[seastar-dev](https://groups.google.com/forum/?hl=en#!forum-dev) is the project mailing list.

Follow [@ScyllaDB](https://twitter.com/ScyllaDB) on Twitter for more info.

# Performance
![image](/images/seastar-httpd-throughput.png)
![image](/images/seastar-memcache.png)

In the above examples, all servers are running on Linux. The stock Memcached is version 1.4.17.

[Details on HTTP performance](/http-performance/) data are also available.
