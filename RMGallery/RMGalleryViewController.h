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

/**
 A view controller class that manages a gallery view.
 @see RMGalleryView
 */
@interface RMGalleryViewController : UIViewController<UIGestureRecognizerDelegate>

/**
 The object that acts as a delegate for the gallery view controller.
 @discussion Not to be confused with the gallery view delegate.
 @see RMGalleryViewDelegate
 */
@property (nonatomic, weak) id<RMGalleryViewControllerDelegate> delegate;

/**
 The gallery view managed by the gallery view controller.
 */
@property (nonatomic, readonly) RMGalleryView *galleryView;

/**
 The gallery index.
 @discussion Typically, this will be used to set the initial gallery index and then to query the current index when needed.
 @discussion The gallery view delegate notifies index changes.
 */
@property (nonatomic, assign) NSUInteger galleryIndex;

/**
 The tap gesture recognizer. Toggles bars when the gallery view controller is inside a navigation view controller or dismisses the view controller when presented modally (without a navigation bar).
 @discussion Disable this gesture recognizer to disable the default tap behavior.
 */
@property (nonatomic, readonly) UITapGestureRecognizer *tapGestureRecognizer;

/**
 The navigation controller toolbar or a custom toolbar if there is no navigation controller.
 **/
@property (nonatomic, readonly) UIToolbar *toolbar;

/**
 Hides or shows the bars (status, navigation and toolbar), optionally animating the transition.
 @param hidden @c YES to hide bars, @c NO to show them.
 @param animated @c YES to animate the transition, @c NO
 @discussion Override @c animatingBarsHidden: to animate custom views (i.e., a caption view) that must be toggled with the bars.
 */
- (void)setBarsHidden:(BOOL)hidden animated:(BOOL)animated;

#pragma mark UIViewController overrides

- (void)viewDidLoad NS_REQUIRES_SUPER;

- (void)viewWillAppear:(BOOL)animated NS_REQUIRES_SUPER;

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration NS_REQUIRES_SUPER;

- (void)viewWillDisappear:(BOOL)animated NS_REQUIRES_SUPER;

@end

@interface RMGalleryViewController(Sublassing)

/**
 Called within the animation block that toggles bars. You must not call this method directly.
 @param hidden @c YES if the bars are being hidden, @c NO if the bars are being shown.
 @discussion Override to animate custom views (i.e., a caption view) that must be toggled with the bars.
 */
- (void)animatingBarsHidden:(BOOL)hidden;

@end

/**
  The methods of this protocol notify your delegate when the gallery view is dismissed.
 */
@protocol RMGalleryViewControllerDelegate <NSObject>

@optional

/**
 Notifies the delegate that the gallery view controller will be dismissed. This happens when the user taps on a gallery view controller without a navigation bar.
 @param galleryViewController The gallery view controller.
 @param animated  @c YES if the gallery view controller will be dismissed with an animation, @c NO otherwise.
 */
- (void)galleryViewController:(RMGalleryViewController*)galleryViewController willDismissViewControllerAnimated:(BOOL)animated;

/**
 Notifies the delegate that the gallery view controller was dismissed. This happens when the user taps on a gallery view controller without a navigation bar.
 @param galleryViewController The gallery view controller.
 @param animated  @c YES if the gallery view controller was dismissed with an animation, @c NO otherwise.
 */
- (void)galleryViewController:(RMGalleryViewController*)galleryViewController didDismissViewControllerAnimated:(BOOL)animated;

@end
