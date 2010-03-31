// 
//  Stop.m
//  Unitrans
//
//  Created by Kip Nicol on 10/27/09.
//  Copyright 2009  All rights reserved.
//

#import "Stop.h"

#import "StopTime.h"
#import "Route.h"
#import "Trip.h"

@implementation Stop 

@dynamic code;
@dynamic name;
@dynamic longitude;
@dynamic latitude;
@dynamic heading;
@dynamic stopDescription;
@dynamic stopTimes;
@synthesize sequence;

#if USING_MAP_KIT
    @dynamic coordinate;
#endif

- (NSArray *)allStopTimesWithRoute:(Route *)route onDate:(NSDate *)date
{
    NSMutableArray *routeStopTimes = [NSMutableArray array];
    
    // Iterate through stopTimes and find times with given Route and date
    for (StopTime *stopTime in [self stopTimes])
    {
        if ([[[stopTime trip] route] isEqual:route] && [[stopTime trip] hasServiceOnDate:date])
            [routeStopTimes addObject:stopTime];
    }
    
    return [NSArray arrayWithArray:routeStopTimes];
}

- (NSNumber *)stopID
{
    // Subtract 22000 from the stop code to get the stop ID
    return [NSNumber numberWithInteger:[[self code] integerValue] - 22000];
}

- (NSString *)headingString
{
    switch ([[self heading] intValue]) {
        case kStopHeadingTypeNorthBound: return @"Northbound";
        case kStopHeadingTypeSouthBound: return @"Southbound";
        case kStopHeadingTypeWestBound:  return @"Westbound";
        case kStopHeadingTypeEastBound:  return @"Eastbound";
    }
    
    return @"";
}

- (NSComparisonResult)compare:(Stop *)otherStop
{
	NSString *stopString1 = [NSString stringWithFormat:@"%@ %@", [self name], [self headingString]];
	NSString *stopString2 = [NSString stringWithFormat:@"%@ %@", [otherStop name], [otherStop headingString]];
	return [stopString1 compare:stopString2];
}

#if USING_MAP_KIT
- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self latitude] doubleValue];
    coordinate.longitude = [[self longitude] doubleValue];
    return coordinate;
}
#endif

- (NSString *)title
{
    if ([[self sequence] integerValue] == -1)
        return [self name];
    
    return [NSString stringWithFormat:@"%@. %@", [self sequence], [self name]];
}

- (NSString *)subtitle
{
    return [NSString stringWithFormat:@"#%@ %@", [self stopID], [self headingString]];
}

@end
