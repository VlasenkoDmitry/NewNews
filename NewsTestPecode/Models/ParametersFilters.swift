import Foundation

struct ParametersFilters {
    static let titles = [ParametrsRequestNewsApi.sources.rawValue,
                         ParametrsRequestNewsApi.category.rawValue,
                         ParametrsRequestNewsApi.country.rawValue,
                         ParametrsRequestNewsApi.language.rawValue]
    static var lists = [["bbc-news", "bild"],
                        ["business","entertainment","general","health","science","sports","technology"],
                        ["ae","ar","at","au","be","bg","br","ca","ch","cn","co","cu","cz","de","eg","fr","gb","gr","hk","hu","id","ie","il","in","it","jp","kr","lt","lv","ma","mx","my","ng","nl","no","nz","ph","pl","pt","ro","rs","ru","sa","se","sg","si","sk","th","tr","tw","ua","us","ve","za"],
                        ["ar", "de", "en", "es", "fr", "he", "it", "nl", "no", "pt", "ru", "sv", "ud", "zh"]]
}
