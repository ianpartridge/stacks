import Foundation
import Kitura
import Configuration

public let projectPath = ConfigurationManager.BasePath.project.path

public class App {
    let router = Router()
    let port: Int

    public init() {
        // Load configuration
        let manager = ConfigurationManager()
        manager.load(.environmentVariables)

        // Configure port
        self.port = Int(manager["PORT"] as? String ?? "8080") ?? 8080

        // Configure logging
        initializeLogging(value: manager["LOG_LEVEL"] as? String)

        // Run the metrics initializer
        initializeMetrics(router: router)

        // Add health monitoring endpoint
        initializeHealthRoutes(router: router)
    }

    public func run() {
        Kitura.addHTTPServer(onPort: port, with: router)
        Kitura.run(exitOnFailure: true)
    }
}
