//
//  CreditsViewController.h
//  DavisTrans
//
//  Created by Kip on 4/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CreditsViewController : UIViewController {
    UITextView *creditsTextView;
    UILabel *versionLabel;
}

@property (nonatomic, retain) IBOutlet UITextView *creditsTextView;
@property (nonatomic, retain) IBOutlet UILabel *versionLabel;

@end
