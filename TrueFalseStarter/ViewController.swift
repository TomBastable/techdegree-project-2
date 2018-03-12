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
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    var gameSound: SystemSoundID = 0
    var correctSound: SystemSoundID = 0
    var incorrectSound: SystemSoundID = 0
    var questionDictionary: Question!
    var seconds = 15 //The max ammt of time per question
    var timer = Timer()

    
    //IBOutlet properties here
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    @IBOutlet weak var buttonFour: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the questions per round to the amount of questions that have been
        //Submitted to theQuiz (Previous version had magic numbers)
        questionsPerRound = theQuiz.questions.count
        loadGameStartSound()
        
        //UISetup - set the disabled state of buttons to the same as enabled
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
    
    ///Function to start a timer, that calls another function every second to update the timerLabel to show the user their countdown
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    ///Function that updates the seconds variable every second, while also updating the timerLabel every second. Also handles timeout.
    @objc func updateTimer() {
        
        seconds -= 1
        
        //If the timer is at 0, the user has ran out of time
        if seconds == 0 {
            timer.invalidate()
            seconds = 15
            timeRanOut()
        }
        else{
            //if the timer isn't at 0, keep updating the label!
           timerLabel.text = "\(seconds)"
        }
        
        
    }
    
    ///Function to display the question and setup the buttons for the correct amount of answers
    func displayQuestion() {
        runTimer()
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
        //User has interacted with an answer - first thing to do is invalidate the timer and reset the seconds var.
        //Don't update the label yet so the user can see how long it took them.
        timer.invalidate()
        seconds = 15
        // Increment the questions asked counter
        theQuiz.addQuestionAsked()
        
        //Assign the correct answer to a constant
        let correctAnswer = questionDictionary.correctAnswer
        
        //As per the Mockups, highlight the correct answer
        highlightAnswer(withCorrectAnswer: correctAnswer)
        
        //Check if selected buttons text is equal to the correct answer
        if (sender.titleLabel?.text == correctAnswer) {
            //Correct answer!
            
            //Play the correct sound
            playCorrectSound()
            //Add to the users score
            theQuiz.addCorrectAnswer()
            //Update the result Label and unhide it
            resultLabel.text = "Correct!"
            resultLabel.isHidden = false
            //Update label color
            resultLabel.textColor = UIColor.green
        }
        else{
            //Wrong answer!
            
            //Play the incorrect sound
            playIncorrectSound()
            //Update result label and unhide it
            resultLabel.text = "Sorry, that's not it"
            resultLabel.isHidden = false
            // Update label color
            resultLabel.textColor = UIColor.red
        }
        //Disable user interaction on the answer buttons to avoid duplicate answers / score
        enableDisableButtons(withBool: false)
        //answer checking is done - time to move on! (This used to be a timed interval - it's now a user input as per mockup
        playAgainButton.isHidden = false
        
        //Work out what text to put on the playAgainButton title - if we have questions left, move on - otherwise end the game.
        if theQuiz.questionsAsked == questionsPerRound {
            playAgainButton.setTitle("See Your Score", for: .normal)
        }
        else{
            playAgainButton.setTitle("Next Question", for: .normal)
        }
    }
    
    
    //Work out if the playAgainButton is wanting one of three things:
    @IBAction func newGameOrNextRound(_ sender: UIButton) {
        //Hide the result label
        resultLabel.isHidden = true
        //reset highlighted answers
        resetButtonHighlights()
        //enable user interactivity on the answer buttons
        enableDisableButtons(withBool: true)
        
        //If user is at the end of a game
        if sender.titleLabel?.text == "See Your Score" {
            //Play the game start / end sound
            playGameStartSound()
            //Display the users score and give them the option to restart
            displayScore()
        }
        //If the user needs a new question
        else if sender.titleLabel?.text == "Next Question" {
            //reset the timer label
            timerLabel.text = "\(seconds)"
            //display the new question
            displayQuestion()
        }
        // if the user needs a whole new game made up
        else if sender.titleLabel?.text == "Play Again" {
            //Show the answer buttons
            hideButtons(booleanValue: false)
            //Unhide the timer label and set it to the time limit
            timerLabel.isHidden = false
            timerLabel.text = "\(seconds)"
            //Reset all the gameplay ints
            theQuiz.resetScores()
            //New round!
            nextRound()
        }
    }
    
    ///Called when the user has taken the max amount of time for a question
    func timeRanOut() {
        //Play the incorrect sound and display the negative result in text too
        playIncorrectSound()
        resultLabel.text = "Time ran out!"
        resultLabel.isHidden = false
        resultLabel.textColor = UIColor.red
        
        //Increase the asked questions int
        theQuiz.addQuestionAsked()
        
        //Disable user interaction on the buttons
        enableDisableButtons(withBool: false)
        //Unhide play again button
        playAgainButton.isHidden = false
        //Highlight the correct answer
        highlightAnswer(withCorrectAnswer: questionDictionary.correctAnswer)
        
        //Work out if the user is at the end of the game or requires more questions and change the button title to suit
        if theQuiz.questionsAsked == questionsPerRound {
            playAgainButton.setTitle("See Your Score", for: .normal)
        }
        else{
            playAgainButton.setTitle("Next Question", for: .normal)
        }
        
    }
    
    ///Function to check if it's the end of the game, if not then continue on
    func nextRound() {
        if theQuiz.questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
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
    
    ///Highlight the correct answer and dim the others
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
    
    ///Reset the alpha of all buttons after they have been highlighted
    func resetButtonHighlights() {
        buttonOne.alpha = 1.0
        buttonTwo.alpha = 1.0
        buttonThree.alpha = 1.0
        buttonFour.alpha = 1.0
    }
    
    ///Using the BOOL input you can choose to enable or disable user interactitivty on the answer buttons
    func enableDisableButtons(withBool booleanValue: Bool) {
        buttonOne.isEnabled = booleanValue
        buttonTwo.isEnabled = booleanValue
        buttonThree.isEnabled = booleanValue
        buttonFour.isEnabled = booleanValue
    }
    
    ///Game sound setup
    func loadGameStartSound() {
        let pathToGameSoundFile = Bundle.main.path(forResource: "gameEnd", ofType: "wav")
        let soundGameURL = URL(fileURLWithPath: pathToGameSoundFile!)
        AudioServicesCreateSystemSoundID(soundGameURL as CFURL, &gameSound)
        
        let pathToCorrectSoundFile = Bundle.main.path(forResource: "correct", ofType: "wav")
        let correctGameURL = URL(fileURLWithPath: pathToCorrectSoundFile!)
        AudioServicesCreateSystemSoundID(correctGameURL as CFURL, &correctSound)
        
        let pathToIncorrectSoundFile = Bundle.main.path(forResource: "incorrect", ofType: "wav")
        let soundIncorrectURL = URL(fileURLWithPath: pathToIncorrectSoundFile!)
        AudioServicesCreateSystemSoundID(soundIncorrectURL as CFURL, &incorrectSound)
    }
    
    ///Function that needs to be called to initialise start sound
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    ///Function that needs to be called when a user selects an incorrect answer
    func playIncorrectSound() {
        AudioServicesPlaySystemSound(incorrectSound)
    }
    ///Function that needs to be called when a user selects a correct answer
    func playCorrectSound() {
        AudioServicesPlaySystemSound(correctSound)
    }
    
    ///Displays the score and gives the user the option to start a new game
    func displayScore() {
        // Hide the answer buttons
        hideButtons(booleanValue: true)
        timerLabel.isHidden = true
        
        // Display play again button
        playAgainButton.isHidden = false
        playAgainButton.setTitle("Play Again", for: .normal)
        
        //Show the user their score
        questionField.text = "Way to go!\nYou got \(theQuiz.correctAnswers) out of \(questionsPerRound) correct!"
        
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

