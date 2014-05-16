//
//  RMGalleryCellTests.m
//  RMGallery
//
//  Created by Hermés Piqué on 16/05/14.
//  Copyright (c) 2014 Robot Media. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RMGalleryCell.h"
#import "UIImage+RMGalleryTestUtils.h"

@interface RMGalleryCellTests : XCTestCase

@end

@implementation RMGalleryCellTests {
    RMGalleryCell *_cell;
}

- (void)setUp
{
    [super setUp];
    _cell = [[RMGalleryCell alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
}

- (void)testInit
{
    RMGalleryCell *cell = [RMGalleryCell new];
    
    XCTAssertNotNil(cell.scrollView, @"");
    XCTAssertFalse(cell.scrollView.showsHorizontalScrollIndicator, @"");
    XCTAssertFalse(cell.scrollView.showsVerticalScrollIndicator, @"");
    XCTAssertEqualObjects(cell.scrollView.delegate, cell, @"");
    XCTAssertEqual(cell.scrollView.maximumZoomScale, 1.5f, @"");
    
    XCTAssertNotNil(cell.activityIndicatorView, @"");
    XCTAssertTrue(cell.activityIndicatorView.hidesWhenStopped, @"");
    XCTAssertNil(cell.image, @"");
}

- (void)testSetImage_SameSize
{
    const CGSize size = _cell.frame.size;
    UIImage *image = [UIImage rm_imageWithSize:size];
    _cell.image = image;
    XCTAssertEqual(_cell.scrollView.minimumZoomScale, 1.0f, @"");
    XCTAssertEqual(_cell.scrollView.zoomScale, 1.0f, @"");
    XCTAssertTrue(CGPointEqualToPoint(_cell.scrollView.contentOffset, CGPointZero), @"");
}

- (void)testSetImage_SmallerSquare
{
    const CGSize size = CGSizeMake(_cell.frame.size.width / 2, _cell.frame.size.height / 2);
    UIImage *image = [UIImage rm_imageWithSize:size];
    _cell.image = image;
    XCTAssertEqual(_cell.scrollView.minimumZoomScale, 1.0f, @"");
    XCTAssertEqual(_cell.scrollView.zoomScale, 1.0f, @"");
    XCTAssertTrue(CGPointEqualToPoint(_cell.scrollView.contentOffset, CGPointMake(-25, -25)), @"");
}

- (void)testSetImage_SmallerPortrait
{
    const CGSize size = CGSizeMake(_cell.frame.size.width / 2, _cell.frame.size.height);
    UIImage *image = [UIImage rm_imageWithSize:size];
    _cell.image = image;
    XCTAssertEqual(_cell.scrollView.minimumZoomScale, 1.0f, @"");
    XCTAssertEqual(_cell.scrollView.zoomScale, 1.0f, @"");
    XCTAssertTrue(CGPointEqualToPoint(_cell.scrollView.contentOffset, CGPointMake(-25, 0)), @"");
}

- (void)testSetImage_SmallerLandscape
{
    const CGSize size = CGSizeMake(_cell.frame.size.width, _cell.frame.size.height / 2);
    UIImage *image = [UIImage rm_imageWithSize:size];
    _cell.image = image;
    XCTAssertEqual(_cell.scrollView.minimumZoomScale, 1.0f, @"");
    XCTAssertEqual(_cell.scrollView.zoomScale, 1.0f, @"");
    XCTAssertTrue(CGPointEqualToPoint(_cell.scrollView.contentOffset, CGPointMake(0, -25)), @"");
}

- (void)testSetImage_BiggerSquare
{
    const CGFloat scale = 2;
    const CGSize size = CGSizeMake(_cell.frame.size.width * scale, _cell.frame.size.height * scale);
    UIImage *image = [UIImage rm_imageWithSize:size];
    _cell.image = image;
    XCTAssertEqual(_cell.scrollView.minimumZoomScale, 1.0f / scale, @"");
    XCTAssertEqual(_cell.scrollView.zoomScale, 1.0f / scale, @"");
    XCTAssertTrue(CGPointEqualToPoint(_cell.scrollView.contentOffset, CGPointMake(0, 0)), @"");
}

- (void)testSetImage_BiggerPortrait
{
    const CGFloat scale = 2;
    const CGSize size = CGSizeMake(_cell.frame.size.width, _cell.frame.size.height * scale);
    UIImage *image = [UIImage rm_imageWithSize:size];
    _cell.image = image;
    XCTAssertEqual(_cell.scrollView.minimumZoomScale, 1.0f / scale, @"");
    XCTAssertEqual(_cell.scrollView.zoomScale, 1.0f / scale, @"");
    XCTAssertTrue(CGPointEqualToPoint(_cell.scrollView.contentOffset, CGPointMake(-25, 0)), @"");
}

- (void)testSetImage_BiggerLandscape
{
    const CGFloat scale = 2;
    const CGSize size = CGSizeMake(_cell.frame.size.width * scale, _cell.frame.size.height);
    UIImage *image = [UIImage rm_imageWithSize:size];
    _cell.image = image;
    XCTAssertEqual(_cell.scrollView.minimumZoomScale, 1.0f / scale, @"");
    XCTAssertEqual(_cell.scrollView.zoomScale, 1.0f / scale, @"");
    XCTAssertTrue(CGPointEqualToPoint(_cell.scrollView.contentOffset, CGPointMake(0, -25)), @"");
}


- (void)testToggleZoomAtPoint
{
    const CGSize size = _cell.frame.size;
    UIImage *image = [UIImage rm_imageWithSize:size];
    _cell.image = image;
    [_cell toggleZoomAtPoint:CGPointMake(0, 0)];
}

- (void)testSetImageInSize_Smaller
{
    UIImage *image = [UIImage rm_imageWithSize:_cell.bounds.size];

    const CGFloat scale = 0.5;
    const CGSize size = CGSizeMake(_cell.frame.size.width * scale, _cell.frame.size.height * scale);

    [_cell setImage:image inSize:size];
    
    XCTAssertEqual(_cell.scrollView.minimumZoomScale, 1.0f, @"");
    XCTAssertEqual(_cell.scrollView.zoomScale, 1.0f, @"");
    XCTAssertTrue(CGPointEqualToPoint(_cell.scrollView.contentOffset, CGPointMake(-25, -25)), @"");
}

@end
