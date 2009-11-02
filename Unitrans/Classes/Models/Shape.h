//
//  Shape.h
//  Unitrans
//
//  Created by Kip Nicol on 10/27/09.
//  Copyright 2009  All rights reserved.
//

#import <CoreData/CoreData.h>

@class Trip;

@interface Shape :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * pointSequence;
@property (nonatomic, retain) NSNumber * pointLongitude;
@property (nonatomic, retain) NSNumber * pointLatitude;
@property (nonatomic, retain) Trip * trip;

@end



