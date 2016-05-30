//
//  Comment.swift
//  SuggestionsBox
//
//  Created by Manuel Escrig Ventura on 30/04/16.
//
//


public struct Comment {

    var suggestionId: String
    var commentId: String
    var description: String
    var user: String
    var createdAt: NSDate

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

    func dateString() -> String {
        let format = SuggestionsBoxTheme.detailDateFormat
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(createdAt)
    }
}
