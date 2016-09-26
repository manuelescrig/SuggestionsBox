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
open class Suggestion {

    /// An string representing the ID of the suggestion.
    open var suggestionId: String

    /// An string representing the title of the suggestion describing what is about in a line.
    open var title: String

    /// An string representing the description of the suggestion describing what is about with more details.
    open var description: String

    /// An string representing the user that requested/created the suggestion.
    open var user: String

    /// A date representing the date when the suggestion was created.
    open var createdAt: Date

    /// An array with the strings of the users that have favorited this suggestion.
    open var favorites = [String]()

    /// Class initializer.
    public init(suggestionId: String,
         title: String,
         description: String,
         user: String,
         favorites: [String],
         createdAt: Date) {

        self.suggestionId = suggestionId
        self.title = title
        self.description = description
        self.user = user
        self.favorites = favorites
        self.createdAt  = createdAt
    }

    open func dateString() -> String {
        let format = SuggestionsBoxTheme.detailDateFormat
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: createdAt)
    }

    open func favoritesString() -> String {
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
