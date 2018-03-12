//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    //Initialise Constants and Variables
    var theQuiz = QuizQuestions()
    var questionsPerRound = 0
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    var gameSound: SystemSoundID = 0
    var questionDictionary: [String: String] = [:]
    
    //IBOutlet properties here
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    @IBOutlet weak var buttonFour: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //Set the questions per round to the amount of questions that have been
        //Submitted to theQuiz
        questionsPerRound = theQuiz.questions.count
        loadGameStartSound()
        // Start game
        playGameStartSound()
        displayQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUIWith(thisQuestion question: [String: String], thatHasThisManyAnswers answers: Int) {
        print("setting up UI")
        questionField.text = question["question"]
        let answersArray = getAnswerStringsArray(question: question)
        let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: answersArray)
        let shuffledAnswers: [String] = shuffled as! [String]
        if answers == 3 {
            
            buttonOne.setTitle(shuffledAnswers[0], for: .normal)
            buttonTwo.setTitle(shuffledAnswers[1], for: .normal)
            buttonThree.setTitle(shuffledAnswers[2], for: .normal)
            buttonFour.isHidden = true
            
        }
        else if answers == 4{
            
            buttonFour.isHidden = false
            buttonOne.setTitle(shuffledAnswers[0], for: .normal)
            buttonTwo.setTitle(shuffledAnswers[1], for: .normal)
            buttonThree.setTitle(shuffledAnswers[2], for: .normal)
            buttonFour.setTitle(shuffledAnswers[3], for: .normal)
            
        }
        else{
            print("Error. 'Exceeds' criteria was only to handle 3 & 4 potential answers")
        }
    }
    
    func displayQuestion() {
        
        questionDictionary = theQuiz.randomQuestion()
        let answerCount = howManyAnswers(inTheQuestion: questionDictionary)
        setupUIWith(thisQuestion: questionDictionary, thatHasThisManyAnswers: answerCount)
        playAgainButton.isHidden = true
        
    }
    
    func hideButtons(booleanValue: Bool){
        buttonOne.isHidden = booleanValue
        buttonTwo.isHidden = booleanValue
        buttonThree.isHidden = booleanValue
        buttonFour.isHidden = booleanValue
    }
    
    func displayScore() {
        // Hide the answer buttons
        hideButtons(booleanValue: true)
        
        // Display play again button
        playAgainButton.isHidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        
        let selectedQuestionDict = questionDictionary
        let correctAnswer = selectedQuestionDict["correctAnswer"]
        
        //Check if button text is equal to the correct answer
        if (sender.titleLabel?.text == correctAnswer) {
            //Correct answer!
            correctQuestions += 1
            questionField.text = "Correct!"
        }
        else{
            //Wrong answer!
            questionField.text = "Incorrect - the answer was \(String(describing: correctAnswer))"
        }
        
        loadNextRoundWithDelay(seconds: 2)
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() {
        // Show the answer buttons
        hideButtons(booleanValue: false)
        
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
    }
    

    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
}

