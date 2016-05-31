//
//  Suggestion.swift
//  SuggestionsBox
//
//  Created by Manuel Escrig Ventura on 30/04/16.
//
//



public struct Suggestion {

    public var suggestionId: String
    public var title: String
    public var description: String
    public var user: String
    public var createdAt: NSDate
    public var favorites = [String]()

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

    public func dateString() -> String {
        let format = SuggestionsBoxTheme.detailDateFormat
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(createdAt)
    }

    public func favoritesString() -> String {
        if favorites.count == 1 {
            return String(favorites.count) + " " + SuggestionsBoxTheme.detailFavoriteText
        } else {
            return String(favorites.count) + " " + SuggestionsBoxTheme.detailFavoritesText
        }
    }
}

extension Suggestion: Equatable {}
public func ==(lhs: Suggestion, rhs: Suggestion) -> Bool {
    return lhs.suggestionId == rhs.suggestionId && lhs.title == rhs.title
}
