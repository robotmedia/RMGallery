//
//  RMGalleryViewController.h
//  RMGallery
//
//  Created by Hermés Piqué on 20/03/14.
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
