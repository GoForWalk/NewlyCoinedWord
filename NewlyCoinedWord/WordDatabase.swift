//
//  WordDatabase.swift
//  NewlyCoinedWord
//
//  Created by sae hun chung on 2022/07/10.
//

import Foundation

struct DataBase {
    
    private var userDefaultsKey = "wordDataBase"
    
    var wordMeaning: [String: String] = [:]
    
    mutating func saveMeaning(word: String, meaning: String) {
        wordMeaning[word] = meaning
    }
    
    mutating func saveData(word: String, meaning: String) {
        saveMeaning(word: word, meaning: meaning)
        UserDefaults.standard.set(wordMeaning, forKey: userDefaultsKey)
    }
    
    mutating func getData() {
        
        guard let defaultData = UserDefaults.standard.dictionary(forKey: userDefaultsKey) as? [String: String] else { return }
        
        self.wordMeaning = defaultData
    }
    
    mutating func getMeaning(word: String) -> String {
        getData()
        
        guard let result = wordMeaning[word] else { return "뜻이 없어요!!"}
        
        return result
    }
    
    mutating func deleteData() {
        
        UserDefaults.standard.set([:], forKey: userDefaultsKey)
        
        getData()
        
    }
}//: DataBase

