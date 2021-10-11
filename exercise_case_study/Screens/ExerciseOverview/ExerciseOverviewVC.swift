import UIKit

class ExerciseOverviewVC: UIViewController {
    
    private var viewModel: ExerciseOverviewVM!// make non optional
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        // [TODO] set in init, make non optional
        viewModel = ExerciseOverviewVM(manager: ExerciseSummaryManagerImpl(), onExercisesReceived: { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func startTraining(_ sender: UIButton) {
        
    }
    
}

extension ExerciseOverviewVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = UITableViewCell()
        aCell.textLabel?.text = viewModel.exercises[indexPath.row].name
        return aCell
    }
    
    
}

extension ExerciseOverviewVC: UITableViewDelegate {
    
}
