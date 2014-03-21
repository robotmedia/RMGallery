//
//  RMDemoViewController.m
//  RMGallery
//
//  Created by Hermés Piqué on 21/03/14.
//  Copyright (c) 2014 Robot Media. All rights reserved.
//

#import "RMDemoViewController.h"
#import "UIImage+RMGalleryDemo.h"
#import "RMGalleryCell.h"

@interface RMDemoViewController()<RMGalleryViewDataSource>

@end

@implementation RMDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.galleryView.galleryDataSource = self;
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(barButtonAction:)];
    self.toolbarItems = @[barButton];
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

#pragma mark Bar buttons

- (void)barButtonAction:(UIBarButtonItem*)barButtonItem
{
    NSArray *cells = [self.galleryView visibleCells];
    RMGalleryCell *galleryCell = [cells firstObject];
    UIImage *image = galleryCell.image;
    if (!image) return;
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

@end
