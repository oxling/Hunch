//
//  HunchParser.m
//  Hunch
//
//  Created by Amy Dyer on 8/29/12.
//  Copyright (c) 2012 Amy Dyer. All rights reserved.
//

#import "HunchRequest.h"
#import "HunchResult.h"

@interface HunchRequest ()
+ (void) updateDataForResults:(NSArray *)results onCompletion:(void(^)(NSArray *))handler;
@end

@implementation HunchRequest

+ (NSString *) formatRequest:(NSString *)name location:(MKCoordinateRegion)r{
    NSString * fmtString = @"http://api.hunch.com/api/v1/get-recommendations/?limit=20&minlat=%f&maxlat=%f&minlng=%f&maxlng=%f&minimal=1&user_id=tw_%@&topic_ids=list_restaurant";
    CLLocationDegrees minlat = r.center.latitude - r.span.latitudeDelta/2;
    CLLocationDegrees maxlat = r.center.latitude + r.span.latitudeDelta/2;
    CLLocationDegrees minlng = r.center.longitude - r.span.longitudeDelta/2;
    CLLocationDegrees maxlng = r.center.longitude + r.span.longitudeDelta/2;
    
    return [NSString stringWithFormat:fmtString, minlat, maxlat, minlng, maxlng, name];
}

+ (void) requestMatchesForUser:(NSString *)twitterName location:(MKCoordinateRegion)coordinate onCompletion:(void (^)(NSArray *))handler {
    NSURL * url = [NSURL URLWithString:[HunchRequest formatRequest:twitterName location:coordinate]];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        
        if (error) {
            NSLog(@"Error while handling request: %@", [error localizedDescription]);
            return;
        }
        
        NSError * jsonError = nil;
        id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:(NSError **)jsonError];

        if (jsonError) {
            NSLog(@"Error parsing json: %@", [jsonError localizedDescription]);
        }
        
        NSMutableArray * results = [NSMutableArray array];
        NSArray * jsonResults = [object objectForKey:@"recommendations"];
        for (NSDictionary * d in jsonResults) {
            NSString * identifier = [d objectForKey:@"result_id"];
            [results addObject:identifier];
        }
        
        //Spins off another asynchronous request to pull down detailed information
        [self updateDataForResults:results onCompletion:handler];
        
    }];
}

+ (void) updateDataForResults:(NSArray *)resultIdentifiers onCompletion:(void(^)(NSArray *))handler {
    if ([resultIdentifiers count] == 0) return;
    
    NSString * fmtString = @"http://api.hunch.com/api/v1/get-recommendations/?result_ids=%@";
    NSMutableString * resultString = [NSMutableString string];
    for (NSString * result in resultIdentifiers) {
        [resultString appendFormat:@"%@,", result];
    }
    [resultString deleteCharactersInRange:NSMakeRange([resultString length]-1, 1)];
    
    NSURL * url = [NSURL URLWithString: [NSString stringWithFormat:fmtString, resultString]];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        
        if (error) {
            NSLog(@"Error while updating results: %@", [error localizedDescription]);
            return;
        }
        
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSMutableArray * results = [NSMutableArray array];
        NSArray * jsonResults = [json objectForKey:@"recommendations"];
        
        for (NSDictionary * d in jsonResults) {
            NSString * identifier = [d objectForKey:@"result_id"];
            NSString * title = [d objectForKey:@"title"];
            NSString * imageURL = [d objectForKey:@"image_url"];
            NSNumber * lat = [d objectForKey:@"lat"];
            NSNumber * lng = [d objectForKey:@"lng"];
            NSString * desc = [d objectForKey:@"address"];
            
            
            HunchResult * result = [[HunchResult alloc] initWithIdentifier:identifier title:title imageURL:imageURL];
            [result setCoordinate:CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue])];
            result.description = desc;
            [results addObject:result];
            [result release];
        }
        
        NSArray * array = [NSArray arrayWithArray:results];
        handler(array);
    }];
    
}

@end
