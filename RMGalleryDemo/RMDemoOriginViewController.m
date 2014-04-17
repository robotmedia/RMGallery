//
//  RMDemoOriginViewController.m
//  RMGallery
//
//  Created by Hermés Piqué on 16/04/14.
//  Copyright (c) 2014 Robot Media. All rights reserved.
//

#import "RMDemoOriginViewController.h"
#import "RMDemoGalleryViewController.h"
#import "RMGalleryTransition.h"

@interface RMDemoOriginViewController()<UIViewControllerTransitioningDelegate, RMGalleryTransitionDelegate>

@property(retain) IBOutletCollection(UIImageView) NSArray *imageViews;

@end

@implementation RMDemoOriginViewController

- (void)showGalleryAtIndex:(NSUInteger)index
{
    RMDemoGalleryViewController *galleryViewController = [RMDemoGalleryViewController new];
    galleryViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissGallery:)];
    galleryViewController.galleryIndex = index;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:galleryViewController];
    navigationController.toolbarHidden = NO;
    navigationController.transitioningDelegate = self;
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark Actions

- (void)dismissGallery:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)thumbnail1TapGestureRecognized:(UIGestureRecognizer*)gestureRecognizer
{
    [self showGalleryAtIndex:0];
}

- (IBAction)thumbnail2TapGestureRecognized:(UIGestureRecognizer*)gestureRecognizer
{
    [self showGalleryAtIndex:1];
}

- (IBAction)thumbnai3TapGestureRecognized:(UIGestureRecognizer*)gestureRecognizer
{
    [self showGalleryAtIndex:2];
}

#pragma mark UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    RMGalleryTransition *transition = [RMGalleryTransition new];
    transition.delegate = self;
    return transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    RMGalleryTransition *transition = [RMGalleryTransition new];
    transition.delegate = self;
    return transition;
}

#pragma mark RMGalleryTransitionDelegate

- (UIImageView*)galleryTransition:(RMGalleryTransition*)transition transitionImageViewForIndex:(NSUInteger)index
{
    return self.imageViews[index];
}

- (CGSize)galleryTransition:(RMGalleryTransition*)transition estimatedSizeForIndex:(NSUInteger)index
{ // If the transition image is different than the one displayed in the gallery we need to provide its size
    UIImageView *imageView = self.imageViews[index];
    const CGSize thumbnailSize = imageView.image.size;
    const CGSize estimatedSize = CGSizeMake(thumbnailSize.width * 34.04, thumbnailSize.height * 34.04);
    return estimatedSize;
}

@end
