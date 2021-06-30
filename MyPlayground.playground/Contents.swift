import Foundation

var greeting = "Hello, playground"

class Logger {

  private var hash: [String: String] = [:]
  private let queue = DispatchQueue(label: "my_queue", attributes: .concurrent)

  func read(_ key: String) -> String? {
    return self.hash[key]
  }

  func write(key: String, value: String) {
    queue.asyncAfter(deadline: DispatchTime.now(), qos: .default, flags: .barrier, execute: {
      self.hash[key] = value
    })
  }
}
