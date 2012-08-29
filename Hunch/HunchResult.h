//
//  HunchResult.h
//  Hunch
//
//  Created by Amy Dyer on 8/29/12.
//  Copyright (c) 2012 Amy Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface HunchResult : NSObject <MKAnnotation>

- (id) initWithIdentifier:(id)identifier;
- (id) initWithIdentifier:(id)identifier title:(NSString *)title imageURL:(NSString *)imageURL;

@property (nonatomic, readonly) NSString * title;
@property (nonatomic, readonly) NSString * imageURL;
@property (nonatomic, readonly) UIImage * image;
@property (nonatomic, readonly) NSString * identifier;
@property (nonatomic, retain) NSString * description;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (void) loadImage;

@end
