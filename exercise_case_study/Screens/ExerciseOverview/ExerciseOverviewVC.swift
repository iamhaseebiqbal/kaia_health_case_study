import UIKit

class ExerciseOverviewVC: UIViewController {
    
    private var viewModel: ExerciseOverviewVM!// make non optional
    @IBOutlet private var tableView: UITableView!
    
    var timer: Timer?
    // Keeps reference to same VC for updating the UI
    var detailsVC: ExerciseDetailsVC?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ExerciseOverviewCell", bundle: nil), forCellReuseIdentifier: ExerciseOverviewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func startTraining(_ sender: UIButton) {
        showExerciseDetils(at: 0)
        
        timer = Timer.scheduledTimer(timeInterval: viewModel.transitionSeconds,
                                     target: self,
                                     selector: #selector(transitionToNextExercise),
                                     userInfo: nil,
                                     repeats: true)
        
        // Stop timer on `cancel training`
        detailsVC?.onCancelTraining = { [weak self] in
            self?.timer?.invalidate()
        }
    }
    
    func showExerciseDetils(at row: Int) {
        // If a VC is already presented, just update the UI
        if presentedViewController != nil, presentedViewController == detailsVC {
            detailsVC?.viewModel = viewModel.exterciseDetailsVM(for: row)
            detailsVC?.configureVC()
            return
        }
        
        // Otherwise show new VC
        let detailsVC = ExerciseDetailsVC(nibName: "ExerciseDetailsVC", bundle: nil)
        detailsVC.viewModel = viewModel.exterciseDetailsVM(for: row)
        detailsVC.modalPresentationStyle = .fullScreen
        present(detailsVC, animated: true, completion: nil)
        self.detailsVC = detailsVC
    }
    
    @objc func transitionToNextExercise() {
        if let currentIndex = viewModel.exercises.firstIndex(where: { $0.id == detailsVC?.viewModel?.exercise.id }),
           viewModel.exercises.indices.contains(currentIndex + 1) {
            showExerciseDetils(at: currentIndex + 1)
            return
        }
        timer?.invalidate()
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
        aCell.configure(viewModel.viewModel(for: indexPath.row))
        // TODO implement [safe:]? retrival from arrays
        return aCell
    }
    
}

extension ExerciseOverviewVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showExerciseDetils(at: indexPath.row)
    }
}
