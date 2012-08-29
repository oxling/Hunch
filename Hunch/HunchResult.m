//
//  HunchResult.m
//  Hunch
//
//  Created by Amy Dyer on 8/29/12.
//  Copyright (c) 2012 Amy Dyer. All rights reserved.
//

#import "HunchResult.h"

@implementation HunchResult
@synthesize title=_title, imageURL=_imageURL, image=_image, identifier=_identifier, coordinate=_coordinate;
@synthesize description=_description;

- (id) initWithIdentifier:(id)identifier {
    self = [super init];
    if (self) {
        NSAssert(identifier != nil, @"Must have a valid Hunch identifier");
        _identifier = [identifier retain];
    }
    return self;
}

- (id) initWithIdentifier:(id)identifier title:(NSString *)title imageURL:(NSString *)imageURL {
    self = [self initWithIdentifier:identifier];
    if (self) {
        _title = [title retain];
        _imageURL = [imageURL retain];
    }
    return self;
}

- (void) dealloc {
    [_title release];
    [_imageURL release];
    [_image release];
    [_identifier release];
    [_description release];
    
    [super dealloc];
}

- (BOOL) isEqual:(id)object {
    if ([object class] != [self class]) return NO;
    
    return ([self.identifier isEqual:[(HunchResult *)object identifier]]);
}

- (void) loadImage {
}

- (NSString *) subtitle {
    return _description;
}

@end
