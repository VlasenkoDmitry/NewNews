import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    private var arrayAllNews = [DataCellTable]()
    private let networkManager = NetworkManager()
    private var filters = Filters()
    private var userDefaultBase = UserDefaultClass()
    private var quantityAllNewsOnRequest = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//      userDefaultBase.clearFilters()

        
        
        downloadSourcesList { sourcesList, error  in
            if sourcesList == sourcesList {
                self.updateFilters(sourcesList: sourcesList)
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "", text: "Downloading \"sources\" parameters is not success. Default parameters will be used")
                }
            }
            self.filters = self.userDefaultBase.fillingFiltersSavedData(filters: self.filters)
            self.loadingNews()
        }
    }
    
    private func initialize() {
        indicator.startAnimating()
    }
    
    /// We should download "sources" list to display actual filters
    private func downloadSourcesList(complition: @escaping ([String]?, Error?) -> ()) {
        networkManager.getSourcesListRequest { result, error in
            complition(result, error)
        }
    }
    
    private func updateFilters(sourcesList: [String]? ) {
        guard let result = sourcesList else { return }
        var savedFilters = Filters()
        savedFilters = self.userDefaultBase.readSavedFilters(titles: ParametersFilters.titles)
        savedFilters.updateSoures(downloadedListSources: result)
        self.userDefaultBase.setFilters(filters: savedFilters)
        if let index = ParametersFilters.titles.firstIndex(of: ParametrsRequestNewsApi.sources.rawValue) {
            ParametersFilters.lists[index] = savedFilters.filters[index].list
        }
    }
    /// Loading news to display the first news after turning on the app
    private func loadingNews() {
        networkManager.getNewsRequest(filters: filters, page: 1, search: nil) { result, error in
            DispatchQueue.main.async {
                if let result = result {
                    self.arrayAllNews = result.arrayNewNews
                    self.quantityAllNewsOnRequest = result.quantityAllNewsOnRequest
                    self.openMainViewController()
                } else {
                    guard let error = error else { return }
                    self.errorLoadingErrorHandling(error: error)
                    self.indicator.stopAnimating()
                }
            }
        }
    }
    
    /// Opening the main screen after successfully downloading news, transferring links of main data(an array of downloaded news, downloaded filters from the Realm database, the number of news in the request without a limit (to understand how much news we can theoretically download, a link to the filter database) )
    private func openMainViewController() {
        guard let controler = self.storyboard?.instantiateViewController(identifier: "MainViewController") as? MainViewController else { return }
        controler.arrayAllNews = self.arrayAllNews
        controler.filters = self.filters
        controler.quantityAllNewsOnRequest = self.quantityAllNewsOnRequest
        controler.userDefaultsBase = userDefaultBase
        self.navigationController?.pushViewController(controler, animated: true)
    }
}
