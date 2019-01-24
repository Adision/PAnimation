//
//  ViewController.m
//  PAnimation
//
//  Created by os on 2019/1/24.
//  Copyright © 2019年 os. All rights reserved.
//

#import "ViewController.h"

#import "BaseAnimationView.h"
#import "SpringAnimationView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    BaseAnimationView*animationView=[[BaseAnimationView alloc]init];
//    [self.view addSubview:animationView];
    
        SpringAnimationView*springAnimationView=[[SpringAnimationView alloc]init];
        [self.view addSubview:springAnimationView];
}



@end
