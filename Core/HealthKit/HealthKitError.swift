// HealthKitError.swift
import Foundation

enum HealthKitError: Error {
    case notAvailable
    case unauthorized
    case queryFailed(Error)
    case noData
}
