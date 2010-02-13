//
//  PredictionsView.h
//  Unitrans
//
//  Created by Kip on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PredictionOperation.h"

@class Route;
@class Stop;

@interface PredictionsView : UIView <PredictionOperationDelegate> {
    NSArray *predictions;
    PredictionOperation *predictionOperation;
    NSTimer *predictionTimer;
    
    BOOL loading;
    BOOL predictionsContinuousUpdatesRunning;
    
    Route *route;
    Stop *stop;
    
    UILabel *predictionsLabel;
    UIImageView *backgroundImageView;
    UIActivityIndicatorView *loadingIndicatorView;
    
    CGFloat shadowOffset;
}

@property (nonatomic, retain) NSArray *predictions;
@property (nonatomic, retain) PredictionOperation *predictionOperation;
@property (nonatomic, retain) Route *route;
@property (nonatomic, retain) Stop *stop;

- (void)beginContinuousPredictionsUpdates;
- (void)endContinuousPredictionsUpdates;

- (void)updatePredictionText;
- (void)updatePredictions;


@end
