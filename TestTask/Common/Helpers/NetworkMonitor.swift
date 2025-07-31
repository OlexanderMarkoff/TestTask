//
//  NetworkMonitor.swift
//  TestTask
//
//  Created by Olexander Markov on 30.07.2025.
//

import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    private var observers: [any ConnectionObserver] = []

    public private(set) var isConnected: Bool = false

    private init() {
        monitor = NWPathMonitor()
    }

    func startMonitoring() {
        monitor.start(queue: queue)
        self.monitor.pathUpdateHandler = { [weak self] path in
            self?.updateConnectionStatus(isConnected: path.status == .satisfied)
        }
    }

    private func updateConnectionStatus(isConnected: Bool) {
        if self.isConnected != isConnected {
            self.isConnected = isConnected
            observers.forEach {
                $0.connectionChanged(isConnected: isConnected)
            }
        }
    }

    func stopMonitoring() {
        self.monitor.cancel()
    }

    func addConnectionObserver(observer: any ConnectionObserver) {
        observers.append(observer)
        observers = observers.unique { $0.hashValue}
    }

    func removeConnectionObserver(observer: any ConnectionObserver) {
        if let index =  observers.firstIndex(where: { $0.hashValue == observer.hashValue}) {
            observers.remove(at: index)
        }
    }

    deinit {
        self.stopMonitoring()
    }
}

protocol  ConnectionObserver: Hashable {
    func connectionChanged(isConnected: Bool)
}
