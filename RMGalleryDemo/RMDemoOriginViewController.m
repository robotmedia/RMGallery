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

#define RM_NAVIGATION_CONTROLLER 1

@interface RMDemoOriginViewController()<UIViewControllerTransitioningDelegate, RMGalleryTransitionDelegate>

@property(retain) IBOutletCollection(UIImageView) NSArray *imageViews;

@end

@implementation RMDemoOriginViewController

- (void)presentGalleryWithImageAtIndex:(NSUInteger)index
{
    RMDemoGalleryViewController *galleryViewController = [RMDemoGalleryViewController new];
    galleryViewController.galleryIndex = index;
    
// The gallery is designed to be presented in a navigation controller or on its own.
    UIViewController *viewControllerToPresent;
#if RM_NAVIGATION_CONTROLLER
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:galleryViewController];
    navigationController.toolbarHidden = NO;
    
    // When using a navigation controller the tap gesture toggles the navigation bar and toolbar. A way to dismiss the gallery must be provided.
    galleryViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissGallery:)];
    
    viewControllerToPresent = navigationController;
#else
    viewControllerToPresent = galleryViewController;
#endif
    
    // Set the transitioning delegate. This is only necessary if you want to use RMGalleryTransition.
    viewControllerToPresent.transitioningDelegate = self;
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:viewControllerToPresent animated:YES completion:nil];
}

#pragma mark Actions

- (void)dismissGallery:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)thumbnailTapGestureRecognized:(UIGestureRecognizer*)gestureRecognizer
{
    UIView *imageView = gestureRecognizer.view;
    NSUInteger index = [self.imageViews indexOfObject:imageView];
    [self presentGalleryWithImageAtIndex:index];
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
    
    // In this example the final images are about 25 times bigger than the thumbnail
    const CGSize estimatedSize = CGSizeMake(thumbnailSize.width * 25, thumbnailSize.height * 25);
    return estimatedSize;
}

@end
