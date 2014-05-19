//
//  RMDemoGalleryViewController.m
//  RMGallery
//
//  Created by Hermés Piqué on 21/03/14.
//  Copyright (c) 2014 Robot Media. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "RMDemoGalleryViewController.h"
#import "UIImage+RMGalleryDemo.h"

// RMGalleryViewController is designed to be subclased. In this example the subclass acts as the gallery data source,  takes care of displaying a dynamic title in the navigation bar and provides and action bar button system item.
@interface RMDemoGalleryViewController()<RMGalleryViewDataSource, RMGalleryViewDelegate>

@end

@implementation RMDemoGalleryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the gallery data source and delegate. Only the data source is required.
    self.galleryView.galleryDataSource = self;
    self.galleryView.galleryDelegate = self;
    
    // Configure the toolbar to show an action bar button item. RMGalleryViewController does not provide any bar buttons but is designed to support a navigation bar and a toolbar.
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(barButtonAction:)];
    self.toolbarItems = @[barButton];

    // Set the view controller title. Note that the gallery index does not necessarilly have to be zero at this point.
    [self setTitleForIndex:self.galleryIndex];
}

#pragma mark RMGalleryViewDataSource

- (void)galleryView:(RMGalleryView*)galleryView imageForIndex:(NSUInteger)index completion:(void (^)(UIImage *))completionBlock
{
    // Typically images will be loaded asynchonously. To simulate this we resize the image in background.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSString *name = [NSString stringWithFormat:@"photo%ld.jpg", (long)index + 1];
        UIImage *image = [UIImage imageNamed:name];
        image = [image demo_imageByScalingByFactor:0.75];

        dispatch_sync(dispatch_get_main_queue(), ^{
            completionBlock(image);
        });
    });
}

- (NSUInteger)numberOfImagesInGalleryView:(RMGalleryView*)galleryView
{
    return 3;
}

#pragma mark RMGalleryViewDelegate

- (void)galleryView:(RMGalleryView*)galleryView didChangeIndex:(NSUInteger)index
{
    [self setTitleForIndex:index];
}

#pragma mark Toolbar

- (void)barButtonAction:(UIBarButtonItem*)barButtonItem
{
    RMGalleryView *galleryView = self.galleryView;
    const NSUInteger index = galleryView.galleryIndex;
    RMGalleryCell *galleryCell = [galleryView galleryCellAtIndex:index];
    UIImage *image = galleryCell.image;
    if (!image) return;
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark Utils

- (void)setTitleForIndex:(NSUInteger)index
{
    const NSUInteger count = [self numberOfImagesInGalleryView:self.galleryView];
    self.title = [NSString stringWithFormat:@"%ld of %ld", (long)index + 1, (long)count];
}

@end
