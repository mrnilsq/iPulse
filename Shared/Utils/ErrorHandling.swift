// ErrorHandling.swift
import Foundation

// Centralized error handling (you can expand this as needed)
enum AppError: Error {
    case healthKitError(HealthKitError)
    case storageError(StorageError)
    case general(Error)
    
    var localizedDescription: String {
        switch self {
        case .healthKitError(let error):
            return "HealthKit Error: \(error.localizedDescription)"
        case .storageError(let error):
            return "Storage Error: \(error.localizedDescription)"
        case .general(let error):
            return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
}
