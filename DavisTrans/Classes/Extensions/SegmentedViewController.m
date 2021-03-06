//
//  SegmentedViewController.m
//  DavisTrans
//
//  Created by Kip on 12/24/09.
//  Copyright 2009 Kip Nicol & Ken Zheng
//

#import "SegmentedViewController.h"

#import "ExtendedViewController.h"

// Below are constants to define the width of the UIBarButtonItems in the 
// segmented toolbar. We have to do this to center the segmented control
// when there is a single right or left bar button item. We can set the
// fixedSpace, opposite of the single UIBarButtonItem, to a fixed width
// to offset the width from the single UIBarButtonItem. Apparently we also
// have to increase the width of the fixed space width.
#define kSegmentedBarButtonWidth    40.0
#define kSegmentedFixedSpaceWidth  (kSegmentedBarButtonWidth + 3.0)

@implementation SegmentedViewController

@synthesize contentView;
@synthesize selectedViewController;
@synthesize segmentedControl;
@synthesize segmentItems;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        segmentWidth = 90.0;
        viewTransitionDuration = 1.0;
        transitionContexts = [NSMutableSet new];
    }
    
    return self;
}

- (void)dealloc 
{
    [selectedViewController setSegmentedViewController:nil];
    [selectedViewController release];
    
    [contentView release];
    [segmentedControl release];
    [segmentedButtonItem release];
    [flexibleSpaceItem release];
    [fixedSpaceItem release];
    [transitionContexts release];
    
    [segmentItems release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Unhide the toolbar and set tint color
    [[[self navigationController] toolbar] setTintColor:[[[self navigationController] navigationBar] tintColor]];
 
    // Create segmentedControl used to switch between views
    segmentedControl = [[UISegmentedControl alloc] initWithItems:[self segmentItems]];
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setTintColor:[[[self navigationController] navigationBar] tintColor]];
    
    // Create the segmented button item to add to the toolbar
    segmentedButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    [segmentedButtonItem setWidth:(segmentWidth * [segmentItems count])];
    
    // Create a flexible and fixed space item to use in the toolbar
    flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    fixedSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [fixedSpaceItem setWidth:kSegmentedFixedSpaceWidth];
    
    // Create a content view to hold views for animation
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[self view] frame].size.width, [[self view] frame].size.height)];
    [contentView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    [[self view] addSubview:contentView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    // Select first segment if there are segments to select and one hasn't already been selected
    if ([[self segmentItems] count] != 0 && !selectedViewController) {
        [segmentedControl setSelectedSegmentIndex:0];
        [self segmentIndexWasSelected:[segmentedControl selectedSegmentIndex]];
    }
    
    // Forward onto selected view controller
    [selectedViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Forward onto selected view controller
    [selectedViewController viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Forward onto selected view controller
    [selectedViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Forward onto selected view controller
    [selectedViewController viewDidDisappear:animated];
}

#pragma mark -
#pragma mark Action Methods

- (IBAction)segmentAction:(id)sender
{
    // Select new segment view when user changes segment
    [self segmentIndexWasSelected:[segmentedControl selectedSegmentIndex]];
}

#pragma mark -
#pragma mark Segmented Methods To Override

- (ExtendedViewController *)viewControllerForSelectedSegmentIndex:(NSInteger)index
{
    return nil;
}

#pragma mark -
#pragma mark Private Segmented Methods

- (void)segmentIndexWasSelected:(NSInteger)index
{
    ExtendedViewController *newSelectedViewController = [self viewControllerForSelectedSegmentIndex:index];
    
    // If there is no viewController for selected index set view to nil and return
    if (!newSelectedViewController) {
        [self setView:nil];
        [self setSelectedViewController:nil];
        return;
    }
    
    // Set segmentedViewController
    [newSelectedViewController setSegmentedViewController:self];
        
    // Get the selected view from the viewController
    UIView *selectedView = [newSelectedViewController view];
    
    // Get the buttonItems from the viewController
    UIBarButtonItem *rightBarButtonItem = [newSelectedViewController rightSegmentedBarButtonItem];
    UIBarButtonItem *leftBarButtonItem = [newSelectedViewController leftSegmentedBarButtonItem];
    
    // Set the width to a constant value so we can center the segmented control
    [rightBarButtonItem setWidth:kSegmentedBarButtonWidth];
    [leftBarButtonItem setWidth:kSegmentedBarButtonWidth];
        
    // If there is no corresponding button item,
    // replace it with a flexible item
    if (!rightBarButtonItem)
        rightBarButtonItem = fixedSpaceItem;
    if (!leftBarButtonItem)
        leftBarButtonItem = fixedSpaceItem;
        
    // Create an array of toolbar items and set them
    NSArray *toolbarItems = [NSArray arrayWithObjects:leftBarButtonItem, flexibleSpaceItem, segmentedButtonItem, flexibleSpaceItem, rightBarButtonItem, nil];
    [self setToolbarItems:toolbarItems];
 
    if (!selectedViewController)
        [self setMainView:selectedView];
    else
        [self animateViewTransitionFromViewController:selectedViewController toViewController:newSelectedViewController];
    
    [self setSelectedViewController:newSelectedViewController];
}

#pragma mark -
#pragma mark View Transition Methods

- (void)animateViewTransitionFromViewController:(ExtendedViewController *)fromViewCtl toViewController:(ExtendedViewController *)toViewCtl
{    
    // Disable interaction with the navbar so the user can't hit the back button while in transition
    [[[self navigationController] navigationBar] setUserInteractionEnabled:NO];
    
    NSDictionary *context = [NSDictionary dictionaryWithObjectsAndKeys:fromViewCtl, @"FromViewController",
                                                                       toViewCtl,   @"ToViewController", nil];
    [transitionContexts addObject:context];
    
    // Determine animation
    UIViewAnimationTransition transition = [toViewCtl segmentTransition];

    // Tell child vcs that they are about to change (make sure that views are loaded before)
    [fromViewCtl view];
    [toViewCtl view];
    [fromViewCtl viewWillDisappear:YES];
    [toViewCtl viewWillAppear:YES];
    
    // Initialize the frame outside the animation block so that the
    // view's resizing doesn't get animated
    [self prepareViewToBecomeMainView:toViewCtl.view];
    
    // Animate setting view property to new view
	[UIView beginAnimations:nil context:context];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animateViewTransitionDidStop:finished:context:)];
	[UIView setAnimationDuration:viewTransitionDuration];

    [self setMainView:[toViewCtl view]];
    
	[UIView setAnimationTransition:transition
                           forView:contentView
                             cache:YES];
	
	[UIView commitAnimations];
}
                                                  
- (void)finishAnimateViewTransitionFromViewController:(ExtendedViewController *)fromViewCtl toViewController:(ExtendedViewController *)toViewCtl
{
    // Notify view controllers of disappearance and appearance
    [fromViewCtl viewDidDisappear:YES];
    [toViewCtl viewDidAppear:YES];
    
    // Re-enable navbar interaction
    [[[self navigationController] navigationBar] setUserInteractionEnabled:YES];
}

- (void)animateViewTransitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    NSDictionary *contextDictionary = (NSDictionary *)context;
    ExtendedViewController *fromViewCtl = [contextDictionary objectForKey:@"FromViewController"];
    ExtendedViewController *toViewCtl = [contextDictionary objectForKey:@"ToViewController"];
    
    [self finishAnimateViewTransitionFromViewController:fromViewCtl toViewController:toViewCtl];
    
    [transitionContexts removeObject:contextDictionary];
}

#pragma mark -
#pragma mark Custom Accessor Methods

- (void)prepareViewToBecomeMainView:(UIView *)view
{
    [view setFrame:CGRectMake(0, 0, [contentView frame].size.width, [contentView frame].size.height)];
    [view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
}

- (void)setMainView:(UIView *)newMainView
{
    // Setting the mainView simply adds the "mainView" as a subview to the contentView
    // That way we can animate the segmented view swapping by animating the contentView
    
    // Resize main view to fix content view
    [self prepareViewToBecomeMainView:newMainView];
    
    // Either set the subview if there isn't one already, or remove the subview and add the subview
    if ([[contentView subviews] count] == 0)
        [contentView addSubview:newMainView];
    else {
        [[[contentView subviews] objectAtIndex:0] removeFromSuperview];
        [contentView addSubview:newMainView];
    }
}

@end
