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

@end

@implementation RMDemoOriginViewController {
    UIImageView *_selectedImageView;
}

- (void)showGalleryAtIndex:(NSUInteger)index fromImageView:(UIImageView*)imageView
{
    _selectedImageView = imageView;
    RMDemoGalleryViewController *galleryViewController = [RMDemoGalleryViewController new];
    galleryViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissGallery:)];
    galleryViewController.galleryIndex = index;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:galleryViewController];
    navigationController.toolbarHidden = NO;
    navigationController.transitioningDelegate = self;
    navigationController.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark Actions

- (void)dismissGallery:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)thumbnail1TapGestureRecognized:(UIGestureRecognizer*)gestureRecognizer
{
    [self showGalleryAtIndex:0 fromImageView:(UIImageView*)gestureRecognizer.view];
}

- (IBAction)thumbnail2TapGestureRecognized:(UIGestureRecognizer*)gestureRecognizer
{
    [self showGalleryAtIndex:1 fromImageView:(UIImageView*)gestureRecognizer.view];
}

- (IBAction)thumbnai3TapGestureRecognized:(UIGestureRecognizer*)gestureRecognizer
{
    [self showGalleryAtIndex:2 fromImageView:(UIImageView*)gestureRecognizer.view];
}

#pragma mark UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    RMGalleryTransition *transition = [[RMGalleryTransition alloc] initWithImageView:_selectedImageView];
    transition.delegate = self; // To provide the image size
    return transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[RMGalleryTransition alloc] initWithImageView:_selectedImageView];
}

#pragma mark RMGalleryTransitionDelegate

- (CGSize)galleryTransition:(RMGalleryTransition*)transition sizeForIndex:(NSUInteger)index
{ // If the transition image is different than the one displayed in the gallery we need to provide its size
    return CGSizeMake(3404, 2452);
}

@end
