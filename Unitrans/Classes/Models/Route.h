//
//  Route.h
//  Unitrans
//
//  Created by Kip Nicol on 10/27/09.
//  Copyright 2009  All rights reserved.
//

#import <CoreData/CoreData.h>

@class Agency;
@class Trip;

@interface Route :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * routeDescription;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * textColor;
@property (nonatomic, retain) NSNumber * color;
@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) NSString * longName;
@property (nonatomic, retain) NSSet* trips;
@property (nonatomic, retain) Agency * agency;

- (NSArray *)allStops;

@end


@interface Route (CoreDataGeneratedAccessors)
- (void)addTripsObject:(Trip *)value;
- (void)removeTripsObject:(Trip *)value;
- (void)addTrips:(NSSet *)value;
- (void)removeTrips:(NSSet *)value;

@end

