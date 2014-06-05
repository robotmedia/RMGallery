//
//  RMGalleryView.m
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

#import "RMGalleryView.h"

static NSString *const CellIdentifier = @"Cell";

@interface RMGalleryViewLayout : UICollectionViewFlowLayout

- (NSUInteger)indexForOffset:(CGPoint)offset;

- (CGPoint)offsetForIndex:(NSUInteger)index;

@end

@interface RMGalleryViewSwipeGRDelegate : NSObject<UIGestureRecognizerDelegate>

- (id)initWithGalleryView:(__weak RMGalleryView*)galleryView;

@end

@interface RMGalleryView()<UICollectionViewDelegate>

@end

@implementation RMGalleryView
{
    NSUInteger _willBeginDraggingIndex;
    RMGalleryViewLayout *_imageFlowLayout;
    RMGalleryViewSwipeGRDelegate *_swipeDelegate;
    __weak id<UICollectionViewDelegate> _realDelegate;
    NSUInteger _galleryIndex;
}

@synthesize galleryIndex = _galleryIndex;

- (id)init
{
    _imageFlowLayout = [RMGalleryViewLayout new];
    _imageFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return [self initWithFrame:CGRectZero collectionViewLayout:_imageFlowLayout];
}

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
    {
        [self initHelper];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    _imageFlowLayout = [RMGalleryViewLayout new];
    _imageFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return [self initWithFrame:frame collectionViewLayout:_imageFlowLayout];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _imageFlowLayout = [RMGalleryViewLayout new];
        _imageFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionViewLayout = _imageFlowLayout;
        [self initHelper];
    }
    return self;
}

- (void)initHelper
{
    _galleryIndex = 0;
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.dataSource = self;
    [self registerClass:RMGalleryCell.class forCellWithReuseIdentifier:CellIdentifier];
    
    // Apparently, UICollectionView or one of its subclasses acts as UIGestureRecognizerDelegate. We use this inner class to avoid conflicts.
    _swipeDelegate = [[RMGalleryViewSwipeGRDelegate alloc] initWithGalleryView:self];
    
    _swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftGesture:)];
    _swipeLeftGestureRecognizer.delegate = _swipeDelegate;
    _swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:_swipeLeftGestureRecognizer];
    [self.panGestureRecognizer requireGestureRecognizerToFail:_swipeLeftGestureRecognizer];
    
    _swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightGesture:)];
    _swipeRightGestureRecognizer.delegate = _swipeDelegate;
    _swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:_swipeRightGestureRecognizer];
    [self.panGestureRecognizer requireGestureRecognizerToFail:_swipeRightGestureRecognizer];
    
    _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGesture:)];
    _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:_doubleTapGestureRecognizer];
    
    [super setDelegate:self];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.galleryDataSource numberOfImagesInGalleryView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RMGalleryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    [cell.activityIndicatorView startAnimating];
    __block BOOL sync = YES;
    [self.galleryDataSource galleryView:self imageForIndex:indexPath.row completion:^(UIImage *image) {
        // Check if cell was reused
        NSIndexPath *currentIndexPath = [self indexPathForCell:cell];
        if (!sync && [indexPath compare:currentIndexPath] != NSOrderedSame) return;
        
        [cell.activityIndicatorView stopAnimating];
        cell.image = image;
    }];
    sync = NO;
    return cell;
}

#pragma mark Gestures

- (void)doubleTapGesture:(UIGestureRecognizer*)gestureRecognizer
{
    const CGPoint point = [gestureRecognizer locationInView:self];
    [self toggleZoomAtPoint:point];
}

- (void)swipeLeftGesture:(UIGestureRecognizer*)gestureRecognizer
{
    [self showNext];
}

- (void)swipeRightGesture:(UIGestureRecognizer*)gestureRecognizer
{
    [self showPrevious];
}

#pragma mark UICollectionViewDelegate (Paging)

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _willBeginDraggingIndex = [_imageFlowLayout indexForOffset:self.contentOffset];
    
    if ([_realDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
    {
        [_realDelegate scrollViewWillBeginDragging:scrollView];
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView*)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint*)targetContentOffset
{
    NSInteger targetIndex;
    if (velocity.x == 0)
    {
        targetIndex = [_imageFlowLayout indexForOffset:*targetContentOffset];
        if (targetIndex != _willBeginDraggingIndex)
        {
            targetIndex = targetIndex > _willBeginDraggingIndex ? _willBeginDraggingIndex + 1 : _willBeginDraggingIndex - 1;
        }
    }
    else
    {
        targetIndex = velocity.x > 0 ? _willBeginDraggingIndex + 1 : _willBeginDraggingIndex - 1;
    }
    targetIndex = MAX(0, targetIndex);
    const NSUInteger maxIndex = [self.galleryDataSource numberOfImagesInGalleryView:self] - 1;
    targetIndex = MIN(targetIndex, maxIndex);
    *targetContentOffset = [_imageFlowLayout offsetForIndex:targetIndex];
    
    if ([_realDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
    {
        [_realDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

#pragma mark UICollectionViewDelegate (Changing the index)

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.scrollEnabled) {
        return;
    }
    const NSUInteger index = [_imageFlowLayout indexForOffset:scrollView.contentOffset];
    if (index != _galleryIndex)
    {
        _galleryIndex = index;
        if ([self.galleryDelegate respondsToSelector:@selector(galleryView:didChangeIndex:)])
        {
            [self.galleryDelegate galleryView:self didChangeIndex:index];
        }
    }
    if ([_realDelegate respondsToSelector:@selector(scrollViewDidScroll:)])
    {
        [_realDelegate scrollViewDidScroll:scrollView];
    }
}

#pragma mark Managing state

- (NSUInteger)galleryIndex
{
    return _galleryIndex;
}

- (void)setGalleryIndex:(NSUInteger)index
{
    [self setGalleryIndex:index animated:NO];
}

- (void)setGalleryIndex:(NSUInteger)galleryIndex animated:(BOOL)animated
{
    NSParameterAssert(galleryIndex < [self.galleryDataSource numberOfImagesInGalleryView:self]);

    _galleryIndex = galleryIndex;
    
    const CGPoint offset = [_imageFlowLayout offsetForIndex:_galleryIndex];
    [self setContentOffset:offset animated:animated];
}

#pragma mark Locating cells

- (RMGalleryCell*)galleryCellAtIndex:(NSUInteger)index
{
    NSParameterAssert(index < [self.galleryDataSource numberOfImagesInGalleryView:self]);

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    RMGalleryCell *cell = (RMGalleryCell*)[self cellForItemAtIndexPath:indexPath];
    return cell;
}

#pragma mark Actions

- (void)showNext
{
    const NSUInteger count = [self.galleryDataSource numberOfImagesInGalleryView:self];
    const NSUInteger nextIndex = _galleryIndex + 1;
    if (nextIndex < count)
    {
        CGPoint offset = [_imageFlowLayout offsetForIndex:nextIndex];
        [self setContentOffset:offset animated:YES];
    }
}

- (void)showPrevious
{
    const NSInteger previousIndex = _galleryIndex - 1;
    if (previousIndex >= 0)
    {
        CGPoint offset = [_imageFlowLayout offsetForIndex:previousIndex];
        [self setContentOffset:offset animated:YES];
    }
}

- (void)toggleZoomAtPoint:(CGPoint)point
{
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:point];
    if (!indexPath) return;
    
    RMGalleryCell *cell = (RMGalleryCell*)[self cellForItemAtIndexPath:indexPath];
    const CGPoint cellPoint = [cell convertPoint:point fromView:self];
    [cell toggleZoomAtPoint:cellPoint];
}

#pragma mark Collection View delegate forwarding

- (void)dealloc
{
    self.delegate = nil;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    if ([_realDelegate respondsToSelector:invocation.selector])
    {
        [invocation invokeWithTarget:_realDelegate];
    }
    else
    {
        [super forwardInvocation:invocation];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)s
{
    return [super methodSignatureForSelector:s] ?: [(id)_realDelegate methodSignatureForSelector:s];
}

- (BOOL)respondsToSelector:(SEL)s
{
    return [super respondsToSelector:s] || [_realDelegate respondsToSelector:s];
}

- (void)setDelegate:(id<UICollectionViewDelegate>)delegate
{
    [super setDelegate: delegate ? self : nil];
    _realDelegate = delegate != self ? delegate : nil;
}


@end

@implementation RMGalleryViewLayout

#pragma mark UICollectionViewFlowLayout

- (CGSize)itemSize
{
    const CGSize viewSize = self.collectionView.bounds.size;
    const UIEdgeInsets viewInset = self.collectionView.contentInset;
    const CGSize size = CGSizeMake(viewSize.width - viewInset.left - viewInset.right, viewSize.height - viewInset.top - viewInset.bottom);
    return size;
}

#pragma mark UICollectionViewLayout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset NS_AVAILABLE_IOS(7_0);
{
    RMGalleryView *collectionView = (RMGalleryView*)self.collectionView;
    NSUInteger targetIndex = collectionView.galleryIndex;
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
    // TODO: Not using layoutAttributesForItemAtIndexPath: because it sometimes returns frame.origin = (0,0) for index > 0. Why?

    const CGFloat width = self.itemSize.width;
    const CGFloat spacing = self.minimumInteritemSpacing;
    const CGFloat offsetX = index * (width + spacing);
    const CGPoint contentOffset = self.collectionView.contentOffset;
    const CGPoint offset = CGPointMake(offsetX, contentOffset.y);
    return offset;
}

@end

@implementation RMGalleryViewSwipeGRDelegate
{
    __weak RMGalleryView *_galleryView;
}

- (id)initWithGalleryView:(__weak RMGalleryView*)galleryView
{
    if (self = [super init])
    {
        _galleryView = galleryView;
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    const CGPoint point = [touch locationInView:_galleryView];
    NSIndexPath *indexPath = [_galleryView indexPathForItemAtPoint:point];
    if (!indexPath) return YES;
    
    RMGalleryCell *cell = (RMGalleryCell*)[_galleryView cellForItemAtIndexPath:indexPath];
    UIScrollView *scrollView = cell.scrollView;
    BOOL zooming = scrollView.zoomScale > scrollView.minimumZoomScale;
    return !zooming;
    
    // TODO: Receive touches when leftmost or rightmost
}

@end
