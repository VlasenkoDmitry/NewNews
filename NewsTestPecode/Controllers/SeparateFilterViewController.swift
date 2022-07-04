import UIKit

class SeparateFilterViewController: UIViewController {
    private var filter: Filter?
    private var updatedFilter: Filter?
    weak var delegate: SeparateFilterViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let filter = filter else { return }
        updatedFilter = Filter(title: filter.getTitle(), list: filter.getList(), listCheck: filter.getListCheck())
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        if let updatedFilter = updatedFilter {
            delegate?.setSettingsFromSeparateFilterViewController(updatedFilter: updatedFilter)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func deleteAnotherMarks(indexPath: IndexPath) {
        guard let numberCheckInFilter = updatedFilter?.getListCheck().count else { return }
        for index in 0..<numberCheckInFilter {
            if index == indexPath.row { continue }
            updateFilter(index: index)
            updateAccessoryTypes(index: index)
        }
    }
    
    private func updateFilter(index: Int) {
//        updatedFilter?.listCheck[index] = false
        updatedFilter?.setCheckToIndex(check: false, index: index)
    }
    
    private func updateAccessoryTypes(index: Int){
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
        cell?.accessoryType = .none
    }
    
    func setFilter(filter: Filter?) {
        self.filter = filter
    }
}

extension SeparateFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let quantityParametersInFilter = updatedFilter?.getList().count else { return 10 }
        return quantityParametersInFilter
    }
    
    /// Creating, configuring and setting a checkmark
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeparateFilterTableViewCell", for: indexPath) as? SeparateFilterTableViewCell else { return UITableViewCell () }
        if let text = updatedFilter?.getList()[indexPath.row] {
            cell.configure(model: text)
        }
        if updatedFilter?.getListCheck()[indexPath.row] == true {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    /// Changing check marks
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = self.tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
//            updatedFilter?.listCheck[indexPath.row] = false
            updatedFilter?.setCheckToIndex(check: false, index: indexPath.row)
        } else {
            cell?.accessoryType = .checkmark
//            updatedFilter?.listCheck[indexPath.row] = true
            updatedFilter?.setCheckToIndex(check: true, index: indexPath.row)
            /// We can use only one category, country or language in the request.
            if updatedFilter?.getTitle() == ParametrsRequestNewsApi.category.rawValue || updatedFilter?.getTitle() == ParametrsRequestNewsApi.country.rawValue || updatedFilter?.getTitle() == ParametrsRequestNewsApi.language.rawValue{
                deleteAnotherMarks(indexPath: indexPath)
            }
        }
    }
}
