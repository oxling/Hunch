//
//  ViewController.m
//  Hunch
//
//  Created by Amy Dyer on 8/29/12.
//  Copyright (c) 2012 Amy Dyer. All rights reserved.
//

#import "ViewController.h"
#import "HunchRequest.h"
#import "HunchResult.h"
#import "DetailViewController.h"

@interface ViewController () {
    NSArray * _results;
    NSOperationQueue * _imageQueue;
    CLLocationManager * _locationManager;
}

@property (nonatomic, retain) NSArray * results;

@end

@implementation ViewController
@synthesize map=_map, results = _results;

- (void) dealloc {
    [_map release];
    [_imageQueue release];
    [_locationManager release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.map = nil;
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - MapView

- (void) search:(id)sender {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //Right now this only requests things that it thinks *I'll* like
    //Todo: Use the twitter API to pull out the user's current twitter account
    
    [HunchRequest requestMatchesForUser:@"amyinspace" location:_map.region onCompletion:^(id results) {
        for (HunchResult * result in _results) {
            [_map removeAnnotation:result];
        }
        
        for (HunchResult * result in results) {
            [_map addAnnotation:result];
        }
            
        self.results = results;
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView * v = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"hunch_annotation"];
    if (!v) {
        v = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"hunch_annotation"] autorelease];
    }
    
    v.annotation = annotation;
    v.enabled = YES;
    v.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    v.canShowCallout = YES;
    
    return v;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    DetailViewController * dvc = [[DetailViewController alloc] initWithResult:(HunchResult *)view.annotation];
    UINavigationController * nvc = [[UINavigationController alloc] initWithRootViewController:dvc];
    
    dvc.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:dvc action:@selector(close:)] autorelease];
    
    [self presentModalViewController:nvc animated:YES];
    [dvc release];
    [nvc release];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [manager stopUpdatingLocation];
    
    if (!_results) {
        [_map setRegion:MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 300, 300)];
        [self search:nil];
    }
}


@end
