import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searshBar: UISearchBar!
    
    private let refreshControll: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refresh
    }()
    private var databaseRealm = RealmClass()
    private let networkManager = NetworkManager()
    var userDefaultsBase = UserDefaultClass()
    var quantityAllNewsOnRequest = 0
    var arrayAllNews = [DataCellTable]()
    var filters = Filters()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRealm.realmFile()
        tableView.refreshControl = refreshControll
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filters = userDefaultsBase.fillingFiltersSavedData(filters: filters)
    }
    
    /// Loading news and reloading tableview after user request(button reload and refreshControll)
    func reloadDataTableViewAndTableView() {
        networkManager.getNewsRequest(filters: filters, page: 1, search: searshBar.text)  { [weak self] result, error  in
            DispatchQueue.main.async {
                if let result = result, error == nil {
                    self?.arrayAllNews = result.arrayNewNews
                    self?.quantityAllNewsOnRequest = result.quantityAllNewsOnRequest
                    self?.tableView.reloadData()
                }
                if let error = error {
                    self?.errorLoadingErrorHandling(error: error)
                }
            }
        }
    }
    
    /// Loading news to add them to the bottom of the table if the user scrolls to the second-to-last downloaded news
    /// - Parameter numberOfLastCell: we should know the number of the last cell of tableview and the page size constant to calculate the number of the next page of the request
    private func addMoreNewsBelow(numberOfLastCell: Int) {
        let quantityLoadedNews = numberOfLastCell + 1
        if quantityLoadedNews % Constants.pageSize == 0 {
            let page = quantityLoadedNews / Constants.pageSize + 1
            networkManager.getNewsRequest(filters: filters, page: page, search: searshBar.text) { [weak self]  result, error in
                DispatchQueue.main.async {
                    if let newNews = result, error == nil {
                        if newNews.arrayNewNews.count > 0 {
                            self?.arrayAllNews += newNews.arrayNewNews
                            self?.quantityAllNewsOnRequest = newNews.quantityAllNewsOnRequest
                            self?.displayNewNews(quantityLastNewNews: newNews.arrayNewNews.count)
                        }
                    }
                    if let error = error {
                        self?.errorLoadingErrorHandling(error: error)
                    }
                }
            }
        }
    }
    
    /// Adding news in the tableView after calculating the indexes of the rows that will be add
    /// - Parameter quantityLastNewNews: for calculating the indexes of the rows that will be add
    private func displayNewNews(quantityLastNewNews: Int) {
        let quantityAllNews = self.arrayAllNews.count
        var arrayIndexPath: [IndexPath] = []
        for element in (quantityAllNews - quantityLastNewNews)...(quantityAllNews - 1) {
            arrayIndexPath.append(IndexPath(row: element, section: 0))
        }
        self.tableView.insertRows(at: arrayIndexPath, with: .automatic)
    }
    
    @IBAction private func filtersPressed(_ sender: UIButton) {
        guard let controler = self.storyboard?.instantiateViewController(identifier: "FiltersViewController") as? FiltersViewController else { return }
        controler.filters = self.filters
        controler.userDefaultBase = userDefaultsBase
        self.navigationController?.pushViewController(controler, animated: true)
    }
    
    @IBAction private func favouritePressed(_ sender: UIButton) {
        guard let controler = self.storyboard?.instantiateViewController(identifier: "FavouritesViewController") as? FavouriteNewsViewController else { return }
        controler.delegate = self
        controler.databaseRealm = databaseRealm
        self.navigationController?.pushViewController(controler, animated: true)
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        reloadDataTableViewAndTableView()
        sender.endRefreshing()
    }
    
    private func openWebController(link: String) {
        guard let controler = self.storyboard?.instantiateViewController(identifier: "WebViewController") as? WebViewController else { return }
        controler.link = link
        self.navigationController?.pushViewController(controler, animated: true)
    }
    
    /// Downloading new news if user swipe to second-to-last news
    /// - Parameters:
    ///   - numberCell: number of checking cell
    ///   - quantityCells: quantity cells in tableView
    private func checkLastToSecondCellTableView(numberCell: Int, quantityCells: Int) {
        if numberCell + 2  == quantityCells {
            addMoreNewsBelow(numberOfLastCell: numberCell + 1)
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayAllNews.count
    }
    
    /// Creating cell and installing status of likeButton
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        if self.arrayAllNews.count == 0 { return UITableViewCell() }
        cell.configure(dataNews: self.arrayAllNews[indexPath.row], index: indexPath.row)
        cell.delegate = self
        if databaseRealm.checkNews(data: self.arrayAllNews[indexPath.row]) {
            cell.customView.notesBotton.isSelected = true
            //            cell.likeButton.isSelected = true
        } else {
            cell.customView.notesBotton.isSelected = false
            //            cell.likeButton.isSelected = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(view.frame.size.height / 5)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        openWebController(link: arrayAllNews[indexPath.row].link)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        checkLastToSecondCellTableView(numberCell: indexPath.row, quantityCells: arrayAllNews.count)
    }
}

/// Extension works when turn on or turn out "like"
extension MainViewController: MainTableViewCellDelegate {
    func addNewsToFavourite(index: Int) {
        databaseRealm.addNews(data: arrayAllNews[index])
    }
    
    func deleteNewsFromFavourite(index: Int) {
        databaseRealm.deleteNewsByLink(data: arrayAllNews[index])
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        reloadDataTableViewAndTableView()
    }
}

extension MainViewController: FavouriteNewsViewControllerDelegate {
    /// It works when we select news from the list of favorite news
    func openNews(title: String) {
        guard let link = databaseRealm.getLink(title: title) else { return }
        openWebController(link: link)
    }
    
    func reloadTableViewNews() {
        tableView.reloadData()
    }
}
