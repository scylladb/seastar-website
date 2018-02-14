+++
date = "2017-02-05T07:51:49+01:00"
title = "HTTP performance"
draft = false
+++

Tests of a new Seastar-based HTTP server show that it is capable of ~7M requests/second on a single node. Details of the benchmark follow.

![httpd-throughput](/seastar/seastar-httpd-throughput.png)

This benchmark uses two identical [Intel® Server System R2000WT](http://www.intel.com/p/en_US/support/category/server/r2000wt/doc_guide) servers.

* 2x Xeon E5-2695v3: 2.3GHz base, 35M cache, 14 core 
(28 cores per host, with hyperthreading to 56 cores per host)

* 8x 8GB DDR4 Micron memory

* 12x 300GB Intel S3500 SSD (in RAID5, 3TB of storage for OS)

* 2x 400GB Intel NVMe P3700 SSD (not mounted for this benchmark)

* 2x Intel Ethernet CNA XL710-QDA1 (two cards per server, cards are separated by CPUs. card1: CPU1, card2: CPU2)

* OS info: Fedora Server 21, update with the latest updates as of February 19, 2015.

* Kernel: Linux dpdk1 3.17.8-300.fc21.x86_64

* Default BIOS settings (TurboBoost enabled, HyperThreading enabled)

Full list of commands for reproducing this benchmark available on the [Seastar wiki: HTTPD Benchmark](https://github.com/scylladb/seastar/wiki/HTTPD-benchmark) page.