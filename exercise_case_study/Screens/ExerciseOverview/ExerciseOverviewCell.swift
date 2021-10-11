import UIKit

struct ExerciseOverviewCellVM {
    let exercise: Exercise
    let isMarkedAsFavorite: Bool
    
    var imageName: String {
        return isMarkedAsFavorite ? "star.fill" : "star"
    }
}

class ExerciseOverviewCell: UITableViewCell {

    static let reuseIdentifier = "ExerciseOverviewCellReuseIdentifier"
    
    @IBOutlet private var icon: UIImageView!
    @IBOutlet private var label: UILabel!
    @IBOutlet private var starButton: UIButton!
    
    func configure(_ model: ExerciseOverviewCellVM) {
        if let iconURL = model.exercise.cover_image_url.url {
            icon.setImage(for: iconURL)
        }
        label.text = model.exercise.name
        starButton.setImage(.init(systemName: model.imageName), for: .normal)
    }
    
}
