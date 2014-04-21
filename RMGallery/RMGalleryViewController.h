//
//  RMGalleryViewController.h
//  RMGallery
//
//  Created by Hermés Piqué on 20/03/14.
//  Copyright (c) 2014 Robot Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMGalleryView.h"

@protocol RMGalleryViewControllerDelegate;

@interface RMGalleryViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<RMGalleryViewControllerDelegate> delegate;

@property (nonatomic, readonly) RMGalleryView *galleryView;

@property (nonatomic, assign) NSUInteger galleryIndex;

@property (nonatomic, readonly) UITapGestureRecognizer *tapGestureRecognizer;

/**
 The navigation controller toolbar or a custom toolbar if there is no navigation controller.
 **/
@property (nonatomic, readonly) UIToolbar *toolbar;

- (void)setBarsHidden:(BOOL)hidden animated:(BOOL)animated;

#pragma mark UIViewController overrides

- (void)viewDidLoad NS_REQUIRES_SUPER;

- (void)viewWillAppear:(BOOL)animated NS_REQUIRES_SUPER;

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration NS_REQUIRES_SUPER;

- (void)viewWillDisappear:(BOOL)animated NS_REQUIRES_SUPER;

@end

@interface RMGalleryViewController(Sublassing)

- (void)animatingBarsHidden:(BOOL)hidden;

@end

@protocol RMGalleryViewControllerDelegate <NSObject>

@optional

- (void)galleryViewController:(RMGalleryViewController*)galleryViewController willDismissViewControllerAnimated:(BOOL)animated;

- (void)galleryViewController:(RMGalleryViewController*)galleryViewController didDismissViewControllerAnimated:(BOOL)animated;

@end
