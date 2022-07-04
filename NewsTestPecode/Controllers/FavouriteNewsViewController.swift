import UIKit

class FavouriteNewsViewController: UIViewController {
    
    private var news: [NewsRealmData] = []
    private var databaseRealm: RealmClass?
    weak var delegate: FavouriteNewsViewControllerDelegate?
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cleanAllButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNews()
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        delegate?.reloadTableViewNews()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cleanAllPressed(_ sender: UIButton) {
        databaseRealm?.cleanBase()
        delegate?.reloadTableViewNews()
        navigationController?.popViewController(animated: true)
    }
    
    private func updateNews() {
        if let news = databaseRealm?.getAllObjectsNewsRealmData() {
            self.news = news
        }
    }
    
    func setDatabase(dataBase: RealmClass?) {
        self.databaseRealm = dataBase
    }
}

extension FavouriteNewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavouritesTableViewCell", for: indexPath) as? FavouritesTableViewCell else { return UITableViewCell() }
        cell.configure(title: news[indexPath.row].title, image:  news[indexPath.row].image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(view.frame.size.height / 5)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.openNews(title: news[indexPath.row].title)
    }
    
    /// When you move the cell to the left, the delete button appears. When you click it, the database and table are updated
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            databaseRealm?.deleteNewsByTitle(title: news[indexPath.row].title)
            updateNews()
            tableView.reloadData()
        }
    }    
}
