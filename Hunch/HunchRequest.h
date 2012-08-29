//
//  HunchParser.h
//  Hunch
//
//  Created by Amy Dyer on 8/29/12.
//  Copyright (c) 2012 Amy Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKGeometry.h>

@interface HunchRequest : NSObject

+ (void) requestMatchesForUser:(NSString *)twitterName location:(MKCoordinateRegion)region onCompletion:(void (^)(NSArray * results))handler;

@end
