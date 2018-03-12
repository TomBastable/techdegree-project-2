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
    
    var questions: [Question] = refillQuestions()
    var questionsAsked: Int = 0
    var correctAnswers: Int = 0
    
    mutating func addQuestionAsked(){
        questionsAsked += 1
    }
    
    mutating func addCorrectAnswer(){
        correctAnswers += 1
    }
    
    ///Provides a randomQuestion and also removes the question from
    ///the array to avoid duplicated Q's entering the quiz
    mutating func randomQuestion() -> Question {
        
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
    
    mutating func resetScores() {
        self.questionsAsked = 0
        self.correctAnswers = 0
    }
    
}

///Provides a [String] of a questions potential answers for assigning to the UI
func getAnswerStringsArray(question: Question) -> [String]{
    
    //Empty array that will be returned with the array of answers
    var arrayOfAnswers: [String] = []
    
    //See how many answers you need
    if question.wrongAnswer3 == "" {
        //Only 3 potential answers
        arrayOfAnswers.append(question.correctAnswer)
        arrayOfAnswers.append(question.wrongAnswer1)
        arrayOfAnswers.append(question.wrongAnswer2)
    }
    else if question.wrongAnswer3 != "" {
        //4 potential answers
        arrayOfAnswers.append(question.correctAnswer)
        arrayOfAnswers.append(question.wrongAnswer1)
        arrayOfAnswers.append(question.wrongAnswer2)
        arrayOfAnswers.append(question.wrongAnswer3)
    }
    
    //return the array
    return arrayOfAnswers
}

///This function will tell you how many potential answers are in a specific question
///deliver a single question, not the whole array.
func howManyAnswers(inTheQuestion question: Question) -> Int {
    //Initialise an Int to count the answers
    var answerCount = 0
    
    //For every item in the question, count the answer to the answerCount property unless it's of dict key 'question'
    if question.wrongAnswer3 == "" {
        answerCount = 3
    }
    else if question.wrongAnswer3 != "" {
        answerCount = 4
    }
    
    //Finished, return the final count
    return answerCount
    
}

///Once a game has finished, the questions will need topping up (We remove them to avoid asking one twice)
///which is what this function does! This way it's easy to comply with the DRY rule.
func refillQuestions() -> [Question]{
    
    //Create a temporary array of dictionaries
    let scopedQuestions = questions
    //return the questions
    return scopedQuestions
    
}
