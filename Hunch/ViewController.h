//
//  ViewController.h
//  Hunch
//
//  Created by Amy Dyer on 8/29/12.
//  Copyright (c) 2012 Amy Dyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, retain) IBOutlet MKMapView * map;
- (IBAction)search:(id)sender;

@end
