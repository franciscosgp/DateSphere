//
//  NetworkMonitor.swift
//  DateSphere
//

import Network

// MARK: - NetworkMonitor class

actor NetworkMonitor {

    // MARK: Static variables

    static let shared = NetworkMonitor()

    // MARK: Variables

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private var _isConnected: Bool = true

    var isConnected: Bool {
        _isConnected
    }

    // MARK: Initializers

    private init() {
        Task { await startMonitoring() }
    }

    // MARK: Methods

    func startMonitoring() async {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { await self?.updateConnectionStatus(path.status == .satisfied) }
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() async {
        monitor.cancel()
    }

    func checkNetworkConnection() throws {
        guard isConnected else {
            throw NetworkError.noConnection
        }
    }

    // MARK: Private methods

    private func updateConnectionStatus(_ status: Bool) {
        _isConnected = status
    }

}
