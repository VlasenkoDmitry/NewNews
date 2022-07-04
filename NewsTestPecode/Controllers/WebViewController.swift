import UIKit
import WebKit

class WebViewController: UIViewController {
    private var link: String?
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
    }
    
    func setLink(link: String?) {
        self.link = link
    }
    
    private func loadWebView() {
        guard let link = link else { return }
        if let url = link.getUrlRequest() {
            webView.load(url)
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
