---
title: "Seastar: The future<> is Here"
date: 2018-02-13T08:02:27-08:00
---
By Alexander Gallego

This is a cross-post from [Alexander's Blog](https://www.alexgallego.org/concurrency/smf/2017/12/17/future.html).

On June 8, 2016, Avi Kivity came to NYC to present ScyllaDB. During his search for a quick open desk to do some work, I volunteered open spaces we had at Concord1. We talked lock-free algorithms, memory reclamation techniques, threading models, Concord and distributed streaming engines, even C vs C++. Five hours later I was convinced that Seastar was the best systems framework I’d ever come across.

I’ve now been using Seastar for almost two years and I haven’t changed my mind.

### The future<> is all about concurrency

For the truly impatient, the future<> is [here](https://github.com/scylladb/seastar/blob/master/core/future.hh)

In 1978 [news](http://weblab.cs.uml.edu/~bill/cs515/CSP_Hoare_78.pdf), T. Hoare prophetically said the future was about computers getting more cores and not increasing in clock speed. In 2004 Herb Sutter coined the same trend as The Free Lunch is Over4. The ```seastar::future<>``` is a tool to take advantage of multi-core, multi-socket machines – a way to structure your software to grow gracefully with your hardware. There are many other tools that fit this new modality, from lock-free algorithms and to co-routines, to channels[^3], not to mention actor-style message passing, among many other paradigms like full-on distributed programming languages. [^5][^6][^7][^8]

```“Instead of driving clock speeds and straight-line instruction throughput ever higher, they are instead turning en masse to hyperthreading and multicore architectures”``` – Herb Sutter

```seastar::future<>```’s are for concurrent software construction. In addition, their design makes them composable. You can take any two futures and chain them together via ```.then()``` operator and yield a new future[^9]. Although you can combine, mix, map-reduce, filter, chain, fail, complete, generate, fulfill, sleep, expire futures, etc, they are fundamentally about program structure. Such program structure can execute in parallel, but doesn’t have to. When you have concurrent structure, parallelism is a free variable[^10]. That is to say, you can turn up or down the number of ```simultaneous``` execution units/cores/threads without changing your program. In this paradigm, you worry about correct program structure and someone else worries about the execution.
![httpd-throughput](/seastar/images/alex-seastar-1.png)

Seastar is an intrusive building block. Once you start composing Seastar-driven asynchronous building blocks, you have to go out of your way – really – to build anything synchronous, and that’s powerful. Structurally, Seastar has the same effect as actor frameworks like Akka5, Orleans[^6], or even languages like Pony[^7] or Erlang[^8] have. Once you have an actor, they spread **virally** through your system making everything an actor.

Philosophically, actor frameworks and distributed languages differ from Seastar. While the former try to give the programmer higher abstractions and a runtime to hide machine details like IO or CPU scheduling, Seastar takes the opposite approach. It gives you – the wise programmer – abilities to tune and control almost every part of the future<> runtime. This includes IO shares scheduling, CPU shares scheduling, in addition to batteries included approach when it comes to taking advantage of hardware for dealing with filesystems, networking, DMA, etc.

Both approaches, however, are intrinsically safe. The programmer worries about correctness and construction while the frameworks worry about efficient execution. Counter to general wisdom, it is actually faster and more scalable than the synchronous approach. While the machine does more work, it is executing your code simultaneously. This simultaneity is the key to finishing work sooner.

At its core, from the project site, Seastar promises:

* Shared-nothing design[^11]
* High-performance networking[^12]
* Futures and promises[^13]
* Message passing[^14]

… but it is much more, so let’s get technical and find out how Seastar executes these concurrency building blocks.


[^1]: concord – my previous startup.
[^2]: future header file.
[^3]: csp – t hoare.
[^4]: herb sutter – free lunch is over.
[^5]: akka – actor framework for the jvm.
[^6]: orleans – actor framework by Microsoft.
[^7]: pony – actor language.
[^8]: erlang – distributed programming lang.
[^9]: continuations docs.
[^10]: parallelism is a free variable.
[^11]: seastar shared nothing.
[^12]: seastar networking.
[^13]: seastar promises.
[^14]: seastar message passing.
[^15]: facebook’s folly::futures.
[^16]: facebook wangle.
[^17]: on-thread-safe shared ptr.
[^18]: seastar::sstring – string with small type optimization.
[^19]: std::basic_string.
[^20]: seastar::temporary_buffer.
[^21]: smf – the fastest RPC in the west.



