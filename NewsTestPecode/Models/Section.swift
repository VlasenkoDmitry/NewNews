import Foundation

struct Section {
    let title: String
    let options: [SettingsOption]
    let footer: String?
}

struct SettingsOption {
    let title: String
    let handler: (() -> Void)
}
