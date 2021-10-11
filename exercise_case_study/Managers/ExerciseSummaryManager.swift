import Foundation

protocol ExerciseSummaryManager {
    var exercises: [Exercise] { get }
    func fetchExercise(completionHandler: @escaping ([Exercise]) -> Void)
    func markAsFavorite(_ exercise: Exercise)
    func removeFromFavorites(_ exercise: Exercise)
    func isMarkedAsFavorite(_ exercise: Exercise) -> Bool
}

class ExerciseSummaryManagerImpl: ExerciseSummaryManager {
    var exercises: [Exercise] = []
    private let userDefaultsKeyForFavorites = "favorites"
    
    func fetchExercise(completionHandler: @escaping ([Exercise]) -> Void) {
        guard let url = EndPoint.exercises.path.url else {
            completionHandler([])
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("Error with fetching exercise summary: \(error)")
                completionHandler([])
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                completionHandler([])
                return
            }

            if let data = data,
               let exercises = try? JSONDecoder().decode([Exercise].self, from: data) {
                self?.exercises = exercises
                completionHandler(exercises)
            }
        }
        task.resume()
    }
    
    func markAsFavorite(_ exercise: Exercise) {
        let defaults = UserDefaults.standard
        var favorites = defaults.array(forKey: userDefaultsKeyForFavorites) ?? []
        favorites.append(exercise.id)
        defaults.setValue(favorites, forKey: userDefaultsKeyForFavorites)
    }
    
    func removeFromFavorites(_ exercise: Exercise) {
        let defaults = UserDefaults.standard
        var favorites = UserDefaults.standard.array(forKey: userDefaultsKeyForFavorites) as? [Int] ?? []
        favorites.removeAll(where: { $0 == exercise.id })
        defaults.setValue(favorites, forKey: userDefaultsKeyForFavorites)
    }
    
    func isMarkedAsFavorite(_ exercise: Exercise) -> Bool {
        let favorites = UserDefaults.standard.array(forKey: userDefaultsKeyForFavorites) as? [Int] ?? []
        return favorites.contains(exercise.id) == true
    }
}
