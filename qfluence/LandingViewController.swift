//
//  LandingViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 1/11/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit
import Firebase
import Canvas

class LandingViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var questionView: CSAnimationView!
    
    var timer: Timer?
    var trendingQuestions: [String] = ["What do you like to do in your free time?", "Are you more of an indoors or outdoors person?", "Who is the most fascinating person you’ve met?","What was the last book you really got into?", "What are some movies you really enjoyed?", "What amazing adventures have you been on?","What pets have you had?", "What’s your favorite alcoholic and non-alcoholic drink?", "What are you kind of obsessed with these days?","Where have you traveled?", "What’s your favorite international food?", "Are you a morning person or a night owl?","What’s your favorite restaurant?", "How many siblings do you have?", "What would be your dream job?","What would you do if had enough money to not need a job?", "Who is your favorite author?", "What was the last show you binge-watched?","What TV series do you keep coming back to and re-watching?", "What hobbies would you like to get into if you had the time and money?", "If there was an Olympics for everyday activities, what activity would you have a good chance at winning a medal in?","What would your perfect vacation look like?", "Among your friends, what are you best known for?", "What music artist do you never get tired of?","What are some accomplishments that you are really proud of?", "What are some obscure things that you are or were really into?", "What are some things everyone should try at least once?","What fad did you never really understand?", "What’s the best thing that has happened to you this month?", "What would your perfect morning be like?","Is there any art or artist you are really into?", "What are you always game for?", "What do you do to unwind?","What’s your favorite app on your phone?", "Cutest animal? Ugliest animal?", "Who is the kindest person you know?","What’s your favorite piece of furniture you’ve ever owned?", "Who are your kind of people?", "Where’s the strangest place you’ve ever been?","What’s the silliest fear you have?", "What would be the best city to live in?", "What household chore is just the worst?","If you could give yourself a nickname, what nickname would you want people to call you?", "What odd talent do you have?", "If you could give everyone just one piece of advice, what would it be?","What would you like to know more about, but haven’t had the time to look into it?", "What country do you never want to visit?", "What wrong assumptions do people make about you?","Do you prefer to work in a team or alone?", "What has been the best period of your life so far?", "How have you changed from when you were in high school?","How techie are you?", "Where is the most fun place around where you live?", "Have you ever joined any meetup groups?","Where would your friends or family be most surprised to find you?", "What’s the most relaxing situation you could imagine?", "What is the most beautiful view you’ve seen?","What’s expensive but totally worth it?", "When do you feel most out of place?", "What’s the most recent thing you’ve done for the first time?","How did you come to love your one of your favorite musicians?", "How did you meet your best friend?", "What small seemingly insignificant decision had a massive impact on your life?","Where would you move if you could move anywhere in the world and still find a job and maintain a reasonable standard of living?", "Would you like to be famous? (If yes, what would you want to be famous for? If no, why not?)", "What did you do last summer?","If you lived to 100, would you rather keep the body or the mind of yourself at 30 until you were 100?", "Before you make a call, do you rehearse what you are going to say?", "What are you most grateful for?","What’s the most essential part of a friendship?", "When was the last time you sang to yourself or to someone else?", "If you knew you were going to die in a year, what would you change about how you live?","When was the last time you walked for more than an hour?", "What did you do for (last holiday)? Or What will you do for (next closest holiday)?", "Best and worst flavor ice cream? What would make for an excellent new ice cream flavor?","Who’s your favorite actor or actress?", "How much personal space do you need to be comfortable?", "What’s the strangest phone conversation you’ve ever had?","What fad or trend have you never been able to understand?", "Who’s your favorite character from a TV show, movie, or book?", "What TV shows did you watch when you were a kid?","What do you like but are kind of embarrassed to admit?", "What’s your favorite smell?", "What skill or ability have you always wanted to learn?","What’s the best meal you’ve ever had?", "Where was your favorite place to go when you were a kid?", "What’s the most amount of people you had to present something in front of?","If you could go back in time as an observer, no one could see you, and you couldn’t interact with anything, when would you want to go back to?", "What’s something that most people haven’t done, but you have?", "What says the most about a person?","What machine or appliance in your house aggravates you the most?", "What places have you visited that exceeded your expectations?", "If you opened a business, what type of business would you start?","What’s the worst movie you’ve ever seen?", "What’s the best road trip you’ve been on?", "If you found a briefcase filled with 1 million in 100$ bills in front of your door, what would you do with it?","What’s the worst advice someone has given you?", "Besides your home and your work, where do you spend most of your time?", "If you could have the answer to any one question, what question would you want the answer to?","What are your top 3 favorite things to talk about?", "What do you care least about?", "Where would you like to retire?","Who is the most bizarre person you’ve met?", "What are people often surprised to learn about you?", "Would you rather live full time in an RV or full time on a sailboat?","What would you do with the extra time if you never had to sleep?", "When you were a kid, what seemed like the best thing about being a grown up?", "What’s the strangest way you’ve become friends with someone?","What’s your go-to series or movie when you want to watch something but can’t find anything to watch?", "What were some of the turning points in your life?", "What companies made you so mad that you would rather suffer bodily harm than give them any more of your money?","What small things brighten up your day when they happen?", "What are your favorite clothing brands?", "What sports would be funniest if the athletes had to be drunk while playing?","What’s the most ridiculous thing you’ve done because you were bored?", "How many other countries have you visited?", "What do you miss about life 10 or 20 years ago?","What’s your favorite holiday?", "What’s getting worse and worse as you get older? What’s getting better and better as you get older?", "Where’s the best place in (your town or city) to have a picnic?","What’s your favorite thing to do outdoors? How about indoors?", "How often do you dance? Silly/ironic dancing counts.", "What do you never get tired of?","What habit do you wish you could start?", "What’s the best way to get to know who someone really is?", "What’s the last new thing you tried?","Who besides your parents taught you the most about life?", "When are you the most “you” that you can be? In other words, when do you feel most like yourself?", "What’s the most spontaneous thing you’ve done?","What’s happening now, that in 20 years people will look back on and laugh about?", "How much social interaction is too much?", "How different do you act when you are with acquaintances vs. people you are comfortable with?","On a weekend or holiday, what’s the best time of day and the best time of night?", "What are you looking forward to that’s happening soon?", "What really cheesy song do you love?","What’s the worst or best job you’ve had?", "What’s been the most significant plot twist in your own life?", "Where did you take family vacations to when you were younger?","What’s your go-to funny story?", "If the company you work for / the college you go to had an honest slogan, what would it be?", "How well do you cope when you don’t have your phone with you for an extended period of time?","What were some of the happiest times of your life so far?", "Would you rather have an incredibly fast car or incredibly fast internet speed?", "What are the top three social situations you try to avoid most?","What friendship you’ve had has impacted you the most?", "What’s something you’re interested in that most people wouldn’t expect?", "What’s your favorite quote or saying?","If you had the power to change one law, what law would you change?", "What’s the hardest you’ve worked for something?", "What took you way too long to figure out?","What nicknames have you had throughout your life?", "What do you do differently than most people?", "Where’s the last place you’d ever go?","What fact floored you when you heard it?", "If you unexpectedly won 10,000$, what would you spend it on?", "Who is the best role model a person could have?"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.refreshQuestion), userInfo: nil, repeats: true)

        loginButton.layer.cornerRadius = 5.0
        loginButton.layer.borderWidth = 0.5
        loginButton.layer.borderColor = UIColor.clear.cgColor
        loginButton.layer.masksToBounds = true
        loginButton.layer.shadowColor = UIColor.darkGray.cgColor
        loginButton.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        loginButton.layer.shadowRadius = 1.0
        loginButton.layer.shadowOpacity = 0.7
        loginButton.layer.masksToBounds = false
        loginButton.layer.shadowPath = UIBezierPath(roundedRect: loginButton.bounds, cornerRadius: loginButton.layer.cornerRadius).cgPath
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer = nil
    }
    
    @objc func refreshQuestion() {
        UIView.animate(withDuration: 1.0, animations: {
            self.questionView.alpha = 0
        })
        
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
            self.questionText.text = self.trendingQuestions.randomElement()
            UIView.animate(withDuration: 1.0, animations: {
                self.questionView.alpha = 1
            })
        }
    }
}
