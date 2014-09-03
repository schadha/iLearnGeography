//
//  JigsawHardViewController.m
//  iLearnGeography
//
//  Created by Sanchit Chadha on 11/12/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import "JigsawHardViewController.h"


@interface JigsawHardViewController ()

@end

@implementation JigsawHardViewController

/*
 A geometric translation moves every point of our UIImageView object by the same amount
 in a given direction when it is panned (dragged) from one location to another.
 We store the (x, y) coordinates of the last translation of puzzleImage into the
 static variable lastTranslation.
 
 CGPoint is a structure that contains the (x, y) coordinate values
 */
static CGPoint lastTranslation;

/*
 Array that holds the last translation points for each puzzle piece so repetetive code
 doesn't have to be used.
 */
static CGPoint *lastTranslationPoints;

/*
 Array that holds the boolean switch for each puzzle piece that tells whether the piece
 has been placed in the correct location.
 */
static Boolean *pieceCorrectSwitches;

/*
 Switch that indicates if a piece is placed in the correct position. True if the piece
 is in the correct position on the screen, false otherwise. All of these switches must
 be true in order to win the game
 */
static Boolean pieceCorrect = FALSE;

/*
 Switch that indicates if the click sound has been played. It should only play
 once when a piece is snapped into its correct place. If a piece is moved out of
 its place and then snapped back into its correct place, the sound should play again.
 */
static Boolean clickPlayed = FALSE;

/*
 Switch that indicates whether a new game has been started. This is so that a new game
 isn't started everytime the user touches the background. It should only work once.
 */
static Boolean newGameStarted;

/*
 Switch that indicates whether the game has been ended.
 */
static Boolean gameEnded;

/*
 Initializers for the timer. The timer has a format of 00:00:00.00, where hours,
 minutes, seconds and miliseconds are incremented.
 */
static int timeMiliSec = 0;
static int timeSec = 0;
static int timeMin = 0;
static int timeHour = 0;
static NSTimer *timer; //Timer object that allows the time to be incremented
static NSString* timeNow; //The current time that is displayed on the label

#define kNumPieces 28 //Constant value that represents the number of puzzle pieces, 28.

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /**************************************************************************
     * Read in the puzzlePieceCenterCoordinates.plist file content
     **************************************************************************/
    
    // Obtain the file path to the puzzlePieceCenterCoordinates.plist file, which resides in the main bundle (project folder)
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"puzzlePieceCenterCoordinatesHard" ofType:@"plist"];
    
    // Instantiate a static dictionary and initialize it with the content of the puzzlePieceCenterCoordinates.plist file
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    // Set the object reference we declared in the header file to point to the newly created dictionary
    self.puzzlePieceCenterCoordinates = dictionary;
    
    // Obtain a sorted array of keys, i.e., the coordinates of each puzzle piece's center. Sorted in the same order as the dictionary
    NSArray *centerCoordinatesArray = [[self.puzzlePieceCenterCoordinates allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    
    // Set the object reference we declared in the header file to point to the newly created array
    self.centerCoordinates = centerCoordinatesArray;
    
    /**************************************************************************
     * Set up clickSound audio file.
     **************************************************************************/
    
    // Obtain the URL path to the click sound file, clickSound.wav.
    NSURL *clickSoundFilePath = [[NSBundle mainBundle] URLForResource: @"clickSound" withExtension: @"wav"];
    
    // Casting Objective-C pointer type "NSURL *" to C pointer type CFURLRef requires a bridged cast.
    self.clickSoundFileURLRef = (__bridge CFURLRef) clickSoundFilePath;
    
    /*
     Create a system sound object for the short sound (30 seconds or shorter) in file clickSound.wav
     */
    AudioServicesCreateSystemSoundID (self.clickSoundFileURLRef, &_clickSoundID);
    
    /*
     Allocate memory for an array of CGPoints representing the last translation points
     for each puzzle piece.
     */
    lastTranslationPoints = (CGPoint*) malloc(kNumPieces * sizeof(CGPoint));
    
    /*
     Allocate memory for an array of Booleans representing the correct position switch
     for each puzzle piece.
     */
    pieceCorrectSwitches = (Boolean*) malloc(kNumPieces * sizeof(Boolean));
    
    /*
     Instantiate lastTranslation point as a new CGPoint with default values of x = 0 and y = 0.
     */
    lastTranslation = CGPointMake(0, 0);
    
    /*
     Similar logic used throughout the program to assign each puzzle piece an attribute.
     -New UIPanGestureRecognizer allocated and initialized for each puzzle piece. This allows
      for panning and dragging the object.
     -puzzleImage object corresponds to each puzzle piece based on the key name of the puzzle
      piece obtained from the dictionary.
     -UIPanGestureRecognizer is added to the instantiated puzzleImage.
     -lastTranslationPoints array is filled with default lastTranslation points.
     -pieceCorrectSwitches array is filled with default boolean values of NO.
     */
    for (int i = 0; i < kNumPieces; i++)
    {
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning:)];
        UIImageView *puzzleImage = [self valueForKey:[self.centerCoordinates objectAtIndex:i]];
        [puzzleImage addGestureRecognizer:panRecognizer];
        
        lastTranslationPoints[i] = lastTranslation;
        pieceCorrectSwitches[i] = pieceCorrect;
    }
    
    //Draws the rectangle outline to provide a border for the puzzle pieces to go into.
    [self drawRectangle];
    [self.completeJigsawB setHidden:NO];
    newGameStarted = FALSE;
    gameEnded = TRUE;
}

/*
 Disposes the resources corresponding to the system sound after it is done playing.
 */
- (void)dealloc
{
    if (self.clickSoundID) {
        /*
         Call the C programming language function AudioServicesDisposeSystemSoundID with
         input value of instance variable _turkeyGobbleSoundID that points to the system
         sound object to dispose of the sound object and its associated resources.
         */
        AudioServicesDisposeSystemSoundID(_clickSoundID);
    }
}

/*
 Difficulty ActionSheet displayed to choose Easy or Hard difficulty
 */
- (IBAction)selectDifficultyButton:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Select Puzzle Difficulty"
                                  delegate:self     // This is where we designate the LongPressViewController
                                  // object as the delegate for the UIActionSheetDelegate protocol.
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Easy", @"Hard", nil];
    [actionSheet showInView:self.view];
}

/*
 Sets up a new game
 -All the pieceCorrect switches for each piece are reset to FALSE because when
 a new game occurs, none of the pieces should be in the correct position.
 -All pieces are enabled for user interaction
 -Timer is reset
 -The instruction label is hidden.
 -The completed jigsaw puzzle image is hidden.
 -The evaluation/result label is hidden.
 -Random positions for each jigsaw puzzle piece are established and assigned.
 -The timer is started.
 */
- (void)setUpNewGame
{
    for (int i = 0; i < kNumPieces; i++)
    {
        pieceCorrectSwitches[i] = FALSE;
    }
    [self setPiecesInteraction:YES];
    [self resetTimer];
    [self.instructionLabel setHidden:YES];
    [self.completeJigsawB setHidden:YES];
    [self.evaluationLabel setHidden:YES];
    [self generateRandomPositions];
    [self startTimer];
}

/*
 Difficulty ActionSheet displayed to choose Easy or Hard difficulty
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        
    }
    else if (buttonIndex == 0){
        UIStoryboard *jigsawPuzzleBoard = [UIStoryboard storyboardWithName:@"JigsawPuzzleEasy" bundle:nil];
        
        // Load the initial view controller from the storyboard.
        // Set this by selecting 'Is Initial View Controller' on the appropriate view controller in the storyboard.
        UIViewController *theInitialViewController = [jigsawPuzzleBoard instantiateInitialViewController];
        
        UINavigationController *navController = self.navigationController;
        
        [navController popViewControllerAnimated:NO];
        [navController pushViewController:theInitialViewController animated:NO];
        newGameStarted = FALSE;
    }
}

// New Game started when the background is touched
- (IBAction)backgroundTouch:(UIControl *)sender {
    if (!newGameStarted && gameEnded)
    {
        [self setUpNewGame];
        gameEnded = FALSE;
        newGameStarted = TRUE;
    }
}

/*
 Call This to Start timer, will tick every 0.1 seconds.
 */
-(void) startTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

/*
 Event called every time the NSTimer ticks.
 timeMiliSec is increased by 100 every tick, or by 0.1 seconds.
 timeSec is increased by 1 after every 1000 miliseconds.
 timeMin is increased by 1 after every 60 seconds.
 timeHour is increased by 1 after every 60 minutes.
 */
- (void)timerTick:(NSTimer *)timer
{
    timeMiliSec+=100;
    if (timeMiliSec == 1000)
    {
        timeMiliSec = 0;
        timeSec++;
    }
    if (timeSec == 60)
    {
        timeSec = 0;
        timeMin++;
    }
    if (timeMin == 60)
    {
        timeMin = 0;
        timeHour++;
    }
    //Format the string 00:00:00.00 (hr:mn:sc.ms)
    timeNow = [NSString stringWithFormat:@"%02d:%02d:%02d.%02d", timeHour, timeMin, timeSec, timeMiliSec/10];
    //Display on your label
    self.timerLabel.text= timeNow;
    
    /*
     Game status is checked at every tick to see if the game has been won or not. Every piece must be in the
     correct position in order for the endGame method to be called.
     */
    int numCorrect = 0;
    for (int i = 0; i < kNumPieces; i++)
    {
        if (pieceCorrectSwitches[i] == TRUE) {
            numCorrect++;
        }
    }
    /*
     If the number of correct pieces equals the number of pieces on the puzzle board, then
     the endGame method is called to end the game.
     */
    if (numCorrect == kNumPieces)
    {
        [self endGame];
    }
}

/*
 Resets the timer to its initial settings.
 -Stop the timer.
 -Miliseconds, Seconds, Minutes and Hours set to 0.
 -Current time is set to 00:00:00.00
 -The timerLabel is set to the current time.
 */
- (void) resetTimer
{
    [timer invalidate];
    timeMiliSec = 0;
    timeSec = 0;
    timeMin = 0;
    timeHour = 0;
    timeNow = [NSString stringWithFormat:@"%02d:%02d:%02d.%02d", timeHour, timeMin, timeSec, timeMiliSec];
    self.timerLabel.text = timeNow;
}

/*
 Method called when the game has been won.
 -Stops the timer
 -Stops user interaction of pieces
 -Makes the completed jigsaw puzzle image visable
 -Evaluates level of game success based on how long the player took to complete the puzzle.
 */
- (void) endGame
{
    [timer invalidate];
    [self setPiecesInteraction:NO];
    [self.completeJigsawB setHidden:NO];
    
    NSString *levelOfGameSuccess;
    /*
     levelOfGameSuccess decided as follows:
     >4 minutes: Slow
     3 - 4 minutes: Satisfactory
     2 minutes - 3 minutes: Good
     90 seconds - 2 minutes: Excellent
     <90 seconds: Outstanding
     */
    if (timeMin >= 4 && timeSec >= 0)
    {
        levelOfGameSuccess = @"Slow";
    }
    else if (timeMin >= 3 && timeSec < 60)
    {
        levelOfGameSuccess = @"Satisfactory";
    }
    else if (timeMin >= 2 && timeSec < 60)
    {
        levelOfGameSuccess = @"Good";
    }
    else if (timeMin == 1 && timeSec >= 30)
    {
        levelOfGameSuccess = @"Excellent";
    }
    else
    {
        levelOfGameSuccess = @"Outstanding";
    }
    
    NSString *evaluation = [NSString stringWithFormat:@"You did %@!", levelOfGameSuccess ];
    [self.evaluationLabel setHidden:NO];
    self.evaluationLabel.text = evaluation;
    gameEnded = TRUE;
    newGameStarted = FALSE;
    [self changeSectionData:@"red-green"];
}

/*
 Method that changes the Sections plist for a specified key.
 Changes the value assocaiated with a key to the imageName.
 This allows for the cell to display that image specified.
 */
-(void)changeSectionData:(NSString *)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"Sections.plist"];
    NSMutableDictionary *sections = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInDocumentsDirectory];
    
    if ([[sections valueForKey:@"Jigsaw Puzzle"] isEqualToString:@"green-red"])
    {
        imageName = @"green-dot";
    }
    
    [sections setValue:imageName forKey:@"Jigsaw Puzzle"];
    [sections writeToFile:plistFilePathInDocumentsDirectory atomically:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.sectionData = sections;
}

/*
 Sets the user interaction for each puzzle piece. This is so that the pieces
 cannot be interacted with when the game has been won.
 */
- (void) setPiecesInteraction:(Boolean)interact
{
    for (int i = 0; i < kNumPieces; i++)
    {
        UIImageView *puzzleImage = [self valueForKey:[self.centerCoordinates objectAtIndex:i]];
        [puzzleImage setUserInteractionEnabled:interact];
    }
}

/*
 Generates random positions for each puzzle piece.
 -Creates two new arrays reprsenting the x and y coordinates for each jigsaw puzzle piece.
 -Sets the width and height of the screen. 170 is subtracted from both width and height
  so all pieces fit within the screen boundaries and are not accidently hidden off screen.
  170 was decided because the average width and height of the puzzle pieces was approximately 170.
 -For each puzzle piece, a random X and Y coordinate is created.
    -X coordinate can be between 0 to the height of the screen (Screen is horizontal)
    -Y coordinate can be between 20 (below status bar) to the width of the screen (Screen is horizontal)
 -puzzleImage object corresponds to each puzzle piece based on the key name of the puzzle
 piece obtained from the dictionary.
 -puzzleImage is placed at the random coordinate.
 -puzzleImage is set to visible.
 */
-(void)generateRandomPositions
{
    CGFloat xCoordinates[kNumPieces];
    CGFloat yCoordinates[kNumPieces];
    
    CGFloat width = self.view.frame.size.width - 220;
    CGFloat height = self.view.frame.size.height - 220;
    //NSLog(@"Actual Width/Height: %f/%f", self.view.frame.size.width, self.view.frame.size.height);
    //NSLog(@"Adjusted Width/Height: %f/%F", width, height);
    CGFloat randomXcoordinate;
    CGFloat randomYcoordinate;
    for (int i = 0; i < kNumPieces; i++) {
        randomXcoordinate = arc4random_uniform(width);
        randomYcoordinate = 20 + arc4random_uniform(height);
        xCoordinates[i] = randomXcoordinate;
        yCoordinates[i] = randomYcoordinate;
        
        UIImageView *puzzleImage = [self valueForKey:[self.centerCoordinates objectAtIndex:i]];
        //NSLog(@"Image %d: X-%f Y-%f\n", i, xCoordinates[i], yCoordinates[i]);
        puzzleImage.frame = (CGRect){{xCoordinates[i], yCoordinates[i]}, puzzleImage.frame.size};
        [puzzleImage setHidden:FALSE];
    }
}

-(void)drawRectangle
{
    // Obtain the height, width information of the super view.
    CGFloat height = self.view.frame.size.height;
    CGFloat width = self.view.frame.size.width;
    CGFloat halfHeight = self.view.frame.size.height/2;
    CGFloat halfWidth = self.view.frame.size.width/2;
    
    // Obtain the size of the full puzzle image: jigsawPuzzlePhoto.png
    CGFloat imageWidthInPixels = 485;
    CGFloat imageHeightInPixels = 485;
    
    // Calculate the position where rectangle canvas is placed. (Top left corner of rect)
    CGFloat positionRectY = (height/2) - (imageWidthInPixels/2);
    CGFloat positionRectX = (width/2) - (imageHeightInPixels/2);
    
    // Geometric objects (e.g., rectangle) can be drawn on top of a UIImageView object
    // Therefore, create a UIImageView object as your canvas with a size of 1024x768 to hold the drawings
    // Specify in the .h file: @property (strong, nonatomic)  UIImageView *backgroundRect;
    self.backgroundRectB = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, height, width)];
    
    // Create a bitmap-based graphics context and make it the current context.
    UIGraphicsBeginImageContext(self.view.frame.size);
    
    // Draw the entire image in the specified rectangle, scaling it as needed to fit.
    [self.backgroundRectB.image drawInRect:CGRectMake(0, 0, width, height)];
    
    // Obtain the current graphics context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Create a new empty path in the current graphics context
    CGContextBeginPath(context);
    
    // Draw a rectangle with the given position and size
    CGContextStrokeRect(context, CGRectMake(positionRectX, positionRectY, imageHeightInPixels, imageWidthInPixels));
    
    // Set the background canvas to the contents of the current bitmap graphics context.
    self.backgroundRectB.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Remove the current bitmap-based graphics context from the top of the stack.
    UIGraphicsEndImageContext();
    
    // Set the background canvas center
    [self.backgroundRectB setCenter:CGPointMake(halfHeight, halfWidth)];
    
    [self.view addSubview:self.backgroundRectB];
    [self.view sendSubviewToBack:self.backgroundRectB];
}

#pragma mark - Panning (Dragging) Handling Methods
/*
 Handle panning/dragging gesture for each puzzle piece.
 */
- (void)handlePanning:(UIPanGestureRecognizer *)recognizer {
    
    // Gets the puzzleImage object corresponding to the piece the user touched.
    UIImageView *puzzleImage = (UIImageView *)[recognizer view];
    
    [self.view bringSubviewToFront:puzzleImage];
    
    /* 
     Gets the index corresponding to the touched puzzle piece. Tag for each puzzle
     piece corresponds to its index in an array.
     */
    NSInteger pieceIndex = [puzzleImage tag];
    
    // Point that represents how much in both the x and y directions the piece was translated/dragged.
    CGPoint newTranslation = [recognizer translationInView:puzzleImage];

    // Transforms the image by the amount the user dragged the image.
    recognizer.view.transform = CGAffineTransformMakeTranslation(lastTranslationPoints[pieceIndex].x + newTranslation.x,
                                                                 lastTranslationPoints[pieceIndex].y + newTranslation.y);
    
    /*
     If the pan gesture has ended, the last translation point for that jigsaw
     piece is updated with the amount the image was translated.
     */
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        lastTranslationPoints[pieceIndex].x += newTranslation.x;
        lastTranslationPoints[pieceIndex].y += newTranslation.y;
    }
    
    // An array of actual center coordinates for the touched jigsaw puzzle piece.
    NSArray *coords = [self.puzzlePieceCenterCoordinates objectForKey:[self.centerCoordinates objectAtIndex:pieceIndex]];
    
    // Obtains the actual X and Y coordinates and converts them to CGFloat values.
    NSNumber *centerXActualNumber = coords[0];
    CGFloat centerXActual = [centerXActualNumber floatValue];
    NSNumber *centerYActualNumber = coords[1];
    CGFloat centerYActual = [centerYActualNumber floatValue];
    
    /*
     The delta X and Y values correspond to the X and Y distances from the origin
     of the image to the center X and Y coordinates.
     */
    CGFloat deltaX = puzzleImage.frame.size.width/2;
    CGFloat deltaY = puzzleImage.frame.size.height/2;
    
    /*
     The center X and Y coordinates of the touched puzzle piece.
     */
    CGFloat centerX = puzzleImage.frame.origin.x + deltaX;
    CGFloat centerY = puzzleImage.frame.origin.y + deltaY;
    
    /*
     The logic behind checking if the touched puzzle piece is in its correct position.
     The center X and Y coordinates of the puzzle piece should be within 20 points of the
     actual center X and Y coordinates that correspond to the correct puzzle piece location.
     */
    if (centerX >= centerXActual - 20 &&
        centerX <= centerXActual + 20 &&
        centerY >= centerYActual - 20 &&
        centerY <= centerYActual + 20)
    {
        // If the coordinates are within that boundary, the image is moved to the actual position.
        puzzleImage.frame = (CGRect){{centerXActual-deltaX, centerYActual-deltaY}, puzzleImage.frame.size};
        
        // The correct switch for that puzzle piece is changed to YES.
        pieceCorrectSwitches[pieceIndex] = TRUE;
        
        // If the click sound has not been played yet, play it when the puzzle piece snaps into place.
        if (!clickPlayed)
        {
            AudioServicesPlaySystemSound(_clickSoundID);
        }
        // The click sound has been played.
        clickPlayed = TRUE;
    }
    else{
        /*
         If the piece is moved out of the correct boundary, the correct
         switch for that piece is changed to NO. And the click sound is set to
         not played so that when the piece is put back in the correct boundary,
         the click sound can be played again.
         */
        pieceCorrectSwitches[pieceIndex] = FALSE;
        clickPlayed = FALSE;
    }
}
@end