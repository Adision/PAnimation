//
//  AnimationModel.h
//  PAnimation
//
//  Created by os on 2019/1/24.
//  Copyright © 2019年 os. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationModel : NSObject

@property(nonatomic,copy)NSString*keyPaths;
@property(nonatomic,strong)id fromValue;
@property(nonatomic,strong)id toValue;

@end
