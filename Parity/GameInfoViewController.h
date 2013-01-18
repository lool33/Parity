//
//  GameInfoViewController.h
//  Parity
//
//  Created by Laurent GAIDON on 10/11/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconSet+Fetch.h"

#define SCORES @"Scores"
#define Level_Easy @"easy"
#define Level_Medium @"medium"
#define Level_Hard @"hard"

@interface GameInfoViewController : UIViewController



@property(nonatomic,strong)IconSet *iconSet;
@property(nonatomic,strong)NSString *player;


@end
