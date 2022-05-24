import Foundation

protocol SeparateFilterViewControllerDelegate: AnyObject {
    func setSettingsFromSeparateFilterViewController(updatedFilter: Filter)
}
