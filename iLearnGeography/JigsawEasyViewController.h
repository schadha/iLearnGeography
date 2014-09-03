//
//  JigsawEasyViewController.h
//  iLearnGeography
//
//  Created by Sanchit Chadha on 11/19/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"
#import "MenuViewController.h"
#import "ECSlidingViewController.h"

@interface JigsawEasyViewController : UIViewController<UIActionSheetDelegate>

// The outline for the jigsaw puzzle
@property (strong, nonatomic) IBOutlet UIImageView *backgroundRectA;

// The completed jigsaw puzzle imageView.
@property (strong, nonatomic) IBOutlet UIImageView *completeJigsawA;

// The new game button method declaration. Logic of that button goes in this method.
- (IBAction)selectDifficultyButton:(UIButton *)sender;

// The instruction label shown on the top and the timer label shown on the top-right.
@property (strong, nonatomic) IBOutlet UILabel *instructionLabel;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;

// The evaluation label shown when the game is won.
@property (strong, nonatomic) IBOutlet UILabel *evaluationLabel;

- (IBAction)backgroundTouch:(UIControl *)sender;

// 12 total puzzle pieces. Each piece is an imageView.
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageEasy1;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageEasy2;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageEasy3;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageEasy4;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageEasy5;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageEasy6;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageEasy7;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageEasy8;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageEasy9;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageEasy10;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageEasy11;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageEasy12;


// The dictionary corresponding to the puzzlePieceCenterCoordinates plist.
@property (nonatomic, strong) NSDictionary *puzzlePieceCenterCoordinates;

// The array conrresponding to each value of a dictionary key.
@property (nonatomic, strong) NSArray *centerCoordinates;

// The soundID and URLRef for the clickSound.wav file.
@property (readonly)    SystemSoundID   clickSoundID;
@property (readwrite)   CFURLRef        clickSoundFileURLRef;

// The PanGestureRecognizer handler that hanndles the dragging gesture for each puzzle piece.
- (void)handlePanning:(UIPanGestureRecognizer *)recognizer;

@end
