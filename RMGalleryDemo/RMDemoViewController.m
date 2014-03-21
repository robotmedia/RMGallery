//
//  RMDemoViewController.m
//  RMGallery
//
//  Created by Hermés Piqué on 21/03/14.
//  Copyright (c) 2014 Robot Media. All rights reserved.
//

#import "RMDemoViewController.h"
#import "UIImage+RMGalleryDemo.h"

@interface RMDemoViewController()<RMGalleryViewDataSource>

@end

@implementation RMDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.galleryView.galleryDataSource = self;
}

#pragma mark RMGalleryViewDataSource

- (void)galleryView:(RMGalleryView*)galleryView imageForIndex:(NSUInteger)index completion:(void (^)(UIImage *))completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSString *name = [NSString stringWithFormat:@"photo%d.jpg", index + 1];
        UIImage *image = [UIImage imageNamed:name];
        image = [image demo_imageByScalingByFactor:0.75];

        dispatch_sync(dispatch_get_main_queue(), ^{
            completionBlock(image);
        });
    });
}

- (NSUInteger)numberOfImagesInGalleryView:(RMGalleryView*)image
{
    return 3;
}


@end
