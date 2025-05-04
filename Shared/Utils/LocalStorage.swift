// LocalStorage.swift
import Foundation

enum StorageError: Error {
    case fileNotFound
    case failedToDecode
    case failedToEncode
    case failedToDelete
}

class LocalStorage {
    static let shared = LocalStorage()
    private let activityGoalsKey = "activityGoals"
    private let workoutGoalsKey = "workoutGoals"
    
    private init() {}
    
    private func fileURL(for key: String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(key).appendingPathExtension("json")
    }
    
    // MARK: - Activity Goals
    func saveActivityGoal(goal: ActivityGoal) throws {
        var goals = try? getActivityGoals() ?? [] //try?
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
        } else {
            goals.append(goal)
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(goals)
            try data.write(to: fileURL(for: activityGoalsKey), options: [.atomicWrite, .completeFileProtection])
        } catch {
            throw StorageError.failedToEncode
        }
    }
    
    func getActivityGoals() throws -> [ActivityGoal] {
        let url = fileURL(for: activityGoalsKey)
        guard FileManager.default.fileExists(atPath: url.path) else {
            return [] // Return empty array if file does not exist
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([ActivityGoal].self, from: data)
        } catch {
            throw StorageError.failedToDecode
        }
    }
    
    func deleteActivityGoal(goal: ActivityGoal) throws {
        var goals = try? getActivityGoals() ?? []
        goals.removeAll { $0.id == goal.id }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(goals)
            try data.write(to: fileURL(for: activityGoalsKey), options: [.atomicWrite, .completeFileProtection])
        } catch {
            throw StorageError.failedToDelete
        }
    }
    
    // MARK: - Workout Goals
    func saveWorkoutGoal(goal: WorkoutGoal) throws {
        var goals = try? getWorkoutGoals() ?? []  //try?
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
        } else {
            goals.append(goal)
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(goals)
            try data.write(to: fileURL(for: workoutGoalsKey), options: [.atomicWrite, .completeFileProtection])
        } catch {
            throw StorageError.failedToEncode
        }
    }
    
    func getWorkoutGoals() throws -> [WorkoutGoal] {
        let url = fileURL(for: workoutGoalsKey)
        guard FileManager.default.fileExists(atPath: url.path) else {
            return [] // Return empty array if file does not exist
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([WorkoutGoal].self, from: data)
        } catch {
            throw StorageError.failedToDecode
        }
    }
    
    func deleteWorkoutGoal(goal: WorkoutGoal) throws {
        var goals = try? getWorkoutGoals() ?? []
        goals.removeAll { $0.id == goal.id }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(goals)
            try data.write(to: fileURL(for: workoutGoalsKey), options: [.atomicWrite, .completeFileProtection])
        } catch {
            throw StorageError.failedToDelete
        }
    }
}
