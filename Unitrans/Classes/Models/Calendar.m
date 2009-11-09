// 
//  Calendar.m
//  Unitrans
//
//  Created by Kip Nicol on 10/27/09.
//  Copyright 2009  All rights reserved.
//

#import "Calendar.h"

#import "CalendarDate.h"
#import "Trip.h"

@implementation Calendar 

@dynamic tuesday;
@dynamic endDate;
@dynamic monday;
@dynamic friday;
@dynamic saturday;
@dynamic thursday;
@dynamic startDate;
@dynamic wednesday;
@dynamic sunday;
@dynamic trips;
@dynamic calendarDates;

// TODO: incorporate exceptions
- (BOOL)hasServiceDate:(NSDate *)date
{
    // Iterate through calendarDates and check whether the
    // given date has an exception
    for (CalendarDate *calendarDate in [self calendarDates]) {
        if ([[calendarDate date] isEqualToDate:date]) {
            switch ([[calendarDate exceptionType] integerValue]) {
                case 1: return YES; // Service has been added
                case 2: return NO; // Service has been dropped
                default:
                    NSLog(@"%@ - %s - Error: unknown calendarDate exception type %d", self, _cmd, [calendarDate exceptionType]);
                    return NO;
            }
        }
    }
    
    // If there was no exception we check to see if 
    // there is service on the date's weekday
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
    NSInteger weekday = [components weekday];
    
    switch (weekday) {
        case 1: return [[self sunday] boolValue];
        case 2: return [[self monday] boolValue];
        case 3: return [[self tuesday] boolValue];
        case 4: return [[self wednesday] boolValue];
        case 5: return [[self thursday] boolValue];
        case 6: return [[self friday] boolValue];
        case 7: return [[self saturday] boolValue];
            
        default:
            NSLog(@"%@ - %s - Error: unknown weekday component %d", self, _cmd, weekday);
    }
    
    return NO;
}

@end