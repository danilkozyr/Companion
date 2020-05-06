import UIKit

// MARK: TODO: Add Friends Tab and functionallity

// MARK: TODO: Create ProfileView, SectionView, ProjectView
// MARK: TODO: UserViewStateFactory.makeColor(...) -> implement for pool grades.
// MARK: TODO: HandleLastLocation in Presenter, and show it using delegate
// MARK: TODO: Handle Token correctly: get one time, save to cache.
// MARK: TODO: LoadingScreen
// MARK: TODO: Seperate Files for Seperate Instances

class UserViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = .clear
            tableView.dataSource = self
            tableView.estimatedRowHeight = 60
            tableView.rowHeight = UITableView.automaticDimension
            tableView.register(UINib(nibName: Constants.NibNames.project, bundle: nil), forCellReuseIdentifier: ProjectCell.identifier)
            tableView.register(UINib(nibName: Constants.NibNames.profile, bundle: nil), forCellReuseIdentifier: ProfileCell.identifier)
            tableView.register(UINib(nibName: Constants.NibNames.skill, bundle: nil), forCellReuseIdentifier: SkillCell.identifier)
            tableView.register(UINib(nibName: Constants.NibNames.section, bundle: nil), forCellReuseIdentifier: SectionCell.identifier)
        }
    }

    private let presenter = UserPresenter()
    
    var viewState: UserViewState!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewState.displayName + "'s profile"

        presenter.setDelegate(self)
        addBarButtonItem()

        handleLastLocation()
    }

    private func handleLastLocation() {
        guard viewState.location == nil else {
            return
        }

        presenter.downloadLastLocation(for: viewState)
    }


    private func addBarButtonItem() {
        let barButtonItem = UIBarButtonItem(title: "AddToFriends", style: .plain, target: self, action: #selector(handleAddBarButtonItem))

        navigationItem.rightBarButtonItem = barButtonItem
    }

    @objc private func handleAddBarButtonItem() {
//        let image =
        presenter.addToFriends(viewState)
    }
}

extension UserViewController: UserPresenterDelegate {
    func showLastLocation(_ location: String) {
        viewState.location = location
        tableView.reloadData()
    }

    func showError(_ error: String) {
        print(error)
    }
}

extension UserViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return viewState.studyProjects.isEmpty ? 0 : viewState.studyProjects.count + 1
        } else {
            return viewState.studySkills.isEmpty ? 0 : viewState.studySkills.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier) as! ProfileCell
            cell.configureCell(user: viewState)
            
            return cell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: SectionCell.identifier) as! SectionCell
                cell.sectionName.text = Constants.SectionNames.projects
                
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: ProjectCell.identifier) as! ProjectCell
            let projectUser = viewState.studyProjects[indexPath.row - 1]
            cell.configureCell(with: projectUser)
            
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: SectionCell.identifier) as! SectionCell
                cell.sectionName.text = Constants.SectionNames.skills
                
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: SkillCell.identifier) as! SkillCell
            let skill = viewState.studySkills[indexPath.row - 1]
            cell.configureCell(with: skill)
        
            return cell
        }
    }
}
