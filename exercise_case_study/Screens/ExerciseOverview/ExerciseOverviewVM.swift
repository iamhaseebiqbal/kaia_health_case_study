import Foundation

typealias CompletionBlock = () -> Void

struct ExerciseOverviewVM {
    /// Abstract usage For testability
    private var manager: ExerciseSummaryManager
    private var onExercisesReceived: CompletionBlock
    
    var exercises: [Exercise] {
        return manager.exercises
    }
    
    init(manager: ExerciseSummaryManager, onExercisesReceived: @escaping CompletionBlock) {
        self.manager = manager
        self.onExercisesReceived = onExercisesReceived
        manager.fetchExercise { _ in
            onExercisesReceived()
        }
    }
}
