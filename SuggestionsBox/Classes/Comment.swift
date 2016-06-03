//
//  Comment.swift
//  SuggestionsBox
//
//  Created by Manuel Escrig Ventura on 30/04/16.
//
//

/**
 Comment public class that represents the model for comments for each suggestion.
  */
public class Comment {

    /// An string representing the ID of the suggestion.
    public var suggestionId: String

    /// An string representing the ID of the comment.
    public var commentId: String

    /// An string representing the description of the comment describing what is about with more details.
    public var description: String

    /// An string representing the user that requested/created the comment.
    public var user: String

    /// A date representing the date when the suggestion was created.
    public var createdAt: NSDate

    /// Class initializer.
    public init(suggestionId: String,
                commentId: String,
                description: String,
                user: String,
                createdAt: NSDate) {

        self.suggestionId = suggestionId
        self.commentId = commentId
        self.description = description
        self.user = user
        self.createdAt  = createdAt
    }

    public func dateString() -> String {
        let format = SuggestionsBoxTheme.detailDateFormat
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(createdAt)
    }
}
