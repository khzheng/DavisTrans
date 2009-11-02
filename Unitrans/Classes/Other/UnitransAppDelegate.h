//
//  UnitransAppDelegate.h
//  Unitrans
//
//  Created by Kip Nicol on 10/21/09.
//  Copyright Apple Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnitransAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
