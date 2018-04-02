+++
date = "2017-02-05T07:51:49+01:00"
title = "Message Passing"
draft = false
+++
Threaded applications require inherently expensive locking operations, while the Seastar model can completely avoid locks for cross-CPU communications.

From the programmer’s point of view, Seastar uses futures, promises, and continuations (f/p/c). Where conventional event-driven programming using epoll and userspace libraries such as libevent has made it very difficult to write complex applications, f/p/c makes it easier to write complex asynchronous code.

For example, the following interaction between a sender core, C0, and a receiver core, C1, can take place with no locking required.
* C0: sender -> wait for queue entry (usually immediate) -> enqueue request, allocate promise.
* C1: dequeue request; execute it -> move result to request object -> enqueue request on response queue
* C0: dequeue request; extract response, use it to fulfill promise; destroy request.

Each actual queue, one for requests and a return queue for fulfilled requests, is a simple queue of pointers.

There is one request queue and one return queue per pair of CPU cores on the system. Because a core does not pair with itself, a 16-core system will have 240 request queues and 240 return queues.

## From the Programmer’s Point of View

Seastar provides a versatile set of programming constructs to manage communication between cores. For example:
```
[1]  return conn->read_exactly(4).then(temporary_buffer<char> buf) {
[2]      int id = buf_to_id(buf);
[3]      return smp::submit_to(other_core, [id] {
[4]           return lookup(id);
[5]      });
[6]  }).then([this] (sstring result) {
[7]      return conn->write(result);
[8]  });
```
Line 1 asks TCP to let us know when 4 bytes are available, and place them in a buffer. It will attempt to give us a pointer directly to the area in the packet containing the data, but will allocate a buffer if this is not possible (say, because the 4 bytes arrived in different packets).

Line 2 executes when our four bytes have arrived, and decodes the request (here, into an item ID).

Line 3 asks other_core to do something on our behalf, and to let us know when it is done.

Line 4 is executed on the other core, when it catches up. It calls a lookup function to query the local data store, and returns a result.

Line 5 lets the response from other_core to get back to us.

Line 6 (which is executed immediately after line 3) tells line 3 what to do when we get a response.

Line 7 receives the response from other_core and writes it back into the connection, as a result.

Behind the scenes, quite a lot is happening. A ```.then()``` function may decide to execute its block immediately (for read_exactly(), if the data happens to be available; for ```write()```, if the TCP send buffer is not full). It may decide to defer execution (if data is not available) in which case it allocates a small chunk of memory, and stores the block’s captures in it (these appear inside the square brackets, such as ```[id]``` on line 3) and attach it to whatever it is we’re waiting for—the promise.

```submit_to()``` does something similar, but more specialized: it moves the block into a newly allocated memory area, waits until the smp queue is not too busy, queues up the request on a core-to-core queue, and returns. Eventually the scheduler will poll the response queue, pick up the same object on its way back, and move the result into the promise, firing off the continuation.

## Simplified testing and troubleshooting
Parallel programming is a rare developer skill that is coming into higher and higher demand with increases in CPU counts and workload parallelization. While efficient use of CPU time is necessary, efficient use of programmer time is even more important for most projects. Seastar is the only framework that implements both world-class performance and a comprehensible, testable developer experience.