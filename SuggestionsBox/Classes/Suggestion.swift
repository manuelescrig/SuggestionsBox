//
//  Suggestion.swift
//  SuggestionsBox
//
//  Created by Manuel Escrig Ventura on 30/04/16.
//
//


struct Suggestion {

    var suggestionId : Int
    var title: String
    var description: String
    var author: String
    var favorites: Int
    var createdAt : NSDate
    
    init(suggestionId : Int,
         title: String,
         description: String,
         author: String,
         favorites: Int,
         createdAt: NSDate) {
        
        self.suggestionId = suggestionId
        self.title = title
        self.description = description
        self.author = author
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
        if favorites == 1 {
            return String(favorites) + " " + SuggestionsBoxTheme.detailFavoriteText
        } else {
            return String(favorites) + " " + SuggestionsBoxTheme.detailFavoritesText
        }
    }
}
