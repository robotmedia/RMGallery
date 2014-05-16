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

@interface RMGalleryView : UICollectionView<UICollectionViewDataSource>

@property (nonatomic, weak) id<RMGalleryViewDataSource> galleryDataSource;

@property (nonatomic, weak) id<RMGalleryViewDelegate> galleryDelegate;

@property (nonatomic, readonly) UISwipeGestureRecognizer *swipeLeftGestureRecognizer;

@property (nonatomic, readonly) UISwipeGestureRecognizer *swipeRightGestureRecognizer;

@property (nonatomic, readonly) UITapGestureRecognizer *doubleTapGestureRecognizer;

#pragma mark Managing state

@property (nonatomic, assign) NSUInteger galleryIndex;

- (void)setGalleryIndex:(NSUInteger)galleryIndex animated:(BOOL)animated;

#pragma mark Locating cells

- (RMGalleryCell*)galleryCellAtIndex:(NSUInteger)index;

#pragma mark Actions

- (void)showNext;

- (void)showPrevious;

- (void)toggleZoomAtPoint:(CGPoint)point;

@end

@protocol RMGalleryViewDataSource<NSObject>

- (void)galleryView:(RMGalleryView*)galleryView imageForIndex:(NSUInteger)index completion:(void (^)(UIImage *image))completionBlock;

- (NSUInteger)numberOfImagesInGalleryView:(RMGalleryView*)image;

@end

@protocol RMGalleryViewDelegate<NSObject>

@optional

- (void)galleryView:(RMGalleryView*)galleryView didChangeIndex:(NSUInteger)index;

@end
