import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style : .default, handler : nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func errorLoadingErrorHandling(error: Error) {
        switch error {
        case LoadingError.networkFailure(let error):
            showAlert(title: "Error", text: error.localizedDescription)
        case LoadingError.parseFailure(_):
            showAlert(title: "Error", text: "Data reading error")
        case LoadingError.InvalidUrl:
            showAlert(title: "", text: "Error")
        case LoadingError.UnknownError:
            showAlert(title: "", text: "Unknown Error")
        default:
            break
        }
    }
}
