//
//  BaseAnimationView.m
//  PAnimation
//
//  Created by os on 2019/1/24.
//  Copyright © 2019年 os. All rights reserved.
//

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#import "BaseAnimationView.h"
#import "AnimationKeyPathName.h"
#import "AnimationModel.h"

@interface BaseAnimationView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *squareView;
@property (nonatomic, strong) UILabel *squareLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation BaseAnimationView

- (instancetype)init{
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]) {
        [self initData];
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    self.squareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
    self.squareView.backgroundColor = [UIColor cyanColor];
    self.squareView.layer.borderColor = [UIColor redColor].CGColor;
    self.squareView.center = CGPointMake(SCREEN_WIDTH/2.0, 100);
    self.squareView.layer.shadowOpacity = 0.6;
    self.squareView.layer.shadowOffset = CGSizeMake(0, 0);
    self.squareView.layer.shadowRadius = 4;
    self.squareView.layer.shadowColor = [UIColor redColor].CGColor;
    [self addSubview:self.squareView];
    
    self.squareLabel = [[UILabel alloc] initWithFrame:self.squareView.bounds];
    self.squareLabel.text = @"label";
    self.squareLabel.textAlignment = NSTextAlignmentCenter;
    self.squareLabel.textColor = [UIColor blackColor];
    self.squareLabel.font = [UIFont systemFontOfSize:17];
    [self.squareView addSubview:self.squareLabel];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT-200) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
}

- (void)initData{
    /*
     kCAScaleZ 缩放z 没有意义，因为是平面图形
     kCAPositionX设置y没有意义，可以随意设置，同理kCAPositionY设置x没有意义
     kCABackgroundColor,颜色变化必须要用CGColor
     用到shadow的几个属性变化的时候，需要先设置shadow
     */
    NSValue *startPoint = [NSValue valueWithCGPoint:self.squareView.center];
    NSValue *endPoint = [NSValue valueWithCGPoint:CGPointMake(500, 500)];
    NSValue *shadowStartPoint = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    NSValue *shadowEndPoint = [NSValue valueWithCGPoint:CGPointMake(5, 5)];
    id startColor = (id)([UIColor cyanColor].CGColor);
    id endColor = (id)([UIColor redColor].CGColor);
    id shadowStartColor = (id)[UIColor clearColor].CGColor;
    id shadowEndColor = (id)[UIColor redColor].CGColor;
    self.dataSource = [NSMutableArray array];
    NSArray *keypaths   = @[kCARotation,kCARotationX,kCARotationY,kCARotationZ,
                            kCAScale,kCAScaleX,kCAScaleZ,kCAPositionX,
                            kCABoundsSizeW,kCAOpacity,kCABackgroundColor,kCACornerRadius,
                            kCABorderWidth,kCAShadowColor,kCAShadowRadius,kCAShadowOffset];
    
    NSArray *fromValues = @[@0,@0,@0,@0,
                            @0,@0,@0,startPoint,
                            @100,@1,startColor,@0,
                            @0,shadowStartColor,@0,shadowStartPoint];
    
    NSArray *toValues   = @[@(M_PI),@(M_PI),@(M_PI),@(M_PI),
                            @1,@1,@1,endPoint,
                            @200,@0,endColor,@40,
                            @4,shadowEndColor,@8,shadowEndPoint];
    for (int i=0; i<keypaths.count; i++) {
        AnimationModel *model = [[AnimationModel alloc] init];
        model.keyPaths = keypaths[i];
        model.fromValue = fromValues[i];
        model.toValue = toValues[i];
        [self.dataSource addObject:model];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnimationModel *model = [self.dataSource objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    cell.textLabel.text = model.keyPaths;
    cell.selectionStyle = 0;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AnimationModel *model = [self.dataSource objectAtIndex:indexPath.row];
    CABasicAnimation *animation = [self getAnimationKeyPath:model.keyPaths fromValue:model.fromValue toValue:model.toValue];
    [self.squareView.layer addAnimation:animation forKey:nil];
}

- (CABasicAnimation *)getAnimationKeyPath:(NSString *)keyPath fromValue:(id)fromValue toValue:(id)toValue{
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:keyPath];
    basicAnimation.fromValue = fromValue;
    /*byvalue是在fromvalue的值的基础上增加量*/
    //basicAnimation.byValue = @1;
    basicAnimation.toValue = toValue;
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];;
    basicAnimation.duration = 2;
    basicAnimation.repeatCount = 1;
    /* animation remove from view after animation finish */
    basicAnimation.removedOnCompletion = YES;
    return basicAnimation;
}

@end
