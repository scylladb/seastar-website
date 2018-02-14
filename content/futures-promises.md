+++
date = "2017-02-05T07:51:49+01:00"
title = "Futures and Promises"
draft = false
+++
# Paradigms for parallellization
Solutions for coordinating work across multiple cores are many. Some are highly programmer-friendly and enable development of software that works exactly if it were running on a single core. For example the classic Unix process model is designed to keep each process in total isolation and relies on kernel code to maintain a separate virtual memory space per process. Unfortunately this increases the overhead at the OS level.

# Software development challenges


```"Programs must be written for people to read, and only incidentally for machines to execute."```
— Harold Abelson and Gerald Jay Sussman

Hardware has changed to the point where the assumptions originally made on small numbers of CPU cores are no longer valid.

* Processes are extremely self-contained but have high overhead.

* Threads impose additional coordination costs on both the programmer and the application infrastructure, and are notoriously difficult to debug.

* Pure event-driven programming can result in codebases that are difficult to test and extend.

An ideal solution would have:

* Straightforward design to be comprehensible for program design and development

* Minimum overhead on modern hardware

* Low debugging costs

# Solution: Seastar futures and promises
The solution is a model known as “futures and promises”.

A future is a data structure that represents some yet-undetermined result. A promise is the provider of this result.

It is sometimes helpful to think of a promise/future pair as a first-in first-out queue with a maximum length of one item, which may be used only once. The promise is the producing end of the queue, while the future is the consuming end. Like FIFOs, futures and promises are used to decouple the data producer and the data consumer.

Basic futures and promises are implemented in the C++ standard library, and in Boost.

However, the optimized Seastar implementations of futures and promises are different. While the standard implementation targets coarse-grained tasks that may block and take a long time to complete, Seastar futures and promises are used to manage fine-grained, non-blocking tasks. In order to meet this requirement efficiently:

* Seastar futures and promises require no locking.
* Seastar futures and promises do not allocate memory.
* Seastar futures support continuations.

# Example
A simple example of a future/promise pair is:
```
#include "seastar/core/reactor.hh"
#include "seastar/core/sstring.hh"
#include "seastar/core/app-template.hh"
future<sstring>
compute_something_asynchronously() {
     // pretend some complex computation has taken place
     return make_ready_future<sstring>("world");
}

int main(int ac, char** av) {
    return app_template().run(ac, av, [] {
	 compute_something_asynchronously().then([] (sstring who) {
	      print("hello, %s\n", who);
	      engine.exit(0);
	 });
    });
}
```
More examples are available in the Seastar online documentation on futures and promises.