import Foundation
import TimberSwift

class TimberHandler: TimberApplicationDelegate {
    let timber: TimberProtocol
    
    init() {
        timber = Timber(source: Source(title: "GeospatialKit Example", version: "1.0", emoji: "🗺️"))
        Timber.timberApplicationDelegate = self
    }
    
    func setScreen(title: String, source: Source) {
        print("SCREEN: \"\(title)\", source: \"\(source)\"")
    }
    
    func recordEvent(title: String, properties: [String: Any]?, source: Source) {
        print("EVENT: \"\(title)\", properties: \(properties ?? [:]), source: \"\(source)\"")
    }
    
    func log(message: LogMessage) {
        print("LOG: \"\(message.consoleMessage)\", logLevel: \(message.logLevel), source: \(message.source)")
    }
    
    func log(error: TimberError) {
        print("ERROR: \"\(error.logMessage.message)\" errorType: \(error.errorType.description), with properties: \(error.properties), source: \"\(error.logMessage.source)\"")
    }
    
    func toast(message: String, displayTime: TimeInterval, type: ToastType, source: Source) {
        print("TOAST: \"\(message)\", displayTime: \(displayTime), type: \(type), source: \"\(source)\"")
    }
    
    func startTrace(key: String, identifier: UUID?, properties: [String: Any]?, source: Source) {
        print("TRACE: Start \"\(key)\", identifier: \(identifier?.uuidString ?? ""), properties: \(properties ?? [:]), source: \"\(source)\"")
    }
    
    func incrementTraceCounter(key: String, identifier: UUID?, named: String, by count: Int, source: Source) {
        print("TRACE: Increment \"\(key)\", identifier: \(identifier?.uuidString ?? ""), named: \(named), by: \(count), source: \"\(source)\"")
    }
    
    func stopTrace(key: String, identifier: UUID?, source: Source) {
        print("TRACE: Stop \"\(key)\", identifier: \(identifier?.uuidString ?? ""), source: \"\(source)\"")
    }
    
    func networkActivityStarted(source: Source) {
        print("NETWORK: Started: \"\(source)\"")
    }
    
    func networkActivityEnded(source: Source) {
        print("NETWORK: Ended: \"\(source)\"")
    }
}
