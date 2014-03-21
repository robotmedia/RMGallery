//
//  RMDemoViewController.m
//  RMGallery
//
//  Created by Hermés Piqué on 21/03/14.
//  Copyright (c) 2014 Robot Media. All rights reserved.
//

#import "RMDemoViewController.h"

@interface RMDemoViewController()<RMGalleryViewDataSource>

@end

@implementation RMDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.galleryView.galleryDataSource = self;
}

#pragma mark RMGalleryViewDataSource

- (UIImage*)imageCollectionView:(RMGalleryView*)imageCollectionView imageForIndex:(NSUInteger)index
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"photo%d.jpg", index + 1]];
    return image;
}

- (NSUInteger)numberOfImagesInImageCollectionView:(RMGalleryView*)image
{
    return 3;
}


@end
