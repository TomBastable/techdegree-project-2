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
    var questionDictionary: Question!
    
    //IBOutlet properties here
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    @IBOutlet weak var buttonFour: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the questions per round to the amount of questions that have been
        //Submitted to theQuiz (Previous version had magic numbers)
        questionsPerRound = theQuiz.questions.count
        loadGameStartSound()
        
        //UISetup
        buttonOne.setTitleColor(UIColor.white, for: .disabled)
        buttonTwo.setTitleColor(UIColor.white, for: .disabled)
        buttonThree.setTitleColor(UIColor.white, for: .disabled)
        buttonFour.setTitleColor(UIColor.white, for: .disabled)
        
        // Start game
        playGameStartSound()
        displayQuestion()
        playAgainButton.setTitle("Next Question", for: .normal)
        resultLabel.isHidden = true
    }
    
    //Game functionality goes below here
    //==================================//
    
    ///Function to display the question and setup the buttons for the correct amount of answers
    func displayQuestion() {
        //Select your random question
        questionDictionary = theQuiz.randomQuestion()
        //Work out how many potential answers your question has
        let answerCount = howManyAnswers(inTheQuestion: questionDictionary)
        //Setup the UI with your question and the potential answers
        setupUIWith(thisQuestion: questionDictionary, thatHasThisManyAnswers: answerCount)
        //Ensure the play again button is hidden
        playAgainButton.isHidden = true
    }
    
    ///Function to check if the user selected answer is correct
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        
        //Assign the correct answer to a constant
        let correctAnswer = questionDictionary.correctAnswer
        
        highlightAnswer(withCorrectAnswer: correctAnswer)
        //Check if selected buttons text is equal to the correct answer
        if (sender.titleLabel?.text == correctAnswer) {
            //Correct answer!
            correctQuestions += 1
            resultLabel.text = "Correct!"
            resultLabel.isHidden = false
            resultLabel.textColor = UIColor.green
        }
        else{
            //Wrong answer!
            resultLabel.text = "Incorrect"
            resultLabel.isHidden = false
            resultLabel.textColor = UIColor.red
        }
        enableDisableButtons(withBool: false)
        //answer checking is done - time to move on! (This used to be a timed interval - it's now a user input as per mockup
        playAgainButton.isHidden = false
        
        if questionsAsked == questionsPerRound {
            playAgainButton.setTitle("See Your Score", for: .normal)
        }
        else{
            playAgainButton.setTitle("Next Question", for: .normal)
        }
    }
    
    @IBAction func newGameOrNextRound(_ sender: UIButton) {
        resultLabel.isHidden = true
        resetButtonHighlights()
        enableDisableButtons(withBool: true)
        if sender.titleLabel?.text == "See Your Score" {
            displayScore()
        }
        else if sender.titleLabel?.text == "Next Question" {
            displayQuestion()
        }
        else if sender.titleLabel?.text == "Play Again" {
            //Show the answer buttons
            hideButtons(booleanValue: false)
            //Reset all the gameplay ints
            questionsAsked = 0
            correctQuestions = 0
            //New round!
            nextRound()
        }
    }
    
    ///Function to check if it's the end of the game, if not then continue on
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    // MARK: Helper Methods
    //Use this as the lightning round code later
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
    

    // UI Setup / UI Manipulation & Sounds go below here
    //=======================//
    
    ///Set the UI up with the correct amount of buttons based on the potential answers your question has
    func setupUIWith(thisQuestion question: Question, thatHasThisManyAnswers answers: Int) {
        //Set the questionField to contain the current question
        questionField.text = question.question
        
        //convert the answers to an array of strings to make assigning them to the button title easier
        let answersArray = getAnswerStringsArray(question: question)
        //Shuffle the answers to ensure that they're not always in the same order
        let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: answersArray)
        let shuffledAnswers: [String] = shuffled as! [String]
        
        //Based on the amount of potential answers, setup the UI (Constraint based functionality coming shortly)
        if answers == 3 {
            //Only setup three buttons, hide the fourth
            buttonOne.setTitle(shuffledAnswers[0], for: .normal)
            buttonTwo.setTitle(shuffledAnswers[1], for: .normal)
            buttonThree.setTitle(shuffledAnswers[2], for: .normal)
            buttonFour.isHidden = true
            
        }
        else if answers == 4{
            //Setup all four buttons, unhide the fourth incase the previous question had three answers
            buttonFour.isHidden = false
            buttonOne.setTitle(shuffledAnswers[0], for: .normal)
            buttonTwo.setTitle(shuffledAnswers[1], for: .normal)
            buttonThree.setTitle(shuffledAnswers[2], for: .normal)
            buttonFour.setTitle(shuffledAnswers[3], for: .normal)
            
        }
        else{
            //The criteria in the brief said to adapt the app for either 3 or 4 potential answers - functionality to handle additonal posibilities was not added.
            print("Error. 'Exceeds' criteria was only to handle 3 & 4 potential answers")
        }
    }
    
    ///Highlight or renew buttons
    
    func highlightAnswer(withCorrectAnswer answer: String) {

        if buttonOne.titleLabel?.text != answer{
            buttonOne.alpha = 0.3
        }
        if buttonTwo.titleLabel?.text != answer{
            buttonTwo.alpha = 0.3
        }
        if buttonThree.titleLabel?.text != answer{
            buttonThree.alpha = 0.3
        }
        if buttonFour.titleLabel?.text != answer{
            buttonFour.alpha = 0.3
        }
    }
    
    func resetButtonHighlights() {
        buttonOne.alpha = 1.0
        buttonTwo.alpha = 1.0
        buttonThree.alpha = 1.0
        buttonFour.alpha = 1.0
    }
    
    func enableDisableButtons(withBool booleanValue: Bool) {
        buttonOne.isEnabled = booleanValue
        buttonTwo.isEnabled = booleanValue
        buttonThree.isEnabled = booleanValue
        buttonFour.isEnabled = booleanValue
    }
    
    ///Game sound setup
    func loadGameStartSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }
    
    ///Function that needs to be called to initialise start sound
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    ///Displays the score and gives the user the option to start a new game
    func displayScore() {
        // Hide the answer buttons
        hideButtons(booleanValue: true)
        
        // Display play again button
        playAgainButton.isHidden = false
        playAgainButton.setTitle("Play Again", for: .normal)
        
        //Show the user their score
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
    }
    
    ///Function to avoid repeating myself when I need to hide all four buttons
    func hideButtons(booleanValue: Bool){
        buttonOne.isHidden = booleanValue
        buttonTwo.isHidden = booleanValue
        buttonThree.isHidden = booleanValue
        buttonFour.isHidden = booleanValue
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

