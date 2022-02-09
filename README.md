* **READ**: reads should be able to happen concurrently, as long as there isn’t a write happening at the same time.
* **WRITE**: no other blocks may be scheduled from the queue while the WRITE process runs

# About Multi Thread
Thread safe is about to avoid data races. Prevent sharing value issues. When no share in intended, give each thread a private copy of the data. When sharing is important, provide explicit synchronization.

### Serial Queues
Only one process can run at a time. If many processes are stuffed in a queue to modify the array, the serial queue will only let one process execute at a time; the array is safe from concurrent processes by design.

```
By default de queue is Serial
let queue = DispatchQueue(label: "MyArrayQueue")
 
queue.async() {
  // Manipulate the array here
}
 
queue.sync() {
  // Read array here
}
```

**The reads are not optimized because multiple read requests have to wait for each other in a queue. However, reads should be able to happen concurrently, as long as there isn’t a write happening at the same time.**

### Concurrent queue
For the writer we will use a **shred exclusion lock** with the **BARRIER** flag to prevent any concurrency at when writing.
The barries flag means no other blocks may be scheduled from the queue while the async/barrier process runs. We continue to use the sync method for reads, but all readers will run in parallel this time because of the concurrent queue attribute.

```
let queue = DispatchQueue(label: "MyArrayQueue", attributes: .concurrent)
 
queue.async(flags: .barrier) {
  // Mutate array here
}
 
queue.sync() {
  // Read array here
}
```
