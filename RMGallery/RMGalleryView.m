//
//  RMGalleryView.m
//  RMGallery
//
//  Created by Hermés Piqué on 20/03/14.
//  Copyright (c) 2014 Robot Media. All rights reserved.
//

#import "RMGalleryView.h"
#import "RMGalleryCell.h"

@interface RMGalleryViewLayout : UICollectionViewFlowLayout

- (NSUInteger)indexForOffset:(CGPoint)offset;

- (CGPoint)offsetForIndex:(NSUInteger)index;

@end

@interface RMGalleryView()<UIGestureRecognizerDelegate>

@end

@implementation RMGalleryView {
    NSUInteger _willBeingDraggingIndex;
    RMGalleryViewLayout *_imageFlowLayout;
}

- (id)initWithFrame:(CGRect)frame
{
    _imageFlowLayout = [RMGalleryViewLayout new];
    _imageFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self = [super initWithFrame:frame collectionViewLayout:_imageFlowLayout];
    if (self)
    {
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:RMGalleryCell.class forCellWithReuseIdentifier:@"Cell"];
        
        UISwipeGestureRecognizer *swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftGesture:)];
        swipeLeftGestureRecognizer.delegate = self;
        swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeLeftGestureRecognizer];

        UISwipeGestureRecognizer *swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightGesture:)];
        swipeRightGestureRecognizer.delegate = self;
        swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeRightGestureRecognizer];
    }
    return self;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.galleryDataSource numberOfImagesInImageCollectionView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RMGalleryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    UIImage *image = [self.galleryDataSource imageCollectionView:self imageForIndex:indexPath.row];
    cell.image = image;
    return cell;
}

#pragma mark Swipes

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (otherGestureRecognizer.view == self) return NO;
    
    return YES;
}

- (void)swipeLeftGesture:(UIGestureRecognizer*)gestureRecognizer
{
    const NSUInteger index = [_imageFlowLayout indexForOffset:self.contentOffset];
    const NSUInteger count = [self.galleryDataSource numberOfImagesInImageCollectionView:self];
    const NSUInteger nextIndex = index + 1;
    if (nextIndex < count)
    {
        CGPoint offset = [_imageFlowLayout offsetForIndex:nextIndex];
        [self setContentOffset:offset animated:YES];
    }
}

- (void)swipeRightGesture:(UIGestureRecognizer*)gestureRecognizer
{
    const NSUInteger index = [_imageFlowLayout indexForOffset:self.contentOffset];
    const NSInteger previousIndex = index - 1;
    if (previousIndex >= 0)
    {
        CGPoint offset = [_imageFlowLayout offsetForIndex:previousIndex];
        [self setContentOffset:offset animated:YES];
    }
}

#pragma mark Paging

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _willBeingDraggingIndex = [_imageFlowLayout indexForOffset:self.contentOffset];
}

-(void)scrollViewWillEndDragging:(UIScrollView*)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint*)targetContentOffset
{
    NSInteger targetIndex;
    if (velocity.x == 0)
    {
        targetIndex = [_imageFlowLayout indexForOffset:*targetContentOffset];
        if (targetIndex != _willBeingDraggingIndex)
        {
            targetIndex = targetIndex > _willBeingDraggingIndex ? _willBeingDraggingIndex + 1 : _willBeingDraggingIndex - 1;
        }
    }
    else
    {
        targetIndex = velocity.x > 0 ? _willBeingDraggingIndex + 1 : _willBeingDraggingIndex - 1;
    }
    targetIndex = MAX(0, targetIndex);
    const NSUInteger maxIndex = [self.galleryDataSource numberOfImagesInImageCollectionView:self] - 1;
    targetIndex = MIN(targetIndex, maxIndex);
    *targetContentOffset = [_imageFlowLayout offsetForIndex:targetIndex];
}

@end

@implementation RMGalleryViewLayout

#pragma mark UICollectionViewFlowLayout

- (CGSize)itemSize
{
    CGRect bounds = self.collectionView.bounds;
    return bounds.size;
}

#pragma mark UICollectionViewLayout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset NS_AVAILABLE_IOS(7_0);
{
    NSUInteger targetIndex = [self indexForOffset:proposedContentOffset];

    RMGalleryView *collectionView = (RMGalleryView*)self.collectionView;
    const NSUInteger maxIndex = [collectionView.galleryDataSource numberOfImagesInImageCollectionView:collectionView] - 1;
    targetIndex = MIN(targetIndex, maxIndex);
    
    CGPoint targetContentOffset = [self offsetForIndex:targetIndex];

    return targetContentOffset;
}

#pragma mark Public

- (NSUInteger)indexForOffset:(CGPoint)offset
{
    const CGFloat offsetX = offset.x;
    const CGFloat width = self.itemSize.width;
    const CGFloat spacing = self.minimumInteritemSpacing;
    NSInteger index = round(offsetX / (width + spacing));
    index = MAX(0, index);
    return index;
}

- (CGPoint)offsetForIndex:(NSUInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    const CGPoint offset = attributes.frame.origin;
    return offset;
}

@end
