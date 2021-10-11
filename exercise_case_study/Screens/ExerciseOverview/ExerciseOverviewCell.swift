import UIKit

struct ExerciseOverviewCellVM {
    let exercise: Exercise
    var isMarkedAsFavorite: Bool
    let onFavoriteTapped: CompletionBlock
    
    var imageName: String {
        return isMarkedAsFavorite ? "star.fill" : "star"
    }
}

class ExerciseOverviewCell: UITableViewCell {

    static let reuseIdentifier = "ExerciseOverviewCellReuseIdentifier"
    private var model: ExerciseOverviewCellVM?
    
    @IBOutlet private var icon: UIImageView!
    @IBOutlet private var label: UILabel!
    @IBOutlet private var starButton: UIButton!
    
    func configure(_ model: ExerciseOverviewCellVM) {
        self.model = model
        
        if let iconURL = model.exercise.cover_image_url.url {
            icon.setImage(for: iconURL)
        }
        label.text = model.exercise.name
        starButton.setImage(.init(systemName: model.imageName), for: .normal)
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        if var model = model {
            model.isMarkedAsFavorite = !model.isMarkedAsFavorite
            configure(model)
        }
        
        model?.onFavoriteTapped()
    }
    
}
