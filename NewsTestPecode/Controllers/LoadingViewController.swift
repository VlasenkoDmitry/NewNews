import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    private var news = [DataCellTable]()
    private let networkManager = NetworkManager()
    private var filters = Filters()
    private var databaseUserDefault = UserDefaultClass()
    private var numberAllNewsOnRequest = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //      userDefaultBase.clearFilters()
        
        downloadAndSetupSourcesList { sourcesList, error  in
            self.loadNews()
        }
    }
    
    /// We should download "sources" list to display actual filters
    private func downloadAndSetupSourcesList(complition: @escaping ([String]?, Error?) -> ()) {
        networkManager.getSourcesListRequest { result, error in
            if let sourcesList = result, error == nil {
                self.replaceSourcesList(sourcesList: sourcesList)
            } else {
                if let error = error {
                    print(error.localizedDescription)
                }
                DispatchQueue.main.async {
                    self.showAlert(title: "", text: "Downloading \"sources\" parameters is not success. Default parameters will be used")
                }
            }
            self.filters.fillSourcesFilterSavedData()
            complition(result, error)
        }
    }
    
    private func replaceSourcesList(sourcesList: [String]? ) {
        guard let sourcesList = sourcesList else { return }
        var savedFilters = Filters()
        savedFilters = self.databaseUserDefault.readSavedFilters(titles: ParametersFilters.titles)
        savedFilters.updateSourcesFilter(downloadedListSources: sourcesList)
        self.databaseUserDefault.setFilters(filters: savedFilters)
        if let index = ParametersFilters.titles.firstIndex(of: ParametrsRequestNewsApi.sources.rawValue) {
            ParametersFilters.lists[index] = savedFilters.filters[index].list
        }
    }
    /// Loading news to display the first news after turning on the app
    private func loadNews() {
        networkManager.getNewsRequest(filters: filters, page: 1, search: nil) { result, error in
            DispatchQueue.main.async {
                if let result = result, error == nil {
                    self.news = result.newNews
                    self.numberAllNewsOnRequest = result.numberAllNewsOnRequest
                    self.prepareAndLaunchMainViewController()
                } else {
                    guard let error = error else { return }
                    self.handleLoadingNewsError(error: error)
                    self.indicator.stopAnimating()
                }
            }
        }
    }
    
    /// Opening the main screen after successfully downloading news, transferring links of main data(an array of downloaded news, downloaded filters from the Realm database, the number of news in the request without a limit (to understand how much news we can theoretically download, a link to the filter database) )
    private func prepareAndLaunchMainViewController() {
        guard let controler = self.storyboard?.instantiateViewController(identifier: "MainViewController") as? MainViewController else { return }
        controler.news = self.news
        controler.filters = self.filters
        controler.numberAllNewsOnRequest = self.numberAllNewsOnRequest
        controler.databaseUserDefault = databaseUserDefault
        self.navigationController?.pushViewController(controler, animated: true)
    }
}
