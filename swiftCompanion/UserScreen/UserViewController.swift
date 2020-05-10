import UIKit

// MARK: TODO: Create ProfileView, SectionView, ProjectView

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
    private var showMainProfile = true
    private var isFriend = false

    // MARK: Internal properties and methods

    var viewState: UserViewState!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewState.displayName + Constants.Labels.titleEndsWith

        presenter.setDelegate(self)
        presenter.load(for: viewState)
    }

    // MARK: Private methods

    @objc private func handleFriendsBarButtonItem() {
        if isFriend {
            presenter.deleteFromFriends(viewState)
        } else {
            presenter.addToFriends(viewState)
        }
    }

    @objc private func handleProjectShuffle() {
        showMainProfile.toggle()
        handleBarButtonItems(isFriend: isFriend)
        tableView.reloadData()
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

    func handleBarButtonItems(isFriend: Bool) {
        self.isFriend = isFriend

        let friendBarButtonItem = UIBarButtonItem(title: isFriend ? "U" : "F",
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(handleFriendsBarButtonItem))

        let mainProfileSwitchBarButtonItem = UIBarButtonItem(title: showMainProfile ? "Piscine" : "42",
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(handleProjectShuffle))
        navigationItem.rightBarButtonItems = [friendBarButtonItem, mainProfileSwitchBarButtonItem]
    }


    func showError(_ message: String) {
        let alert = UIAlertController().create(title: Constants.Titles.error,
                                               message: message,
                                               action: Constants.Labels.ok)
        present(alert, animated: true)
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
            return showMainProfile ? viewState.studyProjects.count : viewState.poolProjects.count
        } else {
            return showMainProfile ? viewState.studySkills.count : viewState.poolSkills.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.profile) as! ProfileCell
            cell.configureCell(user: viewState, isMainProfile: showMainProfile)
            return cell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.section) as! SectionCell
                cell.configure(with: Constants.SectionNames.projects)
                return cell
            }

            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.project) as! ProjectCell
            let projects = showMainProfile ? viewState.studyProjects : viewState.poolProjects
            let project = projects[indexPath.row - 1]

            cell.configureCell(with: project)
            
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.section) as! SectionCell
                cell.configure(with: Constants.SectionNames.skills)

                return cell
            }

            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.skill) as! SkillCell
            let skills = showMainProfile ? viewState.studySkills : viewState.poolSkills
            let skill = skills[indexPath.row - 1]

            cell.configureCell(with: skill)
            return cell
        }
    }
}
