import UIKit

// MARK: TODO: Create ProfileView, SectionView, ProjectView
// MARK: TODO: Switcher for 42 vs pool projects

class UserViewController: BaseViewController {

    // MARK: IBOutlets

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = .clear
            tableView.dataSource = self
            tableView.estimatedRowHeight = 60
            tableView.rowHeight = UITableView.automaticDimension
            tableView.register(UINib(nibName: Constants.NibNames.project, bundle: nil),
                               forCellReuseIdentifier: Constants.CellIdentifier.project)

            tableView.register(UINib(nibName: Constants.NibNames.profile, bundle: nil),
                               forCellReuseIdentifier: Constants.CellIdentifier.profile)

            tableView.register(UINib(nibName: Constants.NibNames.skill, bundle: nil),
                               forCellReuseIdentifier: Constants.CellIdentifier.skill)

            tableView.register(UINib(nibName: Constants.NibNames.section, bundle: nil),
                               forCellReuseIdentifier: Constants.CellIdentifier.section)
        }
    }

    // MARK: Private properties

    private let presenter = UserPresenter()

    // MARK: Internal properties and methods

    var viewState: UserViewState!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewState.displayName + Constants.Labels.titleEndsWith

        presenter.setDelegate(self)
        presenter.load(for: viewState)
    }

    // MARK: Private methods

    @objc private func handleAddBarButtonItem() {
        presenter.addToFriends(viewState)
    }
}

// MARK: UserPresenterDelegate

extension UserViewController: UserPresenterDelegate {
    func showProfileImage(_ image: UIImage) {
        viewState.image = image
        tableView.reloadData()
    }

    func showLastLocation(_ location: String?) {
        viewState.location = location
        tableView.reloadData()
    }

    func addBarButtonItem() {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddBarButtonItem))
        navigationItem.rightBarButtonItem = barButtonItem
    }

    func hideBarButtonItem() {
        navigationItem.rightBarButtonItem = nil
    }

    func showError(_ error: String) {
        print(error)
    }
}

// MARK: UITableViewDataSource

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
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.profile) as! ProfileCell
            cell.configureCell(user: viewState)

            return cell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.section) as! SectionCell
                cell.configure(with: Constants.SectionNames.projects)

                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.project) as! ProjectCell
            let projectUser = viewState.studyProjects[indexPath.row - 1]
            cell.configureCell(with: projectUser)
            
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.section) as! SectionCell
                cell.configure(with: Constants.SectionNames.skills)

                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.skill) as! SkillCell
            let skill = viewState.studySkills[indexPath.row - 1]
            cell.configureCell(with: skill)
        
            return cell
        }
    }
}
