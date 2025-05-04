// HealthKitManager.swift
import HealthKit
import Combine

class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    
    private let healthStore = HKHealthStore()
    @Published var healthKitAuthorizationDenied = false
    @Published var error: Error?
    
    private init() {}
    
    // Request HealthKit authorization
    func requestAuthorization() async {
        guard HKHealthStore.isHealthDataAvailable() else {
            healthKitAuthorizationDenied = true
            return
        }
        
        let typesToRead: Set = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .sleepAnalysis)!, // Include sleep analysis
            HKObjectType.quantityType(forIdentifier: .appleStandTime)!,
        ]
        
        do {
            try await healthStore.requestAuthorization(toShare: nil, read: typesToRead)
        } catch {
            self.error = error
            healthKitAuthorizationDenied = true
        }
    }
    
    // MARK: - Daily Metrics
    func getDailyMetrics(startDate: Date = Date().startOfDay, endDate: Date = Date()) async -> DailyMetrics {
        let group = DispatchGroup()
        group.enter()
        
        var dailyMetrics = DailyMetrics(dailyMetrics: [])
        
        let stepCountQuery = createQuantitySumQuery(
            quantityTypeIdentifier: .stepCount,
            startDate: startDate,
            endDate: endDate
        ) { result in
            defer { group.leave() }
            switch result {
            case .success(let quantity):
                let stepCount = quantity?.doubleValue(for: HKUnit.count()) ?? 0
                let dailyMetric = DailyMetric(date: endDate, steps: stepCount, averageHeartRate: nil, sleepDuration: nil, standHours: 0)
                dailyMetrics.dailyMetrics.append(dailyMetric)
            case .failure(let error):
                print("Error fetching step count: \(error)") //log
            }
        }
        
        group.enter()
        let heartRateQuery = createAverageHeartRateQuery(
            startDate: startDate,
            endDate: endDate
        ) { result in
            defer { group.leave() }
            switch result {
            case .success(let averageHeartRate):
                if let index = dailyMetrics.dailyMetrics.firstIndex(where: {$0.date == endDate}){
                    dailyMetrics.dailyMetrics[index].averageHeartRate = averageHeartRate
                } else {
                    let dailyMetric = DailyMetric(date: endDate, steps: 0, averageHeartRate: averageHeartRate, sleepDuration: nil, standHours: 0)
                    dailyMetrics.dailyMetrics.append(dailyMetric)
                }
            case .failure(let error):
                print("Error fetching average heart rate: \(error)")
            }
        }
        
        group.enter()
        let sleepQuery = createSleepDurationQuery(startDate: startDate, endDate: endDate) { result in
            defer { group.leave() }
            switch result {
            case .success(let sleepDuration):
                if let index = dailyMetrics.dailyMetrics.firstIndex(where: {$0.date == endDate}){
                    dailyMetrics.dailyMetrics[index].sleepDuration = sleepDuration
                }
                else{
                    let dailyMetric = DailyMetric(date: endDate, steps: 0, averageHeartRate: nil, sleepDuration: sleepDuration, standHours: 0)
                    dailyMetrics.dailyMetrics.append(dailyMetric)
                }
            case .failure(let error):
                print("Error fetching sleep duration: \(error)")
            }
        }
        
        group.enter()
        let standTimeQuery = createStandTimeQuery(startDate: startDate, endDate: endDate) { result in
            defer { group.leave() }
            switch result{
            case .success(let standTime):
                if let index = dailyMetrics.dailyMetrics.firstIndex(where: {$0.date == endDate}){
                    dailyMetrics.dailyMetrics[index].standHours = standTime
                } else {
                    let dailyMetric = DailyMetric(date: endDate, steps: 0, averageHeartRate: nil, sleepDuration: nil, standHours: standTime)
                    dailyMetrics.dailyMetrics.append(dailyMetric)
                }
            case .failure(let error):
                print("Error fetching stand time: \(error)")
            }
        }
        
        healthStore.execute(stepCountQuery)
        healthStore.execute(heartRateQuery)
        healthStore.execute(sleepQuery)
        healthStore.execute(standTimeQuery)
        
        group.wait()
        
        return dailyMetrics
    }
    
    // MARK: - Recent Workouts
    func getRecentWorkouts(startDate: Date = Date().startOfDay, endDate: Date = Date()) async -> [WorkoutModel] {
        let group = DispatchGroup()
        group.enter()
        
        var workouts: [WorkoutModel] = []
        
        let workoutQuery = HKQuery.predicateForWorkouts(with: .greaterThanOrEqualTo, start: startDate, end: endDate)
        
        healthStore.execute(HKQuery.workoutQuery(with: workoutQuery) { (_, results, error) in
            defer { group.leave() }
            if let error = error {
                print("Error fetching workouts: \(error)")
                return
            }
            
            if let results = results as? [HKWorkout] {
                workouts = results.map { WorkoutModel(workout: $0) }
            }
        })
        
        group.wait()
        return workouts
    }
    
    // MARK: - Weekly Stats
    func getWeeklyStats(startDate: Date = Date().startOfWeek, endDate: Date = Date()) async -> WeeklyStats {
        let group = DispatchGroup()
        group.enter()
        
        var dailyMetricsArray: [DailyMetric] = []
        
        let stepCountQuery = createQuantitySumQuery(
            quantityTypeIdentifier: .stepCount,
            startDate: startDate,
            endDate: endDate
        ) { result in
            defer { group.leave() }
            switch result {
            case .success(let quantity):
                let stepCount = quantity?.doubleValue(for: HKUnit.count()) ?? 0
                let dailyMetric = DailyMetric(date: endDate, steps: stepCount, averageHeartRate: nil, sleepDuration: nil, standHours: 0)
                dailyMetricsArray.append(dailyMetric)
            case .failure(let error):
                print("Error fetching weekly step count: \(error)")
            }
        }
        
        group.enter()
        let heartRateQuery = createAverageHeartRateQuery(startDate: startDate, endDate: endDate) { result in
            defer { group.leave() }
            switch result {
            case .success(let averageHeartRate):
                let dailyMetric = DailyMetric(date: endDate, steps: 0, averageHeartRate: averageHeartRate, sleepDuration: nil, standHours: 0)
                if let index = dailyMetricsArray.firstIndex(where: {$0.date == endDate}){
                    dailyMetricsArray[index].averageHeartRate = averageHeartRate
                } else {
                   dailyMetricsArray.append(dailyMetric)
                }
            case .failure(let error):
                print("Error fetching weekly average heart rate: \(error)")
            }
        }
        
        group.enter()
        let sleepQuery = createSleepDurationQuery(startDate: startDate, endDate: endDate) { result in
            defer { group.leave() }
            switch result {
            case .success(let sleepDuration):
                let dailyMetric = DailyMetric(date: endDate, steps: 0, averageHeartRate: nil, sleepDuration: sleepDuration, standHours: 0)
                if let index = dailyMetricsArray.firstIndex(where: {$0.date == endDate}){
                    dailyMetricsArray[index].sleepDuration = sleepDuration
                }
                else{
                    dailyMetricsArray.append(dailyMetric)
                }
            case .failure(let error):
                print("Error fetching weekly sleep duration: \(error)")
            }
        }
        
        group.enter()
        let standTimeQuery = createStandTimeQuery(startDate: startDate, endDate: endDate) { result in
            defer { group.leave() }
            switch result{
            case .success(let standTime):
                let dailyMetric = DailyMetric(date: endDate, steps: 0, averageHeartRate: nil, sleepDuration: nil, standHours: standTime)
                if let index = dailyMetricsArray.firstIndex(where: {$0.date == endDate}){
                    dailyMetricsArray[index].standHours = standTime
                } else {
                   dailyMetricsArray.append(dailyMetric)
                }
            case .failure(let error):
                print("Error fetching weekly stand time: \(error)")
            }
        }
        
        healthStore.execute(stepCountQuery)
        healthStore.execute(heartRateQuery)
        healthStore.execute(sleepQuery)
        healthStore.execute(standTimeQuery)
        
        group.wait()
        
        return WeeklyStats(dailyMetrics: dailyMetricsArray)
    }
    
    // MARK: - Monthly Stats
      func getMonthlyStats(startDate: Date = Date().startOfMonth, endDate: Date = Date()) async -> WeeklyStats {
          let group = DispatchGroup()
          group.enter()
          
          var dailyMetricsArray: [DailyMetric] = []
          
          let stepCountQuery = createQuantitySumQuery(
              quantityTypeIdentifier: .stepCount,
              startDate: startDate,
              endDate: endDate
          ) { result in
              defer { group.leave() }
              switch result {
              case .success(let quantity):
                  let stepCount = quantity?.doubleValue(for: HKUnit.count()) ?? 0
                  let dailyMetric = DailyMetric(date: endDate, steps: stepCount, averageHeartRate: nil, sleepDuration: nil, standHours: 0)
                  dailyMetricsArray.append(dailyMetric)
              case .failure(let error):
                  print("Error fetching monthly step count: \(error)")
              }
          }
          
          group.enter()
          let heartRateQuery = createAverageHeartRateQuery(startDate: startDate, endDate: endDate) { result in
              defer { group.leave() }
              switch result {
              case .success(let averageHeartRate):
                let dailyMetric = DailyMetric(date: endDate, steps: 0, averageHeartRate: averageHeartRate, sleepDuration: nil, standHours: 0)
                if let index = dailyMetricsArray.firstIndex(where: {$0.date == endDate}){
                    dailyMetricsArray[index].averageHeartRate = averageHeartRate
                } else {
                   dailyMetricsArray.append(dailyMetric)
                }
              case .failure(let error):
                  print("Error fetching monthly average heart rate: \(error)")
              }
          }
          
          group.enter()
          let sleepQuery = createSleepDurationQuery(startDate: startDate, endDate: endDate) { result in
              defer { group.leave() }
              switch result {
              case .success(let sleepDuration):
                let dailyMetric = DailyMetric(date: endDate, steps: 0, averageHeartRate: nil, sleepDuration: sleepDuration, standHours: 0)
                if let index = dailyMetricsArray.firstIndex(where: {$0.date == endDate}){
                    dailyMetricsArray[index].sleepDuration = sleepDuration
                }
                else{
                    dailyMetricsArray.append(dailyMetric)
                }
              case .failure(let error):
                  print("Error fetching monthly sleep duration: \(error)")
              }
          }
          
          group.enter()
          let standTimeQuery = createStandTimeQuery(startDate: startDate, endDate: endDate) { result in
              defer { group.leave() }
              switch result{
              case .success(let standTime):
                let dailyMetric = DailyMetric(date: endDate, steps: 0, averageHeartRate: nil, sleepDuration: nil, standHours: standTime)
                if let index = dailyMetricsArray.firstIndex(where: {$0.date == endDate}){
                    dailyMetricsArray[index].standHours = standTime
                } else {
                   dailyMetricsArray.append(dailyMetric)
                }
              case .failure(let error):
                  print("Error fetching monthly stand time: \(error)")
              }
          }
          
          healthStore.execute(stepCountQuery)
          healthStore.execute(heartRateQuery)
          healthStore.execute(sleepQuery)
          healthStore.execute(standTimeQuery)
          
          group.wait()
          
          return WeeklyStats(dailyMetrics: dailyMetricsArray)
      }
    
    // MARK: - Activity Summary
    func getActivitySummary(startDate: Date, endDate: Date) async -> ActivitySummary {
        let group = DispatchGroup()
        group.enter()
        
        var workoutCount = 0
        var activeTime = TimeInterval(0)
        var caloriesBurned = 0.0
        var steps = 0
        var activeStreak = 0
        var mostFrequentWorkoutType: HKWorkoutActivityType?
        
        // Fetch workouts
        let workoutQuery = HKQuery.predicateForWorkouts(with: .greaterThanOrEqualTo, start: startDate, end: endDate)
        healthStore.execute(HKQuery.workoutQuery(with: workoutQuery) { (_, results, error) in
            defer { group.leave() }
            if let error = error {
                print("Error fetching workouts for summary: \(error)")
                return
            }
            
            if let results = results as? [HKWorkout] {
                workoutCount = results.count
                activeTime = results.reduce(0) { $0 + $1.duration }
                
                // Determine most frequent workout type
                let workoutTypes = results.map { $0.workoutActivityType }
                let typeCounts = workoutTypes.reduce(into: [HKWorkoutActivityType: Int]()) { counts, type in
                    counts[type, default: 0] += 1
                }
                mostFrequentWorkoutType = typeCounts.max { a, b in a.value < b.value }?.key
            }
        })
        
        group.enter()
        // Fetch calories burned
        let calorieQuery = createQuantitySumQuery(
            quantityTypeIdentifier: .activeEnergyBurned,
            startDate: startDate,
            endDate: endDate
        ) { result in
            defer { group.leave() }
            switch result {
            case .success(let quantity):
                caloriesBurned = quantity?.doubleValue(for: HKUnit.kilocalorie()) ?? 0
            case .failure(let error):
                print("Error fetching calories burned: \(error)")
            }
        }
        healthStore.execute(calorieQuery)
        
        group.enter()
        // Fetch steps
        let stepQuery = createQuantitySumQuery(
            quantityTypeIdentifier: .stepCount,
            startDate: startDate,
            endDate: endDate
        ) { result in
            defer { group.leave() }
            switch result {
            case .success(let quantity):
                steps = quantity?.doubleValue(for: HKUnit.count()) ?? 0
            case .failure(let error):
                print("Error fetching steps: \(error)")
            }
        }
        healthStore.execute(stepQuery)
        
        // Calculate active streak (simplified -  requires more complex logic)
        activeStreak = calculateActiveStreak(startDate: startDate, endDate: endDate)
        
        group.wait()
        
        return ActivitySummary(
            workoutCount: workoutCount,
            activeTime: activeTime,
            caloriesBurned: caloriesBurned,
            steps: steps,
            activeStreak: activeStreak,
            mostFrequentWorkoutType: mostFrequentWorkoutType
        )
    }
    
    // MARK: - Top Activities
    func getTopActivities(startDate: Date, endDate: Date) async -> [ActivityDetail] {
        let group = DispatchGroup()
        group.enter()
        
        var activities: [ActivityDetail] = []
        
        let workoutQuery = HKQuery.predicateForWorkouts(with: .greaterThanOrEqualTo, start: startDate, end: endDate)
        healthStore.execute(HKQuery.workoutQuery(with: workoutQuery) { (_, results, error) in
            defer { group.leave() }
            if let error = error {
                print("Error fetching workouts for top activities: \(error)")
                return
            }
            
            if let results = results as? [HKWorkout] {
                // Group workouts by type and calculate total duration
                let groupedWorkouts = results.reduce(into: [HKWorkoutActivityType: (count: Int, totalDuration: TimeInterval)]()) { grouped, workout in
                    grouped[workout.workoutActivityType, default: (0, 0)].count += 1
                    grouped[workout.workoutActivityType, default: (0, 0)].totalDuration += workout.duration
                }
                
                // Convert to ActivityDetail
                activities = groupedWorkouts.map { (type, data) -> ActivityDetail in
                    let averageDuration = data.totalDuration / Double(data.count)
                    return ActivityDetail(type: type, frequency: data.count, totalDuration: data.totalDuration, averageDuration: averageDuration)
                }
                // Sort by frequency (most frequent first)
                activities.sort { $0.frequency> $1.frequency }
            }
        })
        
        group.wait()
        return activities
    }
    
    // MARK: - Performance Insights
    func getPerformanceInsights(startDate: Date, endDate: Date) async -> [PerformanceInsight] {
        let group = DispatchGroup()
        group.enter()
        
        var insights: [PerformanceInsight] = []
        
        // Fetch workouts
        let workoutQuery = HKQuery.predicateForWorkouts(with: .greaterThanOrEqualTo, start: startDate, end: endDate)
        healthStore.execute(HKQuery.workoutQuery(with: workoutQuery) { (_, results, error) in
            defer { group.leave() }
            if let error = error {
                print("Error fetching workouts for performance insights: \(error)")
                return
            }
            
            if let results = results as? [HKWorkout] {
                // Example insight: Average workout duration
                if !results.isEmpty {
                    let totalDuration = results.reduce(0) { $0 + $1.duration }
                    let averageDuration = totalDuration / Double(results.count)
                    let insight = PerformanceInsight(type: .averageWorkoutDuration, value: averageDuration, unit: "minutes")
                    insights.append(insight)
                }
                
                // Example insight: Longest workout
                if let longestWorkout = results.max(by: { $0.duration < $1.duration }) {
                    let insight = PerformanceInsight(type: .longestWorkout, value: longestWorkout.duration, unit: "minutes")
                    insights.append(insight)
                }
                
                // Example: Most active day (simplified)
                let mostActiveDay = self.mostActiveDay(from: results)
                if let mostActiveDay = mostActiveDay {
                    let insight = PerformanceInsight(type: .mostActiveDay, value: Double(mostActiveDay.day), unit: "")
                    insights.append(insight)
                }
            }
        })
        
        group.wait()
        return insights
    }
    
    //Helper functions
    
    // Function to calculate average heart rate
    private func createAverageHeartRateQuery(startDate: Date, endDate: Date, completion: @escaping (Result<Double?, Error>) -> Void) -> HKQuery {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        
        let heartRateQuery = HKStatisticsQuery(quantityType: heartRateType, quantitySamplePredicate: HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate), options: .discreteAverage) { _, result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let result = result, let averageQuantity = result.averageQuantity() {
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                let averageHeartRate = averageQuantity.doubleValue(for: heartRateUnit)
                completion(.success(averageHeartRate))
            } else {
                completion(.success(nil)) // No data
            }
        }
        return heartRateQuery
    }
    
    // Function to create a quantity sum query
    private func createQuantitySumQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier, startDate: Date, endDate: Date, completion: @escaping (Result<HKQuantity?, Error>) -> Void) -> HKQuery {
        let quantityType = HKQuantityType.quantityType(forIdentifier: quantityTypeIdentifier)!
        
        let quantitySumQuery = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate), options: .cumulativeSum) { _, result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let result = result, let sum = result.sumQuantity() {
                completion(.success(sum))
            } else {
                completion(.success(nil))
            }
        }
        return quantitySumQuery
    }
    
    // Function to create a query for sleep duration
    private func createSleepDurationQuery(startDate: Date, endDate: Date, completion: @escaping (Result<TimeInterval?, Error>) -> Void) -> HKQuery {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKCategoryQuery(sampleType: sleepType, samplePredicate: predicate, options: .none) { _, results, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let results = results as? [HKCategorySample] else {
                completion(.success(nil))
                return
            }
            
            var totalSleepDuration: TimeInterval = 0
            for sample in results {
                if sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue {
                    totalSleepDuration += sample.endDate.timeIntervalSince(sample.startDate)
                }
            }
            completion(.success(totalSleepDuration))
        }
        return query
    }
    
    private func createStandTimeQuery(startDate: Date, endDate: Date, completion: @escaping (Result<Int, Error>) -> Void) -> HKQuery{
        let standType = HKQuantityType.quantityType(forIdentifier: .appleStandTime)!
        
        let query = HKStatisticsQuery(quantityType: standType, quantitySamplePredicate: HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .cumulativeSum) ){ _, result, error in
            if let error = error{
                completion(.failure(error))
                return
            }
            
            if let result = result, let sum = result.sumQuantity(){
                let standHours = sum.doubleValue(for: HKUnit.hour())
                completion(.success(Int(standHours)))
            } else {
                completion(.success(0))
            }
        }
        return query
    }
    
    //Helper Functions
    private func calculateActiveStreak(startDate: Date, endDate: Date) -> Int {
        // Simplified:  Needs more complex logic to get real active streak.
        return 0
    }
    
    private func mostActiveDay(from workouts: [HKWorkout]) -> (day: Int, count: Int)? {
        guard !workouts.isEmpty else { return nil }
        
        let calendar = Calendar.current
        let dayCounts = workouts.reduce(into: [Int: Int]()) { counts, workout in
            let day = calendar.component(.day, from: workout.startDate)
            counts[day, default: 0] += 1
        }
        
        return dayCounts.max { a, b in a.value < b.value }
    }
}
