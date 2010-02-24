//
//  PredictionsView.m
//  Unitrans
//
//  Created by Kip on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PredictionsView.h"

#import "Route.h"
#import "Stop.h"

CGFloat kPredictionLabelPadding = 10.0;
CGFloat kLoadingIndicatorPadding = 5.0;

@implementation PredictionsView

@synthesize predictions;
@synthesize predictionOperation;
@synthesize route;
@synthesize stop;

- (id)initWithFrame:(CGRect)frame 
{
    shadowOffset = 3;
    
    self = [super initWithFrame:frame];
    
    if (self) {        
        // Init predictions to an empty array
        predictions = [[NSArray alloc] init];
        
        // Create non-highlighted background image
        UIImage *backgroundImage = [[UIImage imageNamed:@"RedButton.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
        [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        
        // Set up loading indicator
        loadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [loadingIndicatorView setCenter:CGPointMake(frame.size.width - [loadingIndicatorView frame].size.width/2.0 - kLoadingIndicatorPadding , frame.size.height/2.0)];
        [self addSubview:loadingIndicatorView];
        
        // Set up prediction label
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[self titleLabel] setFont:[UIFont boldSystemFontOfSize:20]];
        [[self titleLabel] setShadowOffset:CGSizeMake(0, 1)];
        [[self titleLabel] setAdjustsFontSizeToFitWidth:YES];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(-shadowOffset, kPredictionLabelPadding, 0, kPredictionLabelPadding)];
        
        // Handle touches inside to update predictions
        [self addTarget:self action:@selector(updatePredictions) forControlEvents:UIControlEventTouchUpInside];
        
        // Update prediction text
        [self updatePredictionText];
    }
    
    return self;
}

- (void)dealloc
{
    // End continuous updates if still running
    if (predictionsContinuousUpdatesRunning)
        [self endContinuousPredictionsUpdates];
    
    [predictions release];
    [predictionOperation release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Prediction Update Methods

- (void)beginContinuousPredictionsUpdates
{
    predictionsContinuousUpdatesRunning = YES;
    
    [self updatePredictions];
    
    // If we are still updating after the first update, start a timer to updated every 20 seconds
    if (predictionsContinuousUpdatesRunning)
        predictionTimer = [[NSTimer scheduledTimerWithTimeInterval:20.0
                                                            target:self
                                                          selector:@selector(updatePredictions) 
                                                          userInfo:nil
                                                           repeats:YES] retain];
}

- (void)endContinuousPredictionsUpdates
{
    predictionsContinuousUpdatesRunning = NO;
    
    [self setPredictionOperation:nil];
    
    [predictionTimer invalidate];
    [predictionTimer release];
    predictionTimer = nil;
}

- (void)updatePredictions
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [loadingIndicatorView startAnimating];
    loading = YES;
    
    [self setPredictionOperation:[[[PredictionOperation alloc] initWithRouteName:[route shortName] stopTag:[[stop code] stringValue]] autorelease]];
    [predictionOperation setDelegate:self];
    [predictionOperation start];
    
    [self updatePredictionText];
}

- (void)updatePredictionText
{
    NSString *predictionText;
    
    if(loading && (!predictions || [predictions count] == 0))
        predictionText = @"Updating Predictions...";
    else if (!predictions)
        predictionText = @"Error gathering predictions.";
    else if ([predictions count] == 1 && [[predictions objectAtIndex:0] isEqual:@"Now"])
        predictionText = @"Now";
    else if ([predictions count] > 0)
        predictionText = [NSString stringWithFormat:@"%@ minutes", [predictions componentsJoinedByString:@", "]];
    else
        predictionText = @"No predictions at this time."; 
        
    [self setTitle:predictionText forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark PredictionOperation Delegate Methods

- (void)predictionOperation:(PredictionOperation *)predictionOperation didFinishWithPredictions:(NSArray *)newPredictions
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [loadingIndicatorView stopAnimating];
    loading = NO;
    
    // If the first time is 0 convert it to "Now"
    NSMutableArray *mutableNewPredictions = [NSMutableArray arrayWithArray:newPredictions];
    if ([newPredictions count] > 0 && [[newPredictions objectAtIndex:0] isEqualToNumber:[NSNumber numberWithInteger:0]])
        [mutableNewPredictions replaceObjectAtIndex:0 withObject:@"Now"];
	
    [self setPredictions:[NSArray arrayWithArray:mutableNewPredictions]];
    [self updatePredictionText];
}

- (void)predictionOperation:(PredictionOperation *)predictionOperation didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [loadingIndicatorView stopAnimating];
    loading = NO;
    
    [self endContinuousPredictionsUpdates];
    
    [self setPredictions:nil];
    [self updatePredictionText];
}

#pragma mark -
#pragma mark UIResponder Touch Event Methods

- (void)showLoadingError
{
    NSString *reason = @"There was an error while loading the predictions. Make sure you are connected to the internet.";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Predictions Loading Error" message:reason
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark -
#pragma mark Custom Accessor Methods

- (void)setFrame:(CGRect)frame
{
    // Add shadowOffset values to frame to accommodate for shadow
    CGRect superFrame = frame;
    superFrame.size.height += shadowOffset;
    
    [super setFrame:superFrame];
}

#pragma mark -
#pragma mark Draw Methods

/*- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGRect bounds = [self bounds];
    CGRect boundsOffset = CGRectOffset(bounds, 0, -shadowOffset);
    CGSize myShadowOffset = CGSizeMake(0, -shadowOffset);
    
    CGContextSetShadow(context, myShadowOffset, 5);
    
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, boundsOffset);
    
    CGContextRestoreGState(context);
}*/

@end
