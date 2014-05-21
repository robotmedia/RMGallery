//
//  RMGalleryViewTests.m
//  RMGallery
//
//  Created by Hermés Piqué on 21/05/14.
//  Copyright (c) 2014 Robot Media. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RMGalleryView.h"

@interface RMGalleryViewTests : XCTestCase

@end

@implementation RMGalleryViewTests

- (void)testInit
{
    RMGalleryView *view = [RMGalleryView new];
    
    UICollectionViewLayout *layout = view.collectionViewLayout;
    
    XCTAssertNotNil(layout, @"");
    XCTAssertTrue([layout isKindOfClass:UICollectionViewFlowLayout.class], @"");
    XCTAssertNotNil(view.doubleTapGestureRecognizer, @"");
    XCTAssertNotNil(view.swipeLeftGestureRecognizer, @"");
    XCTAssertNotNil(view.swipeRightGestureRecognizer, @"");
    XCTAssertEqualObjects(view.dataSource, view, @"");
}

- (void)testInitWithFrame
{
    CGRect frame = CGRectMake(0, 0, 100, 100);
    
    RMGalleryView *view = [[RMGalleryView alloc] initWithFrame:frame];
    
    XCTAssertTrue(CGRectEqualToRect(view.frame, frame), @"");
    UICollectionViewLayout *layout = view.collectionViewLayout;
    XCTAssertNotNil(layout, @"");
    XCTAssertTrue([layout isKindOfClass:UICollectionViewFlowLayout.class], @"");
    XCTAssertNotNil(view.doubleTapGestureRecognizer, @"");
    XCTAssertNotNil(view.swipeLeftGestureRecognizer, @"");
    XCTAssertNotNil(view.swipeRightGestureRecognizer, @"");
    XCTAssertEqualObjects(view.dataSource, view, @"");
}

- (void)testInitWithCoder
{
    NSCoder *aDecoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:[NSData data]];
    
    RMGalleryView *view = [[RMGalleryView alloc] initWithCoder:aDecoder];
    
    UICollectionViewLayout *layout = view.collectionViewLayout;
    XCTAssertNotNil(layout, @"");
    XCTAssertTrue([layout isKindOfClass:UICollectionViewFlowLayout.class], @"");
    XCTAssertNotNil(view.doubleTapGestureRecognizer, @"");
    XCTAssertNotNil(view.swipeLeftGestureRecognizer, @"");
    XCTAssertNotNil(view.swipeRightGestureRecognizer, @"");
    XCTAssertEqualObjects(view.dataSource, view, @"");
}

- (void)testInitWithFrameCollectionViewLayout
{
    CGRect frame = CGRectMake(0, 0, 100, 100);
    UICollectionViewLayout *layout = [UICollectionViewFlowLayout new];
 
    RMGalleryView *view = [[RMGalleryView alloc] initWithFrame:frame collectionViewLayout:layout];
    
    XCTAssertTrue(CGRectEqualToRect(view.frame, frame), @"");
    XCTAssertEqual(view.collectionViewLayout, layout, @"");
    XCTAssertTrue([layout isKindOfClass:UICollectionViewFlowLayout.class], @"");
    XCTAssertNotNil(view.doubleTapGestureRecognizer, @"");
    XCTAssertNotNil(view.swipeLeftGestureRecognizer, @"");
    XCTAssertNotNil(view.swipeRightGestureRecognizer, @"");
    XCTAssertEqualObjects(view.dataSource, view, @"");
}


@end
