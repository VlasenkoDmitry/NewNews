import UIKit

class FiltersViewController: UIViewController {
    @IBOutlet weak var tableVIew: UITableView!
    private var models = [Section]()
    var filters = Filters()
    var userDefaultBase = UserDefaultClass()
    var activeFilter: Filter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        filters = userDefaultBase.fillingFiltersSavedData(filters: filters)
        addSectionsInModels()
    }
    
    /// Filling models to display sections and filters in tableView
    private func addSectionsInModels() {
        models.append(Section(title: "", options: [
            SettingsOption(title: ParametrsRequestNewsApi.sources.rawValue, handler: { [self] in
                activeFilter = filters.filters.first(where: { $0.title == ParametrsRequestNewsApi.sources.rawValue })
            })
        ], footer: "Can't mix sources param with the country or category params"))
        models.append(Section(title: "", options: [
            SettingsOption(title: ParametrsRequestNewsApi.category.rawValue, handler: { [self] in
                activeFilter = filters.filters.first(where: { $0.title == ParametrsRequestNewsApi.category.rawValue })
            }),
            SettingsOption(title: ParametrsRequestNewsApi.country.rawValue, handler: { [self] in
                activeFilter = filters.filters.first(where: { $0.title == ParametrsRequestNewsApi.country.rawValue })
            })
        ], footer: nil))
        models.append(Section(title: "", options: [
            SettingsOption(title: ParametrsRequestNewsApi.language.rawValue, handler: { [self] in
                activeFilter = filters.filters.first(where: { $0.title == ParametrsRequestNewsApi.language.rawValue })
            })
        ], footer: nil))
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        if filters.checkAtLeastOneActiveFilter() {
            navigationController?.popViewController(animated: true)
        } else {
            showAlert(title: "", text: "Please, select at least 1 filter")
        }
    }
}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let section = models[section]
        return section.footer
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat(50)
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FitlersTableViewCell", for: indexPath) as? FitlersTableViewCell else { return UITableViewCell () }
        let model = models[indexPath.section].options[indexPath.row]
        cell.configure(model: model)
        return cell
    }
    
    /// Calling the cell handler and opening the filter screen
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.section].options[indexPath.row]
        model.handler()
        guard let controler = self.storyboard?.instantiateViewController(identifier: "SeparateFilterViewController") as? SeparateFilterViewController else { return }
        controler.delegate = self
        controler.filter = activeFilter
        self.navigationController?.pushViewController(controler, animated: true)
    }
}

extension FiltersViewController: SeparateFilterViewControllerDelegate {
    func setSettingsFromSeparateFilterViewController(updatedFilter: Filter) {
        filters.updateFilters(changedFilter: updatedFilter)
        userDefaultBase.setFilters(filters: filters)
    }
}
