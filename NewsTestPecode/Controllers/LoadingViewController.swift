import UIKit

class LoadingViewController: UIViewController {
    private let networkManager = NetworkManager()
    private let filters = Filters()
    private let databaseUserDefault = UserDefaultClass()
    private var news = [DataCellTable]()
    private var numberAllNewsOnRequest = 0
    @IBOutlet weak var indicator: UIActivityIndicatorView!

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
        var savedFiltersObject = Filters()
        savedFiltersObject = self.databaseUserDefault.readSavedFilters(titles: ParametersFilters.titles)
        savedFiltersObject.updateSourcesFilter(downloadedListSources: sourcesList)
        self.databaseUserDefault.setFilters(filters: savedFiltersObject)
        if let index = ParametersFilters.titles.firstIndex(of: ParametrsRequestNewsApi.sources.rawValue) {
            let filters = savedFiltersObject.getFilters()
            ParametersFilters.lists[index] = filters[index].getList()
        }
    }
    
    private func loadNews() {
        networkManager.getNewsRequest(filters: filters, page: 1, search: nil) { result, error in
            DispatchQueue.main.async {
                if let result = result, error == nil {
                    self.news = result.getNews()
                    self.numberAllNewsOnRequest = result.getNumberAllNewsOnRequest()
                    self.prepareAndLaunchMainViewController()
                } else {
                    guard let error = error else { return }
                    self.handleLoadingNewsError(error: error)
                    self.indicator.stopAnimating()
                }
            }
        }
    }
    
    private func prepareAndLaunchMainViewController() {
        guard let controler = self.storyboard?.instantiateViewController(identifier: "MainViewController") as? MainViewController else { return }
        controler.setData(news: news, filters: filters, numberAllNewsOnRequest: numberAllNewsOnRequest, databaseUserDefault: databaseUserDefault)
        self.navigationController?.pushViewController(controler, animated: true)
    }
}
