//
//  ExerciseDetailsVC.swift
//  exercise_case_study
//
//  Created by Haseeb Iqbal on 11.10.21.
//

import UIKit

class ExerciseDetailsVC: UIViewController {

    @IBOutlet private var icon: UIImageView!
    @IBOutlet private var favoriteButton: UIButton!
    var viewModel: ExerciseDetailsVM?
    var onCancelTraining: CompletionBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
    }
    
    func configureVC() {
        if let url =  viewModel?.iconURL {
            icon.setImage(for: url)
        }
        favoriteButton.setTitle(viewModel?.favoriteButtonTitle, for: .normal)
    }

    @IBAction func cancelTraining(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        onCancelTraining?()
    }
    
    @IBAction func favoriteTapped(_ sender: UIButton) {
        viewModel?.favoriteTapped()
        configureVC()
    }
    
}
