import UIKit

class MainViewController: UIViewController {
    
    private let networkManager = NetworkManager()
    private let refreshControll: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refresh
    }()
    private var databaseRealm = RealmClass()
    private var databaseUserDefault = UserDefaultClass()
    private var numberAllNewsOnRequest = 0
    private var news = [DataCellTable]()
    private var filters = Filters()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searshBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRealm.realmFile()
        tableView.refreshControl = refreshControll
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filters.fillSourcesFilterSavedData()
    }
    
    ///after user request(button reload and refreshControll)
    func reloadDataTableViewAndTableView() {
        networkManager.getNewsRequest(filters: filters, page: 1, search: searshBar.text)  { [weak self] result, error  in
            DispatchQueue.main.async {
                if let result = result, error == nil {
                    self?.news = result.getNews()
                    self?.numberAllNewsOnRequest = result.getNumberAllNewsOnRequest()
                    self?.tableView.reloadData()
                }
                if let error = error {
                    self?.handleLoadingNewsError(error: error)
                }
            }
        }
    }
    
    /// Loading news to add them to the bottom of the table if the user scrolls to the second-to-last downloaded news
    /// - Parameter numberOfLastCell: we should know the number of the last cell of tableview and the page size constant to calculate the number of the next page of the request
    private func addMoreNewsBelow(numberOfLastCell: Int) {
        let numberLoadedNews = numberOfLastCell + 1
        if numberLoadedNews % Constants.pageSize == 0 {
            let page = numberLoadedNews / Constants.pageSize + 1
            networkManager.getNewsRequest(filters: filters, page: page, search: searshBar.text) { [weak self]  result, error in
                DispatchQueue.main.async {
                    if let newNews = result, error == nil {
                        if newNews.getNews().count > 0 {
                            self?.news += newNews.getNews()
                            self?.numberAllNewsOnRequest = newNews.getNumberAllNewsOnRequest()
                            self?.displayNewNews(numberLastNewNews: newNews.getNews().count)
                        }
                    } else {
                        guard let error = error else { return }
                        self?.handleLoadingNewsError(error: error)
                    }
                }
            }
        }
    }
    
    /// Adding news in the tableView after calculating the indexes of the rows that will be add
    /// - Parameter quantityLastNewNews: for calculating the indexes of the rows that will be add
    private func displayNewNews(numberLastNewNews: Int) {
        let numberAllNews = self.news.count
        var indexPaths: [IndexPath] = []
        for element in (numberAllNews - numberLastNewNews)...(numberAllNews - 1) {
            indexPaths.append(IndexPath(row: element, section: 0))
        }
        self.tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    @IBAction private func filtersPressed(_ sender: UIButton) {
        guard let controler = self.storyboard?.instantiateViewController(identifier: "FiltersViewController") as? FiltersViewController else { return }
        controler.setFiltersAndDataBase(filters: filters, databaseUserDefault: databaseUserDefault)
        self.navigationController?.pushViewController(controler, animated: true)
    }
    
    @IBAction private func favouritePressed(_ sender: UIButton) {
        guard let controler = self.storyboard?.instantiateViewController(identifier: "FavouritesViewController") as? FavouriteNewsViewController else { return }
        controler.delegate = self
        controler.setDatabase(dataBase: databaseRealm)
        self.navigationController?.pushViewController(controler, animated: true)
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        reloadDataTableViewAndTableView()
        sender.endRefreshing()
    }
    
    private func openWebController(link: String) {
        guard let controler = self.storyboard?.instantiateViewController(identifier: "WebViewController") as? WebViewController else { return }
        controler.setLink(link: link)
        self.navigationController?.pushViewController(controler, animated: true)
    }
    
    /// Downloading new news if user swipe to second-to-last news
    private func checkLastToSecondCellTableView(cell: Int, numberCells: Int) -> Bool {
        cell + 2  == numberCells ? true : false
    }
    
    func setData(news: [DataCellTable], filters: Filters, numberAllNewsOnRequest: Int, databaseUserDefault: UserDefaultClass){
        self.news = news
        self.filters = filters
        self.numberAllNewsOnRequest = numberAllNewsOnRequest
        self.databaseUserDefault = databaseUserDefault
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    /// Creating cell and installing status of likeButton
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        if self.news.count == 0 { return UITableViewCell() }
        cell.configure(dataNews: self.news[indexPath.row], index: indexPath.row)
        cell.delegate = self
        if databaseRealm.checkNews(data: self.news[indexPath.row]) {
            cell.getCustomView().notesBotton.isSelected = true
        } else {
            cell.getCustomView().notesBotton.isSelected = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(view.frame.size.height / 5)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        openWebController(link: news[indexPath.row].getLink())
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if checkLastToSecondCellTableView(cell: indexPath.row, numberCells: news.count) {
            addMoreNewsBelow(numberOfLastCell: indexPath.row + 1)
        }
    }
}

/// Extension works when turn on or turn out "like"
extension MainViewController: MainTableViewCellDelegate {
    func addNewsToFavourite(index: Int) {
        databaseRealm.addNews(data: news[index])
    }
    
    func deleteNewsFromFavourite(index: Int) {
        databaseRealm.deleteNewsByLink(data: news[index])
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
