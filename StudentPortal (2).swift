import UIKit

// MARK: - Model

struct Student {
    let name: String
    let sex: String
    let bloodGroup: String
    let enrollment: String
    let sid: String
    let course: String
    let semester: String

    static let all: [Student] = [
        Student(name: "Aarav Sharma",  sex: "Male",   bloodGroup: "B+",  enrollment: "GV2301001", sid: "SID101", course: "B.Tech CSE",  semester: "5th"),
        Student(name: "Priya Verma",   sex: "Female", bloodGroup: "O+",  enrollment: "GV2301002", sid: "SID102", course: "B.Tech CSE",  semester: "5th"),
        Student(name: "Rohan Gupta",   sex: "Male",   bloodGroup: "A+",  enrollment: "GV2301003", sid: "SID103", course: "B.Tech IT",   semester: "5th"),
        Student(name: "Sneha Singh",   sex: "Female", bloodGroup: "AB+", enrollment: "GV2301004", sid: "SID104", course: "BCA",         semester: "3rd"),
        Student(name: "Karan Mehta",   sex: "Male",   bloodGroup: "O-",  enrollment: "GV2301005", sid: "SID105", course: "BBA",         semester: "3rd"),
        Student(name: "Anjali Yadav",  sex: "Female", bloodGroup: "B-",  enrollment: "GV2301006", sid: "SID106", course: "MCA",         semester: "1st"),
        Student(name: "Vikram Joshi",  sex: "Male",   bloodGroup: "A-",  enrollment: "GV2301007", sid: "SID107", course: "B.Tech ECE",  semester: "7th"),
        Student(name: "Neha Rathore",  sex: "Female", bloodGroup: "O+",  enrollment: "GV2301008", sid: "SID108", course: "B.Com",       semester: "3rd"),
        Student(name: "Mohit Saini",   sex: "Male",   bloodGroup: "B+",  enrollment: "GV2301009", sid: "SID109", course: "MBA",         semester: "1st"),
        Student(name: "Pooja Chauhan", sex: "Female", bloodGroup: "AB-", enrollment: "GV2301010", sid: "SID110", course: "B.Sc IT",     semester: "5th")
    ]
}

// MARK: - Screen 1: Image view with logo (left sketch)

final class SplashViewController: UIViewController {

    private let logoView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        logoView.image = UIImage(named: "logo.jpg") ?? UIImage(named: "logo")
        logoView.contentMode = .scaleAspectFit
        logoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoView)

        NSLayoutConstraint.activate([
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            logoView.heightAnchor.constraint(equalTo: logoView.widthAnchor, multiplier: 0.75)
        ])

        let hint = UILabel()
        hint.text = "Tap anywhere to continue"
        hint.textColor = .gray
        hint.font = .systemFont(ofSize: 14)
        hint.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hint)
        NSLayoutConstraint.activate([
            hint.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hint.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToPortal)))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @objc private func goToPortal() {
        guard let nav = navigationController else { return }
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.5
        nav.view.layer.add(transition, forKey: nil)
        nav.setViewControllers([StudentPortalViewController()], animated: false)
    }
}

// MARK: - Screen 2: Title + button + table view (right sketch)

final class StudentPortalViewController: UIViewController {

    private let students = Array(Student.all.prefix(10))   // max 10 students
    private let tableView = UITableView()
    private let detailStack = UIStackView()
    private let placeholder = UILabel()
    private var isListVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // Title on top + button (hamburger) on the left
        title = "Student Management Portal"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal"),
            style: .plain, target: self, action: #selector(toggleList))

        setupDetailArea()
        setupTable()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    // Main area on the right where details show
    private func setupDetailArea() {
        placeholder.text = "Tap ☰ and select a student"
        placeholder.textColor = .secondaryLabel
        placeholder.textAlignment = .center
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholder)

        detailStack.axis = .vertical
        detailStack.spacing = 14
        detailStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailStack)

        NSLayoutConstraint.activate([
            placeholder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholder.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            detailStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            detailStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            detailStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    // Drop-down table view under the button
    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 44
        tableView.layer.cornerRadius = 10
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.systemBlue.cgColor
        tableView.isScrollEnabled = false
        tableView.alpha = 0
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(students.count) * 44)
        ])
    }

    @objc private func toggleList() {
        isListVisible ? hideList() : showList()
    }

    private func showList() {
        isListVisible = true
        tableView.isHidden = false
        view.bringSubviewToFront(tableView)
        UIView.animate(withDuration: 0.25) { self.tableView.alpha = 1 }
    }

    private func hideList() {
        isListVisible = false
        UIView.animate(withDuration: 0.25, animations: { self.tableView.alpha = 0 }) { _ in
            self.tableView.isHidden = true
        }
    }

    private func show(_ s: Student) {
        placeholder.isHidden = true
        detailStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let header = UILabel()
        header.text = s.name
        header.font = .systemFont(ofSize: 26, weight: .bold)
        detailStack.addArrangedSubview(header)

        let rows: [(String, String)] = [
            ("Sex", s.sex),
            ("Blood Group", s.bloodGroup),
            ("Enrollment No.", s.enrollment),
            ("SID", s.sid),
            ("Course", s.course),
            ("Semester", s.semester)
        ]
        rows.forEach { detailStack.addArrangedSubview(makeRow(title: $0.0, value: $0.1)) }
    }

    private func makeRow(title: String, value: String) -> UIView {
        let t = UILabel()
        t.text = title
        t.font = .systemFont(ofSize: 16, weight: .semibold)
        t.textColor = .secondaryLabel
        let v = UILabel()
        v.text = value
        v.font = .systemFont(ofSize: 18)
        v.textAlignment = .right
        let row = UIStackView(arrangedSubviews: [t, v])
        row.distribution = .fillEqually
        return row
    }
}

extension StudentPortalViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { students.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = students[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        show(students[indexPath.row])
        hideList()
    }
}
