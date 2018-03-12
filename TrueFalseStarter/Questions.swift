//
//  Questions.swift
//  TrueFalseStarter
//
//  Created by Tom Bastable on 10/03/2018.
//  Copyright © 2018 Treehouse. All rights reserved.
//
///Simply Deliver the questions, as requested by Quiz Master General!

struct Question {
    let question: String
    let correctAnswer: String
    let wrongAnswer1: String
    let wrongAnswer2: String
    let wrongAnswer3: String
}

var questions = [
    
    Question(question: "This was the only US President to serve more than two consecutive terms.",
             correctAnswer: "Franklin D. Roosevelt",
             wrongAnswer1: "George Washington",
             wrongAnswer2: "Woodrow Wilson",
             wrongAnswer3: "Andrew Jackson"),
    
    Question(question: "Which of the following countries has the most residents?",
             correctAnswer: "Nigeria",
             wrongAnswer1: "Russia",
             wrongAnswer2: "Iran",
             wrongAnswer3: ""),
    
    Question(question: "In what year was the United Nations founded?",
             correctAnswer: "1945",
             wrongAnswer1: "1918",
             wrongAnswer2: "1919",
             wrongAnswer3: ""),
    
    Question(question: "The Titanic departed from the United Kingdom, where was it supposed to arrive?",
        correctAnswer: "New York City",
        wrongAnswer1: "Paris",
        wrongAnswer2: "Washington D.C.",
        wrongAnswer3: "Boston"),
    
    Question(question: "Which nation produces the most oil?",
        correctAnswer: "Canada",
        wrongAnswer1: "Brazil",
        wrongAnswer2: "Iraq",
        wrongAnswer3: "Iran"),
    
    Question(question: "Which country has most recently won consecutive World Cups in Soccer?",
        correctAnswer: "Brazil",
        wrongAnswer1: "Italy",
        wrongAnswer2: "Argetina",
        wrongAnswer3: ""),
    
    Question(question: "Which of the following rivers is longest?",
        correctAnswer: "Mississippi",
        wrongAnswer1: "Yangtze",
        wrongAnswer2: "Congo",
        wrongAnswer3: "Mekong"),
    
    Question(question: "Which city is the oldest?",
        correctAnswer: "Mexico City",
        wrongAnswer1: "Cape Town",
        wrongAnswer2: "San Juan",
        wrongAnswer3: "Sydney"),
    
    Question(question: "Which country was the first to allow women to vote in national elections?",
        correctAnswer: "Poland",
        wrongAnswer1: "United States",
        wrongAnswer2: "Sweden",
        wrongAnswer3: "Senegal"),
    
    Question(question: "Which of these countries won the most medals in the 2012 Summer Games?",
        correctAnswer: "Great Britian",
        wrongAnswer1: "Japan",
        wrongAnswer2: "Germany",
        wrongAnswer3: "France"),
]
