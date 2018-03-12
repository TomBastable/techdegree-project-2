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

func getAnswerStringsArray(question: [String: String]) -> [String]{
    
    var arrayOfAnswers: [String] = []
    
    for dict in question {
        if dict.key != "question"{
            arrayOfAnswers.append(dict.value)
        }

    }
    
    return arrayOfAnswers
}

///This function will tell you how many potential answers are in a specific question
///deliver a single question, not the whole array.
func howManyAnswers(inTheQuestion question:[String: String]) -> Int {
    //Initialise an Int to count the answers
    var answerCount = 0
    
    //For every item in the question, count the answer to the answerCount property unless it's of dict key 'question'
    for dict in question {
        if dict.key == "question"{
            //Dictionary is a question, don't count to the value of answers
        }
        else{
            //Dictionary is an answer, increase answer count
            answerCount += 1
        }
    }
    
    //Finished, return the final count
    return answerCount
    
}

///Once a game has finished, the questions will need topping up (We remove them to avoid asking one twice)
///which is what this function does! This way it's easy to comply with the DRY rule.
func refillQuestions() -> [[String : String]]{
    
    //Create a temporary array of dictionaries
    let scopedQuestions = Questions()
    //return the questions
    return scopedQuestions.getQuestions
    
}
