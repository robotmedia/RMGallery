//
//  RMGalleryView.h
//  RMGallery
//
//  Created by Hermés Piqué on 20/03/14.
//  Copyright (c) 2014 Robot Media. All rights reserved.
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
