import Foundation

struct ExerciseDetailsVM {
    private(set) var exercise: Exercise
    /// Abstract usage For testability
    private var manager: ExerciseSummaryManager
    
    init(manager: ExerciseSummaryManager, exercise: Exercise) {
        self.manager = manager
        self.exercise = exercise
    }
    
    var favoriteButtonTitle: String {
        return manager.isMarkedAsFavorite(exercise) ? "Unfavorite Exercise" : "Favorite Exercise"
    }
    
    var iconURL: URL? {
        return exercise.cover_image_url.url
    }
    
    func favoriteTapped() {
        let isMarkedAsFavorite = manager.isMarkedAsFavorite(exercise)
        if isMarkedAsFavorite {
            manager.removeFromFavorites(exercise)
            return
        }
        manager.markAsFavorite(exercise)
    }
}
