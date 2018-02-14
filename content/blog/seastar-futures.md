---
title: "Seastar: The future<> is Here"
date: 2018-02-13T08:02:27-08:00
---
![image](/seastar/images/alex-seastar-5.jpg)
By Alexander Gallego

This is a cross-post from [Alexander's Blog](https://www.alexgallego.org/concurrency/smf/2017/12/17/future.html).

On June 8, 2016, Avi Kivity came to NYC to present ScyllaDB. During his search for a quick open desk to do some work, I volunteered open spaces we had at Concord1. We talked lock-free algorithms, memory reclamation techniques, threading models, Concord and distributed streaming engines, even C vs C++. Five hours later I was convinced that Seastar was the best systems framework I’d ever come across.

I’ve now been using Seastar for almost two years and I haven’t changed my mind.

### The future<> is all about concurrency

For the truly impatient, the future<> is here[^2].

In 1978 news[^3], T. Hoare prophetically said the future was about computers getting more cores and not increasing in clock speed. In 2004 Herb Sutter coined the same trend as The Free Lunch is Over[^4]. The ```seastar::future<>``` is a tool to take advantage of multi-core, multi-socket machines – a way to structure your software to grow gracefully with your hardware. There are many other tools that fit this new modality, from lock-free algorithms and to co-routines, to channels[^3], not to mention actor-style message passing, among many other paradigms like full-on distributed programming languages. [^5][^6][^7][^8]

```“Instead of driving clock speeds and straight-line instruction throughput ever higher, they are instead turning en masse to hyperthreading and multicore architectures”``` – Herb Sutter

```seastar::future<>```’s are for concurrent software construction. In addition, their design makes them composable. You can take any two futures and chain them together via ```.then()``` operator and yield a new future[^9]. Although you can combine, mix, map-reduce, filter, chain, fail, complete, generate, fulfill, sleep, expire futures, etc, they are fundamentally about program structure. Such program structure can execute in parallel, but doesn’t have to. When you have concurrent structure, parallelism is a free variable[^10]. That is to say, you can turn up or down the number of ```simultaneous``` execution units/cores/threads without changing your program. In this paradigm, you worry about correct program structure and someone else worries about the execution.

![image](/seastar/images/alex-seastar-1.png)

Seastar is an intrusive building block. Once you start composing Seastar-driven asynchronous building blocks, you have to go out of your way – really – to build anything synchronous, and that’s powerful. Structurally, Seastar has the same effect as actor frameworks like Akka5, Orleans[^6], or even languages like Pony[^7] or Erlang[^8] have. Once you have an actor, they spread **virally** through your system making everything an actor.

Philosophically, actor frameworks and distributed languages differ from Seastar. While the former try to give the programmer higher abstractions and a runtime to hide machine details like IO or CPU scheduling, Seastar takes the opposite approach. It gives you – the wise programmer – abilities to tune and control almost every part of the future<> runtime. This includes IO shares scheduling, CPU shares scheduling, in addition to batteries included approach when it comes to taking advantage of hardware for dealing with filesystems, networking, DMA, etc.

Both approaches, however, are intrinsically safe. The programmer worries about correctness and construction while the frameworks worry about efficient execution. Counter to general wisdom, it is actually faster and more scalable than the synchronous approach. While the machine does more work, it is executing your code simultaneously. This simultaneity is the key to finishing work sooner.

At its core, from the project site, Seastar promises:

* Shared-nothing design[^11]
* High-performance networking[^12]
* Futures and promises[^13]
* Message passing[^14]

… but it is much more, so let’s get technical and find out how Seastar executes these concurrency building blocks.

### Enter Seastar… at your own risk, you might not come back

In a past life, I helped build Concord.io with facebook’s folly::futures[^15], and wangle[^16] for networking and async execution. While these libraries enabled us to deliver high-performance code using similar primitives, their use of asynchronous operations is not as pervasive as that of Seastar. They are libraries and not frameworks, which is the first distinction. That is, you can use the parts of the libraries that you need without needing to include or use the rest. You can tick your own clocks, your own IOEventLoops, your own CPU Scheduling, your own ```syscall()``` thread pool, etc. Seastar, on the contrary, tells you that you have to operate within their framework. It is not possible to take parts of Seastar and use them on your code base without the IO subsystem or the CPU subsystem.

While this decision seems like a disadvantage, it is actually an enforcer of asynchronicity – very much like actors. It is front and center to everything you do. This is a good thing.

### No locks, atomics, cache polluting primitives

Seastar takes one extreme approach to data locality. It uses almost no locks, atomics, or in any way implicit memory sharing with other cores. Your view into any application starts with a ```seastar::distributed<T>``` type. This means a copy of the T is thread local.

They, of course, cover all the basics for high-performance applications:

* Small type optimizations (although ```seastar::small_set<T>``` and ```seastar::small_map<K,V>``` are missing).
* Non thread safe non-polymorphic shared pointer (local to core) via ```seastar::lw_shared_ptr<T>```[^17]
* Non-thread safe polymorphic shared pointer (local to core) via seastar::shared_ptr<T>
* String with small type optimizations[^18] nor atomics like the libc++[^19]
* Move only bag-o-bytes[^20]
* Circular buffers
* Linux DAIO
* and many many more!

### A Mental Model
![image](/seastar/images/alex-seastar-2.png)

 *Figure 1: Seastar Mental Model. Everything in Seastar happens in a `thread_local’ (per hyper-thread) with the exception of explicit cross-core communication. As with all mental models, this is a simplification and omits details.*

IRL Impact
I’ve been using Seastar for a year and a half on a project called smf[^21] and it has been eye-opening.

```
smf git:(master) cloc --vcs=git                                                        
--------------------------------------------------------------------------------
Language                      files          blank        comment           code
--------------------------------------------------------------------------------
C++                              61            712            512           3607
C/C++ Header                     77            650            824           2761
```
smf is a set of libraries and utilities (like boost:: for C++ or guava for java) designed to be the building blocks of your next distributed systems.

Current benchmarks in microseconds make smf’s RPC (Seastar-backed through DPDK) the lowest tail latency system I’ve tested – including gRPC, Thrift, Cap n’Proto, etc. What matters, however, is not that I’ve managed to build a fast RPC, but the fact that doing it with Seastar was no more work than doing the same thing with facebook::folly and facebook::wangle, boost::asio, or libevent.

![image](/seastar/images/alex-seastar-3.png)

In addition to the RPC, smf has its own Write Ahead Log (WAL).

It is a write-ahead log modeled after an Apache Kafka-like interface or Apache Pulsar. It has topics, partitions, etc. It is designed to have a single reader/writer per topic/partition.

Current benchmarks in milliseconds ==> 41X faster than Apache Kafka
![image](/seastar/images/alex-seastar-4.png)

These massive gains should be expected of many server-side applications.

Want to learn more about Seastar and smf? Please check out my [talk](https://www.scylladb.com/tech-talk/smf-fastest-rpc-west-scylla-summit-2017/) from Scylla Summit 2017 or visit the main Seastar and [smf page](https://github.com/senior7515/smf).

### References 

[^1]: [concord](http://concord.io/) – my previous startup.
[^2]: [future header file](https://github.com/scylladb/seastar/blob/master/core/future.hh).
[^3]: [csp – t hoare](http://weblab.cs.uml.edu/~bill/cs515/CSP_Hoare_78.pdf).
[^4]: [herb sutter](https://www.cs.utexas.edu/~lin/cs380p/Free_Lunch.pdf) – free lunch is over.
[^5]: [akka](http://akka.io/) – actor framework for the jvm.
[^6]: [orleans](https://github.com/dotnet/orleans) – actor framework by Microsoft.
[^7]: [pony](https://www.ponylang.org/) – actor language.
[^8]: [erlang](https://www.erlang.org/) – distributed programming lang.
[^9]: [continuations docs](https://github.com/scylladb/seastar/blob/master/doc/tutorial.md#continuations).
[^10]: [parallelism  is a free variable](https://www.youtube.com/watch?v=cN_DpYBzKso).
[^11]: [seastar shared nothing](http://www.seastar-project.org/shared-nothing/).
[^12]: [seastar networking](http://www.seastar-project.org/networking/).
[^13]: [seastar promises](http://www.seastar-project.org/futures-promises/).
[^14]: [seastar message passing](http://www.seastar-project.org/message-passing/).
[^15]: [facebook’s folly::futures](https://github.com/facebook/folly).
[^16]: [facebook wangle](https://github.com/facebook/wangle).
[^17]: [on-thread-safe shared ptr](https://github.com/scylladb/seastar/blob/master/core/shared_ptr.hh).
[^18]: [seastar::sstring](https://github.com/scylladb/seastar/blob/40a68fa50ebeeb17cd3797af7cddbbcdf07ce61a/core/sstring.hh) – string with small type optimization.
[^19]: [std::basic_string](https://gcc.gnu.org/onlinedocs/gcc-6.2.0/libstdc++/api/a01076_source.html).
[^20]: [seastar::temporary_buffer](https://github.com/scylladb/seastar/blob/743723fc79d8f40a926908181026a709a8cbe719/core/temporary_buffer.hh).
[^21]: [smf](https://github.com/senior7515/smf) – the fastest RPC in the west.



