+++
date = "2017-02-05T07:51:49+01:00"
title = "Networking"
draft = false
+++

Seastar supports four different networking modes on two platforms, all without application code changes. The same application can be built as a dedicated server appliance or unikernel-based VM.

* **DPDK networking on Linux:** A Seastar application running on Linux host can access a physical network device directly. Seastar applications can use DPDK when running as a guest, via device assignment, or on bare metal. This mode provides low-latency, high-throughput networking. No system calls are required for communicating, and no data copying ever occurs. This is the preferred choice for best performance.
* **Linux standard socket APIs:** Seastar applications can be built to use ordinary Linux networking, for ease of application development.
* **Seastar native stack vhost on Linux:** Dedicate a Linux ```virtio-net``` device to the Seastar application, and bypass the Linux network stack. This is mostly used for developing the Seastar TCP/IP stack itself.
* **Virtio device on OSv:** Native stack networking running on the OSv platform instead of Linux: OSv assigns the virtual device to the Seastar application.

## Why networking alternatives?
Conventional networking functionality available in Linux is remarkably full-featured, mature, and performant. However, for truly networking-intensive applications, the Linux stack is constrained:

* **Kernel space implementation** separation of the network stack into kernel space means that costly context switches are needed to perform network operations, and that data copies must be performed to transfer data from kernel buffers to user buffers and vice-versa.
* **Time sharing** Linux is a time-sharing system, and so must rely on slow, expensive interrupt to notify the kernel that there are new packets to be processed.
* **Threaded model** the Linux kernel is heavily threaded, so all data structures are protected with locks. While a huge effort has made Linux very scalable, this is not without limitations and contention occurs at large core counts. Even without contention, the locking primitives themselves are relatively slow and impact networking performance.

By using a user-space TCP/IP stack that is implemented using Seastar basic primitives, these constraints are avoided. Seastar native networking enjoys zero-copy, zero-lock, and zero-context-switch performance.

An alternative user-space network toolkit, [DPDK](http://dpdk.org/), is designed specifically for fast packet processing, usually in less than 80 CPU cycles per packet. It integrates seamlessly with Linux in order to take advantage of high-performance hardware.

Seastar is designed for future-proof development: you can build and run the same applications to run with the networking mode that works best at deployment time, instead of having to commit to economically unpredictable technology choices in advance.

**Next:** [Futures and Promises](/seastar/futures-promises)