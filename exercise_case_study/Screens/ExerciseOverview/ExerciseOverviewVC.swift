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
        tableView.register(UINib(nibName: "ExerciseOverviewCell", bundle: nil), forCellReuseIdentifier: ExerciseOverviewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func startTraining(_ sender: UIButton) {
        
    }
    
}

extension ExerciseOverviewVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.exercises.count ?? 0 // TODO
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let aCell = tableView.dequeueReusableCell(withIdentifier: ExerciseOverviewCell.reuseIdentifier) as? ExerciseOverviewCell else {
            return UITableViewCell()
        }
        aCell.configure(ExerciseOverviewCellVM(exercise: viewModel.exercises[indexPath.row], isMarkedAsFavorite: false)) // [TODO] fav state
        // TODO [safe: ?]
        return aCell
    }
    
    
}

extension ExerciseOverviewVC: UITableViewDelegate {
    
}
