//
//  RMGalleryView.h
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
#import "RMGalleryCell.h"

@protocol RMGalleryViewDataSource;

@protocol RMGalleryViewDelegate;

/**
 A collection view of gallery cells.
 @see RMGalleryCell
 */
@interface RMGalleryView : UICollectionView<UICollectionViewDataSource>

/**
 The object that provides images to the gallery view.
 */
@property (nonatomic, weak) id<RMGalleryViewDataSource> galleryDataSource;

/**
 The object that acts as a delegate for the gallery view.
 */
@property (nonatomic, weak) id<RMGalleryViewDelegate> galleryDelegate;

#pragma mark Gestures

/**
 The swipe left gesture recognizer. Shows the next image, if any.
 @discussion Disable this gesture recognizer to disable the default swipe left behavior.
 @see showNext
 */
@property (nonatomic, readonly) UISwipeGestureRecognizer *swipeLeftGestureRecognizer;

/**
 The swipe right gesture recognizer. Shows the previous image, if any.
 @discussion Disable this gesture recognizer to disable the default swipe right behavior.
 @see showPrevious
 */
@property (nonatomic, readonly) UISwipeGestureRecognizer *swipeRightGestureRecognizer;

/**
 The double tap gesture recognizer. Toggles zoom on the touch point.
 @discussion Disable this gesture recognizer to disable the default double tap behavior.
 @see toggleZoomAtPoint:
 */
@property (nonatomic, readonly) UITapGestureRecognizer *doubleTapGestureRecognizer;

#pragma mark Managing State

/**
 The gallery index. 
 @discussion Typically, this will be used to set the initial gallery index and then to query the current index when needed.
 @discussion The gallery view delegate notifies index changes.
 @see RMGalleryDelegate
 */
@property (nonatomic, assign) NSUInteger galleryIndex;

/**
 Set the gallery index, optionally animating the transition.
 @param galleryIndex The index to be set.
 @param animated @c YES to animate the index change, @c NO otherwise.
 */
- (void)setGalleryIndex:(NSUInteger)galleryIndex animated:(BOOL)animated;

#pragma mark Locating Cells

/**
 Returns the gallery cell at the given index.
 @param index The gallery cell index.
 @return The gallery cell at the corresponding index.
 */
- (RMGalleryCell*)galleryCellAtIndex:(NSUInteger)index;

#pragma mark Actions

/**
 Shows the next image, if applicable.
 */
- (void)showNext;

/**
 Shows the previous image, if applicable.
 */
- (void)showPrevious;

/**
 Toggles zoom from the given point.
 @param point The point in which to toggle zoom.
 */
- (void)toggleZoomAtPoint:(CGPoint)point;

@end

/**
 Provides images to the gallery view.
 */
@protocol RMGalleryViewDataSource<NSObject>

/**
 Asks the data source for image that corresponds to the given index in the gallery view.
 @param galleryView The collection view requesting this information.
 @param index The gallery index whose image is required.
 @param completionBlock The block to be called when the image is ready. This allows to load the image asynchronously.
 */
- (void)galleryView:(RMGalleryView*)galleryView imageForIndex:(NSUInteger)index completion:(void (^)(UIImage *image))completionBlock;

/**
 Asks the data source for the number images (required).
 @param galleryView The collection view requesting this information.
 @return The number of images.
 */
- (NSUInteger)numberOfImagesInGalleryView:(RMGalleryView*)galleryView;

@end

/**
 The methods of this protocol notify your delegate when the gallery view changes index.
 */
@protocol RMGalleryViewDelegate<NSObject>

@optional

/**
 Notifies the delegate that the gallery view changed to the given index.
 @param galleryView The gallery view.
 @param index The index to which the gallery view changed.
 */
- (void)galleryView:(RMGalleryView*)galleryView didChangeIndex:(NSUInteger)index;

@end
