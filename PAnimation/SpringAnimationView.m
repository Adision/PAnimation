//
//  SpringAnimationView.m
//  PAnimation
//
//  Created by os on 2019/1/24.
//  Copyright © 2019年 os. All rights reserved.
//

#import "SpringAnimationView.h"

#import "SpringAnimationView.h"
#import "UIView+HPAdditions.h"
#import "AnimationKeyPathName.h"
#import "AnimationModel.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@interface SpringAnimationView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *squareView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UISlider *massSlider;
@property (nonatomic, strong) UISlider *stiffnessSlider;
@property (nonatomic, strong) UISlider *dampingSlider;
@property (nonatomic, strong) UILabel *massLabel;
@property (nonatomic, strong) UILabel *stiffnessLabel;
@property (nonatomic, strong) UILabel *dampingLabel;

@end

@implementation SpringAnimationView

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
    self.squareView.center = CGPointMake(SCREEN_WIDTH/2.0, 200);
    self.squareView.layer.shadowOpacity = 0.6;
    self.squareView.layer.shadowOffset = CGSizeMake(0, 0);
    self.squareView.layer.shadowRadius = 4;
    self.squareView.layer.shadowColor = [UIColor redColor].CGColor;
    [self addSubview:self.squareView];
    
    self.massSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 0, 100, 40)];
    self.massSlider.minimumValue = 0;
    self.massSlider.maximumValue = 1;
    self.massSlider.tintColor = [UIColor cyanColor];
    self.massSlider.thumbTintColor = [UIColor redColor];
    self.massSlider.top = self.squareView.bottom + 100;
    [self addSubview:self.massSlider];
    [self.massSlider addTarget:self action:@selector(durationChange:) forControlEvents:UIControlEventValueChanged];
    
    self.stiffnessSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 0, 100, 40)];
    self.stiffnessSlider.minimumValue = 0;
    self.stiffnessSlider.maximumValue = 100;
    self.stiffnessSlider.tintColor = [UIColor cyanColor];
    self.stiffnessSlider.thumbTintColor = [UIColor redColor];
    self.stiffnessSlider.top = self.massSlider.bottom + 10;
    [self addSubview:self.stiffnessSlider];
    [self.stiffnessSlider addTarget:self action:@selector(durationChange:) forControlEvents:UIControlEventValueChanged];
    
    self.dampingSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 0, 100, 40)];
    self.dampingSlider.minimumValue = 0;
    self.dampingSlider.maximumValue = 10;
    self.dampingSlider.tintColor = [UIColor cyanColor];
    self.dampingSlider.thumbTintColor = [UIColor redColor];
    self.dampingSlider.top = self.stiffnessSlider.bottom + 10;
    [self addSubview:self.dampingSlider];
    [self.dampingSlider addTarget:self action:@selector(durationChange:) forControlEvents:UIControlEventValueChanged];
    
    self.massLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    self.massLabel.text = @"mass";
    self.massLabel.centerY = self.massSlider.centerY;
    self.massLabel.left = self.massSlider.right+10;
    self.massLabel.textAlignment = NSTextAlignmentLeft;
    self.massLabel.textColor = [UIColor blackColor];
    self.massLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.massLabel];
    
    self.stiffnessLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    self.stiffnessLabel.text = @"stiffness";
    self.stiffnessLabel.centerY = self.stiffnessSlider.centerY;
    self.stiffnessLabel.left = self.stiffnessSlider.right+10;
    self.stiffnessLabel.textAlignment = NSTextAlignmentLeft;
    self.stiffnessLabel.textColor = [UIColor blackColor];
    self.stiffnessLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.stiffnessLabel];
    
    self.dampingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    self.dampingLabel.text = @"damping";
    self.dampingLabel.centerY = self.dampingSlider.centerY;
    self.dampingLabel.left = self.dampingSlider.right+10;
    self.dampingLabel.textAlignment = NSTextAlignmentLeft;
    self.dampingLabel.textColor = [UIColor blackColor];
    self.dampingLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.dampingLabel];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.dampingSlider.bottom+20, SCREEN_WIDTH, SCREEN_HEIGHT-self.dampingSlider.bottom-20) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
}

/* The mass of the object attached to the end of the spring. Must be greater
 than 0. Defaults to one. */

//@property CGFloat mass;

/* The spring stiffness coefficient. Must be greater than 0.
 * Defaults to 100. */

//@property CGFloat stiffness;

/* The damping coefficient. Must be greater than or equal to 0.
 * Defaults to 10. */

//@property CGFloat damping;

/* The initial velocity of the object attached to the spring. Defaults
 * to zero, which represents an unmoving object. Negative values
 * represent the object moving away from the spring attachment point,
 * positive values represent the object moving towards the spring
 * attachment point. */

//@property CGFloat initialVelocity;


- (void)initData{
    /*
     kCAScaleZ 缩放z 没有意义，因为是平面图形
     kCAPositionX设置y没有意义，可以随意设置，同理kCAPositionY设置x没有意义
     kCABackgroundColor,颜色变化必须要用CGColor
     用到shadow的几个属性变化的时候，需要先设置shadow
     */
    NSValue *shadowStartPoint = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    NSValue *shadowEndPoint = [NSValue valueWithCGPoint:CGPointMake(5, 5)];
    id startColor = (id)([UIColor cyanColor].CGColor);
    id endColor = (id)([UIColor redColor].CGColor);
    id shadowStartColor = (id)[UIColor clearColor].CGColor;
    id shadowEndColor = (id)[UIColor redColor].CGColor;
    self.dataSource = [NSMutableArray array];
    NSArray *keypaths   = @[kCARotation,kCARotationX,kCARotationY,kCARotationZ,
                            kCAScale,kCAScaleX,kCAScaleZ,kCAPositionY,
                            kCABoundsSizeW,kCAOpacity,kCABackgroundColor,kCACornerRadius,
                            kCABorderWidth,kCAShadowColor,kCAShadowRadius,kCAShadowOffset];
    
    NSArray *fromValues = @[@0,@0,@0,@0,
                            @0,@0,@0,@0,
                            @100,@1,startColor,@0,
                            @0,shadowStartColor,@0,shadowStartPoint];
    
    NSArray *toValues   = @[@(M_PI),@(M_PI),@(M_PI),@(M_PI),
                            @1,@1,@1,@400,
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
    [self.squareView.layer removeAllAnimations];
    AnimationModel *model = [self.dataSource objectAtIndex:indexPath.row];
    CABasicAnimation *animation = [self getAnimationKeyPath:model.keyPaths fromValue:model.fromValue toValue:model.toValue];
    [self.squareView.layer addAnimation:animation forKey:@"animation"];
}

- (CASpringAnimation *)getAnimationKeyPath:(NSString *)keyPath fromValue:(id)fromValue toValue:(id)toValue{
    CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:keyPath];
    springAnimation.fromValue = fromValue;
    springAnimation.toValue = toValue;
    springAnimation.mass = self.massSlider.value;
    springAnimation.stiffness = self.stiffnessSlider.value;
    springAnimation.damping = self.dampingSlider.value;
    springAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];;
    springAnimation.duration = 2;
    springAnimation.repeatCount = 1;
    /* animation remove from view after animation finish */
    springAnimation.removedOnCompletion = YES;
    /*
     只有当removedOnCompletion设置为no时，fillmode设置为kCAFillModeBoth或者kCAFillModeForwards才有效，
     kCAFillModeRemoved //动画执行完成后回到初始状态
     kCAFillModeBackwards //动画执行完成后回到初始状态
     kCAFillModeForwards //动画执行完成后保留最后状态
     kCAFillModeBoth //动画执行完成后保留最后状态
     */
    springAnimation.fillMode = kCAFillModeForwards;
    /*
     动画执行完成后按原动画返回执行，default no
     */
    //    springAnimation.autoreverses = YES;
    return springAnimation;
}

- (void)durationChange:(UISlider *)slider{
    [slider setValue:slider.value];
    if (slider==self.massSlider) {
        self.massLabel.text = [NSString stringWithFormat:@"mass   %.2f", slider.value];
    }else if (slider==self.stiffnessSlider) {
        self.stiffnessLabel.text = [NSString stringWithFormat:@"stiffness   %.2f", slider.value];
    }else if (slider==self.dampingSlider) {
        self.dampingLabel.text = [NSString stringWithFormat:@"damping   %.2f", slider.value];
    }
}
@end

