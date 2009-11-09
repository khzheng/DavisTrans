//
//  RealTimeBusInfoManager.h
//  Unitrans
//
//  Created by Ken Zheng on 11/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RealTimeBusInfoManager : NSObject {
	NSMutableArray *realTimeBusInfo;
	NSString *currentElement;
	NSXMLParser *xmlParser;
	NSInteger lastTime;
}

@property (nonatomic, retain) NSMutableArray *realTimeBusInfo;
@property (nonatomic, retain) NSString *currentElement;
@property (nonatomic, retain) NSXMLParser *xmlParser;
@property (nonatomic, assign) NSInteger lastTime;

- (NSArray *) getRealTimeBusInfo;
- (NSArray *) getRealTimeBusInfoFromLastTime;

@end