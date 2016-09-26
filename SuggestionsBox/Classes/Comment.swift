//
//  Comment.swift
//  SuggestionsBox
//  An iOS library to aggregate users feedback about suggestions,
//  features or comments in order to help you build a better product.
//
//  https://github.com/manuelescrig/SuggestionsBox
//
//  Created by Manuel Escrig Ventura on 30/04/16.
//  Licence: MIT-Licence

/**
 * Comment public class that represents the model for comments for each suggestion.
 */
open class Comment {

    /// An string representing the ID of the suggestion.
    open var suggestionId: String

    /// An string representing the ID of the comment.
    open var commentId: String

    /// An string representing the description of the comment describing what is about with more details.
    open var description: String

    /// An string representing the user that requested/created the comment.
    open var user: String

    /// A date representing the date when the suggestion was created.
    open var createdAt: Date

    /// Class initializer.
    public init(suggestionId: String,
                commentId: String,
                description: String,
                user: String,
                createdAt: Date) {

        self.suggestionId = suggestionId
        self.commentId = commentId
        self.description = description
        self.user = user
        self.createdAt  = createdAt
    }

    open func dateString() -> String {
        let format = SuggestionsBoxTheme.detailDateFormat
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: createdAt)
    }
}
