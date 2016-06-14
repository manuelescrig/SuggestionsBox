//
//  Suggestion.swift
//  SuggestionsBox
//  An iOS library to aggregate users feedback about suggestions,
//  features or comments in order to help you build a better product.
//
//  https://github.com/manuelescrig/SuggestionsBox
//
//  Created by Manuel Escrig Ventura on 30/04/16.
//  Licence: MIT-Licence


/**
 * Suggestion public class that represents the suggestion/feature-request model.
 */
public class Suggestion {

    /// An string representing the ID of the suggestion.
    public var suggestionId: String

    /// An string representing the title of the suggestion describing what is about in a line.
    public var title: String

    /// An string representing the description of the suggestion describing what is about with more details.
    public var description: String

    /// An string representing the user that requested/created the suggestion.
    public var user: String

    /// A date representing the date when the suggestion was created.
    public var createdAt: NSDate

    /// An array with the strings of the users that have favorited this suggestion.
    public var favorites = [String]()

    /// Class initializer.
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
