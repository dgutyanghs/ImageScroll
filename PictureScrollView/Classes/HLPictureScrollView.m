//
//  HLPictureScrollView
//  SmartCoach
//
//  Created by AlexYang on 15/7/8.
//  Copyright (c) 2015年 SmartCoach. All rights reserved.
//

#import "HLPictureScrollView.h"
#import "UIImageView+WebCache.h"


typedef NS_ENUM(NSInteger, SectionButtonIndex) {
    leftArrowButtonTag,
    rightArrowButtonTag,
};

@interface HLPictureScrollView ()
@property (nonatomic , weak) UIPageControl *pageControl;
@property (nonatomic , assign) int currentPageIndex;
@property (nonatomic, weak) UIView *containView;
@end

@implementation HLPictureScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIScrollView *scrollView = [UIScrollView newAutoLayoutView];
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIView *containView = [UIView newAutoLayoutView];
        containView.backgroundColor = [UIColor greenColor];
        [scrollView addSubview:containView];
        self.containView = containView;
        
        UIPageControl *pageControl = [UIPageControl newAutoLayoutView];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return self;
}

-(void)refreshWithImagesURLStr:(NSArray *)imageAddress
{
    self.pageCount = imageAddress.count;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.scrollView autoPinEdgesToSuperviewEdges];
    self.scrollView.backgroundColor = [UIColor greenColor];
    
    NSMutableArray *imageViewsM = [NSMutableArray arrayWithCapacity:imageAddress.count];
    if (imageAddress.count) {
        for (int i = 0; i < imageAddress.count; i++) {
            UIImageView *imageView = [UIImageView newAutoLayoutView];
            imageView.contentMode = UIViewContentModeCenter;
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageAddress[i]] placeholderImage:[UIImage imageNamed:@"piano1"] options:SDWebImageAllowInvalidSSLCertificates];

            [self.scrollView addSubview:imageView];
            [imageViewsM addObject:imageView];
//            [imageView autoPinEdgesToSuperviewEdges];
        }
        
        [imageViewsM autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:0 insetSpacing:0 matchedSizes:YES];
        [imageViewsM[0] autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.containView withOffset:0];
        [imageViewsM[0] autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.containView];
        [imageViewsM[0] autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.containView];
        
//        [imageViewsM autoAlignViewsToEdge:ALEdgeTop];
//        [imageViewsM autoAlignViewsToEdge:ALEdgeBottom];
        
    }
    
    self.pageControl.numberOfPages = imageAddress.count;
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.pageIndicatorTintColor = [UIColor blueColor];
    CGSize pagesSize = [self.pageControl sizeForNumberOfPages:imageAddress.count];
    [self.pageControl autoSetDimension:ALDimensionHeight toSize:pagesSize.height];
    [self.pageControl autoSetDimension:ALDimensionWidth toSize:pagesSize.width];
    [self.pageControl autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.pageControl autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:10.0];
//    self.pageControl.frame = CGRectMake((viewW - pagesSize.width)/2, viewH - pagesSize.height, pagesSize.width, pagesSize.height);
}


+(instancetype)viewWithFrame:(CGRect)frame andImagesUrl:(NSArray *)imagesUrl viewDisplayMode:(UIViewContentMode)contentMode
{
    CGFloat viewH = frame.size.height;
//    CGFloat viewW = frame.size.width;
    
    HLPictureScrollView *sectionHeader  = [[HLPictureScrollView alloc] initWithFrame:frame];
    [sectionHeader configureForAutoLayout];
    
    sectionHeader.pageCount = imagesUrl.count;
    sectionHeader.scrollView.userInteractionEnabled = YES;
    sectionHeader.scrollView.delegate = sectionHeader;
    sectionHeader.scrollView.pagingEnabled = YES;
    sectionHeader.scrollView.showsHorizontalScrollIndicator = NO;
    
    
    if (imagesUrl.count) {
        // set containView size to scrollview.contentsize
        [sectionHeader.containView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:sectionHeader.scrollView withMultiplier:imagesUrl.count];
        UIImageView *preImageView = nil;
        for (int i = 0; i < imagesUrl.count; i++) {
            UIImageView *imageView = [UIImageView newAutoLayoutView];
            [imageView sd_setImageWithURL:imagesUrl[i] placeholderImage:[UIImage imageNamed:@"piano1"] options:SDWebImageAllowInvalidSSLCertificates];
            imageView.contentMode = contentMode;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:sectionHeader action:@selector(imageViewDidTaped:)];
            [imageView addGestureRecognizer:tap];
            [sectionHeader.containView addSubview:imageView];
            [imageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:sectionHeader.scrollView];
            [imageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:sectionHeader.scrollView];
            [imageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            if (!preImageView) {
                [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            }else {
                [imageView autoConstrainAttribute:ALAttributeLeading toAttribute:ALAttributeTrailing ofView:preImageView];
            }
            
            preImageView = imageView;
        }
        
        [sectionHeader.containView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:sectionHeader.scrollView];
        [sectionHeader.containView autoPinEdge:ALEdgeTop  toEdge:ALEdgeTop  ofView:sectionHeader.scrollView];
        [sectionHeader.containView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:sectionHeader.scrollView];
        [sectionHeader.containView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:sectionHeader.scrollView];
        [sectionHeader.containView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:sectionHeader.scrollView];
    }
    
    sectionHeader.pageControl.numberOfPages = imagesUrl.count;
    sectionHeader.pageControl.hidesForSinglePage = YES;
    CGSize pagesSize = [sectionHeader.pageControl sizeForNumberOfPages:imagesUrl.count];
    [sectionHeader.pageControl autoSetDimensionsToSize:pagesSize];
    [sectionHeader.pageControl autoAlignAxis:ALAxisVertical toSameAxisOfView:sectionHeader];
    [sectionHeader.pageControl autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:sectionHeader withOffset:10];
    
    
    [sectionHeader.scrollView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:sectionHeader];
    [sectionHeader.scrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:sectionHeader];
    [sectionHeader.scrollView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:sectionHeader];
    [sectionHeader.scrollView autoSetDimension:ALDimensionHeight toSize:viewH];
    
    return sectionHeader;
}

#pragma mark - UIScrollView delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGFloat pageWidth = scrollView.frame.size.width;
//    int userPanOffset = ((int)scrollView.contentOffset.x) % ((int)pageWidth/2);
//    CGFloat alpha = userPanOffset / (CGFloat)(pageWidth/2);
//    HLLog(@" userPanOffset %d", userPanOffset);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    static int oldPage = 0;
    
    if (decelerate == NO) {
        // 得到每页宽度
        int pageWidth = scrollView.frame.size.width;
        // 根据当前的x坐标和页宽度计算出当前页数
        CGFloat contentOffsetX = scrollView.contentOffset.x;
        
        int currentPage = floor((contentOffsetX - pageWidth / 2) / pageWidth) + 1;
        if (currentPage != oldPage) {
            //通知代理
            if ([self.delegate respondsToSelector:@selector(sectionHeaderViewPageDidChanged:)]) {
                [self.delegate sectionHeaderViewPageDidChanged:[NSNumber numberWithInt:currentPage]];
            }
        
            oldPage = currentPage;
            self.pageControl.currentPage = currentPage;
        }
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    static int oldPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.currentPageIndex = currentPage;
    
    if (currentPage != oldPage) {
        if ([self.delegate respondsToSelector:@selector(sectionHeaderViewPageDidChanged:)]) {
            [self.delegate sectionHeaderViewPageDidChanged:[NSNumber numberWithInt:currentPage]];
        }
        self.pageControl.currentPage = currentPage;
       oldPage = currentPage;
    }
}

-(void)imageViewDidTaped:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(pictureScrollImageViewDidTap:)]) {
        [self.delegate pictureScrollImageViewDidTap:self.currentPageIndex];
    }
}

@end
