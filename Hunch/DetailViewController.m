//
//  DetailViewController.m
//  Hunch
//
//  Created by Amy Dyer on 8/29/12.
//  Copyright (c) 2012 Amy Dyer. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () {
}
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) HunchResult * result;

@end

@implementation DetailViewController
@synthesize imageView = _imageView;
@synthesize result=_result;

- (id) initWithResult:(HunchResult *)result {
    self = [super init];
    if (self) {
        self.result = result;
    }
    return self;
}

- (void) dealloc {
    [_result release];
    [_imageView release];
    [super dealloc];
}

- (void) viewDidLoad {
    self.title = _result.title;
    [self loadImage];
}

- (void) loadImage {
    if (!_result.imageURL) {
        UILabel * l = [[UILabel alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:l];
        l.text = @"No image :(";
        [l release];
    } else {
    
        NSURL * url = [NSURL URLWithString:_result.imageURL];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error ) {
            if (error) {
                return;
            }
            
            UIImage * image = [UIImage imageWithData:data];
            _imageView.image = image;
        }];
    }
}

- (void)close:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidUnload {
    [self setImageView:nil];
    [super viewDidUnload];
}
@end
