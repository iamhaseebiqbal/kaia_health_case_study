import Foundation

typealias CompletionBlock = () -> Void

struct ExerciseOverviewVM {
    /// Abstract usage For testability
    private var manager: ExerciseSummaryManager
    private var onExercisesReceived: CompletionBlock
    let transitionSeconds: TimeInterval = 5
    
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
    
    func viewModel(for row: Int) -> ExerciseOverviewCellVM {
        let exercise = exercises[row]
        let isMarkedAsFavorite = manager.isMarkedAsFavorite(exercise)
        let onFavoriteTapped = {
            if isMarkedAsFavorite {
                manager.removeFromFavorites(exercise)
                return
            }
            manager.markAsFavorite(exercise)
        }
        return ExerciseOverviewCellVM(exercise: exercise,
                                      isMarkedAsFavorite: isMarkedAsFavorite,
                                      onFavoriteTapped: onFavoriteTapped)
    }
    
    func exterciseDetailsVM(for row: Int) -> ExerciseDetailsVM {
        return ExerciseDetailsVM(manager: manager, exercise: exercises[row])
    }
}
