//
//  JigsawViewController.h
//  iLearnGeography
//
//  Created by Sanchit Chadha on 11/12/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"

@interface JigsawHardViewController : UIViewController<UIActionSheetDelegate>

// The outline for the jigsaw puzzle
@property (strong, nonatomic) IBOutlet UIImageView *backgroundRectB;

// The completed jigsaw puzzle imageView.
@property (strong, nonatomic) IBOutlet UIImageView *completeJigsawB;

- (IBAction)backgroundTouch:(UIControl *)sender;

// The new game button method declaration. Logic of that button goes in this method.
- (IBAction)selectDifficultyButton:(UIButton *)sender;

// The instruction label shown on the top and the timer label shown on the top-right.
@property (strong, nonatomic) IBOutlet UILabel *instructionLabel;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;

// The evaluation label shown when the game is won.
@property (strong, nonatomic) IBOutlet UILabel *evaluationLabel;

@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard1;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard2;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard3;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard4;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard5;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard6;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard7;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard8;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard9;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard10;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard11;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard12;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard13;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard14;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard15;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard16;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard17;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard18;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard19;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard20;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard21;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard22;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard23;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard24;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard25;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard26;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard27;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImageHard28;



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
