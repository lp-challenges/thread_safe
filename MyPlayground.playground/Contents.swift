import Foundation

var greeting = "Hello, playground"

class Logger {

  private var hash: [String: Int] = [:]
  private let queue = DispatchQueue(label: "my_queue", attributes: .concurrent)

  func read(_ key: String) -> Int? {
    var value: Int?
    queue.sync {
      value = hash[key]
    }
    return value
  }

  func write(key: String, value: Int) {
    queue.async(qos: .default, flags: .barrier) {
      self.hash[key] = value
    }
  }
}

func run() {
  let logger = Logger()
  var number: Int = 0
  DispatchQueue.concurrentPerform(iterations: 50) { index in
    logger.write(key: "key", value: number)
    number += 1
    print(logger.read("key") ?? "error")
  }
}

run()

