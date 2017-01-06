//
//  ViewController.m
//  PictureScrollView
//
//  Created by AlexYang on 17/1/6.
//  Copyright © 2017年 AlexYang. All rights reserved.
//

#import "ViewController.h"
#import "HLPictureScrollView.h"
#import "PureLayout.h"


#define SCREEN_WIDTH   ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT  ([UIScreen mainScreen].bounds.size.height)

@interface ViewController () <HLPictureScrollViewDelegte>
@property (weak, nonatomic) IBOutlet UILabel *tapLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
- (IBAction)switchButtonDidClicked:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *containView;
@property (nonatomic , strong) HLPictureScrollView *slideView;
@property (nonatomic, strong) NSMutableArray *imagesUrls;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray <NSURL *> *imageUrls = [NSMutableArray array];
    
    NSURL *url1 = [NSURL URLWithString:@"http://mm.howkuai.com/wp-content/uploads/2016a/08/12/01.jpg"];
    NSURL *url2 = [NSURL URLWithString:@"http://mm.howkuai.com/wp-content/uploads/2016a/08/12/02.jpg"];
    NSURL *url3 = [NSURL URLWithString:@"http://mm.howkuai.com/wp-content/uploads/2016a/08/12/03.jpg"];
    NSURL *url4 = [NSURL URLWithString:@"http://mm.howkuai.com/wp-content/uploads/2016a/08/12/04.jpg"];
    
    [imageUrls addObject:url1];
    [imageUrls addObject:url2];
    [imageUrls addObject:url3];
    [imageUrls addObject:url4];
    self.imagesUrls = imageUrls;
    
    [self loadPianosPictures:imageUrls];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadPianosPictures:(NSMutableArray *)imagesUrls  {
    
    _slideView = [HLPictureScrollView viewWithImagesUrl:imagesUrls viewDisplayMode: UIViewContentModeScaleToFill];
    _slideView.delegate = self;
    [self.containView addSubview:_slideView];
#pragma mark - 更改图片大小,位置
  //1.图片占满父窗口 (his super view)
//    [_slideView autoPinEdgesToSuperviewEdges];
    
  //2.图片与父窗口留空白 (his super view)
    [_slideView autoPinEdgesToSuperviewMargins];

//  3.自定义图片大小,位置
//    CGRect slideFrame = CGRectMake(15, 10, 230, 480);
//    [_slideView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(slideFrame.origin.y, slideFrame.origin.x, SCREEN_HEIGHT - slideFrame.size.height, SCREEN_WIDTH - slideFrame.size.width)];
    
    [self.slideView setNeedsDisplay];
}

#pragma mark - HLPictureScrollViewDelegate

-(void)sectionHeaderViewPageDidChanged:(NSNumber *)index {
    self.pageLabel.text = [NSString stringWithFormat:@"user did scroll to the page:%d ", index.intValue];
}

-(void)pictureScrollImageViewDidTap:(int)index {
    self.tapLabel.text = [NSString stringWithFormat:@"user did tap the picture:%d ", index];
}

- (IBAction)switchButtonDidClicked:(UIButton *)sender {
    sender.hidden = YES;
    
    NSURL *url1 = [NSURL URLWithString:@"http://mm.howkuai.com/wp-content/uploads/2016a/02/08/01.jpg"];
    NSURL *url2 = [NSURL URLWithString:@"http://mm.howkuai.com/wp-content/uploads/2016a/02/08/02.jpg"];
    NSURL *url3 = [NSURL URLWithString:@"http://mm.howkuai.com/wp-content/uploads/2016a/02/08/03.jpg"];
    NSURL *url4 = [NSURL URLWithString:@"http://mm.howkuai.com/wp-content/uploads/2016a/02/08/04.jpg"];
    NSURL *url5 = [NSURL URLWithString:@"http://mm.howkuai.com/wp-content/uploads/2016a/02/08/05.jpg"];
    NSURL *url6 = [NSURL URLWithString:@"http://mm.howkuai.com/wp-content/uploads/2016a/02/08/06.jpg"];
    NSURL *url7 = [NSURL URLWithString:@"http://mm.howkuai.com/wp-content/uploads/2016a/02/08/07.jpg"];
    NSURL *url8 = [NSURL URLWithString:@"http://mm.howkuai.com/wp-content/uploads/2016a/02/08/08.jpg"];
    
    [self.imagesUrls removeAllObjects];
    
    [self.imagesUrls addObject:url1];
    [self.imagesUrls addObject:url2];
    [self.imagesUrls addObject:url3];
    [self.imagesUrls addObject:url4];
    [self.imagesUrls addObject:url5];
    [self.imagesUrls addObject:url6];
    [self.imagesUrls addObject:url7];
    [self.imagesUrls addObject:url8];
    
    [self.slideView refreshWithImagesURLStr:self.imagesUrls];
    [self.slideView setNeedsLayout];
}
@end
