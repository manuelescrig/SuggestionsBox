//
//  Suggestion.swift
//  SuggestionsBox
//
//  Created by Manuel Escrig Ventura on 30/04/16.
//
//


public struct Suggestion {

    var suggestionId: String
    var title: String
    var description: String
    var user: String
    var createdAt: NSDate
    var favorites = [String]()

    public init(suggestionId: String,
         title: String,
         description: String,
         user: String,
         favorites: [String],
         createdAt: NSDate) {

        self.suggestionId = suggestionId
        self.title = title
        self.description = description
        self.user = user
        self.favorites = favorites
        self.createdAt  = createdAt
    }

    func dateString() -> String {
        let format = SuggestionsBoxTheme.detailDateFormat
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(createdAt)
    }

    func favoritesString() -> String {
        if favorites.count == 1 {
            return String(favorites.count) + " " + SuggestionsBoxTheme.detailFavoriteText
        } else {
            return String(favorites.count) + " " + SuggestionsBoxTheme.detailFavoritesText
        }
    }
}
