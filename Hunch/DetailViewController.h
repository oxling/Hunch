//
//  DetailViewController.h
//  Hunch
//
//  Created by Amy Dyer on 8/29/12.
//  Copyright (c) 2012 Amy Dyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HunchResult.h"

@interface DetailViewController : UIViewController

- (id) initWithResult:(HunchResult *)result;

- (IBAction)close:(id)sender;

@end
