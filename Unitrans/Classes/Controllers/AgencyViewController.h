//
//  AgencyViewController.h
//  Unitrans
//
//  Created by Ken Zheng on 11/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TableViewController.h"
#import "AboutViewController.h"

typedef enum _AgencyViewSectionIndex {
    SectionIndexFavorites = 0,
    SectionIndexRoutes = 1
} AgencyViewSectionIndex;

@class Agency;
@class Route;

@interface AgencyViewController : TableViewController <AboutViewControllerDelegate> {
    Agency *agency;
	NSArray *routes;
	NSMutableArray *favorites;
}

@property (nonatomic, retain) Agency *agency;
@property (nonatomic, retain) NSArray *routes;
@property (nonatomic, retain) NSMutableArray *favorites;

- (void)addFavoriteStop:(NSDictionary *)stopInfo;
- (void)removeFavoriteStop:(NSDictionary *)stopInfo;
- (NSArray *)allFavoriteStopsForRoute:(Route *)route;

@end
