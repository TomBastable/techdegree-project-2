//
//  QuizMaster.swift
//  TrueFalseStarter
//
//  Created by Tom Bastable on 09/03/2018.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import GameKit

///The questions constant holds all questions, randomQuestion function delivers a random
///Questions and removes that question temporarily from the array
struct QuizQuestions {
    
    var questions: [[String : String]] = refillQuestions()
    
    ///Provides a randomQuestion and also removes the question from
    ///the array to avoid duplicated Q's entering the quiz
    mutating func randomQuestion() -> [String: String] {
        
        //Generate a random number using GameKit to ensure that the
        //questions don't appear in the same order
        let randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: questions.count)
        
        //If there are no questions left, refill the questions for the next game.
        if self.questions.isEmpty {
            self.questions = refillQuestions()
        }
        
        //Assign random question to its own constant, use the randomIndex
        // to remove that question to avoid duplication
        let question = questions[randomNumber]
        self.questions.remove(at: randomNumber)
        
        //Return the randomQuestion that has also been removed from the array
        return question
        
    }
    
}

///Once a game has finished, the questions will need topping up (We remove them to avoid asking one twice)
///which is what this function does! This way it's easy to comply with the DRY rule.
func refillQuestions() -> [[String : String]]{
    
    //Create a temporary array of dictionaries
    let scopedQuestions = Questions()
    //return the questions
    return scopedQuestions.getQuestions
    
}
