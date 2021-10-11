//
//  ViewController.swift
//  exercise_case_study
//
//  Created by Haseeb Iqbal on 11.10.21.
//

import UIKit

class ViewController: UIViewController {

    // For testability
    var manager: ExerciseSummaryManagerImpl = ExerciseSummaryManagerImpl() // [TODO] - make it private and set in `init`
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        manager.fetchExercise { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func startTraining(_ sender: UIButton) {
        
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = UITableViewCell()
        aCell.textLabel?.text = manager.exercises[indexPath.row].name
        return aCell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
}

struct Exercise: Codable {
    let id: Int
    let name: String
    let cover_image_url: String
    // let video_url: String
}

protocol ExerciseSummaryManager {
    var exercises: [Exercise] { get }
    func fetchExercise(completionHandler: @escaping ([Exercise]) -> Void)
    func markAsFavorite(_ exercise: Exercise)
    func removeFromFavorites(_ exercise: Exercise)
}

class ExerciseSummaryManagerImpl: ExerciseSummaryManager {
    var exercises: [Exercise] = []
    
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
        
    }
    
    func removeFromFavorites(_ exercise: Exercise) {
        
    }
}

enum EndPoint: String {
    case exercises = "jsonBlob/027787de-c76e-11eb-ae0a-39a1b8479ec2"
    
    static let apiHost = "https://jsonblob.com/api/"
    
    var path: String {
        return EndPoint.apiHost + rawValue
    }
}

extension String {
    var url: URL? {
        return URL(string: self)
    }
}
