//
//  RMGalleryView.h
//  RMGallery
//
//  Created by Hermés Piqué on 20/03/14.
//  Copyright (c) 2014 Robot Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RMGalleryViewDataSource;

@interface RMGalleryView : UICollectionView<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id<RMGalleryViewDataSource> galleryDataSource;

@end

@protocol RMGalleryViewDataSource

- (UIImage*)imageCollectionView:(RMGalleryView*)imageCollectionView imageForIndex:(NSUInteger)index;

- (NSUInteger)numberOfImagesInImageCollectionView:(RMGalleryView*)image;

@end
