//
//  CSRouteView.h
//  testMapp
//
//  Created by Craig on 8/18/09.
//  Copyright Craig Spitzkoff 2009. All rights reserved.
//
// Adapted from code at:
// http://spitzkoff.com/craig/?p=108

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class CSRouteViewInternal;

// annotation view that is created for display of a route. 
@interface CSRouteView : MKAnnotationView 
{
	MKMapView* _mapView;
	
	CSRouteViewInternal* _internalRouteView;
}

// signal from our view controller that the map region changed. We will need to resize, recenter and 
// redraw the contents of this view when this happens. 
-(void) regionChanged;


@property (nonatomic, assign) MKMapView* mapView;


@end
