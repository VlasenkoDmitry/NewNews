import UIKit
import WebKit

class WebViewController: UIViewController {
    var link: String?
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
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
