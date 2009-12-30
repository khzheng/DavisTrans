//
//  RouteSegmentedViewController.h
//  Unitrans
//
//  Created by Kip on 12/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentedViewController.h"

@class Route;
@class RouteViewController;
@class RouteMapViewController;

@interface RouteSegmentedViewController : SegmentedViewController {
    Route *route;
    
    RouteViewController *routeViewController;
    RouteMapViewController *routeMapViewController;
}

@property (nonatomic, retain) Route *route;

@end