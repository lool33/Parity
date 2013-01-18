//
//  photosForPlacesTVC.h
//  Parity
//
//  Created by Laurent GAIDON on 27/10/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "commonTableViewController.h"

@interface photosForPlacesTVC : commonTableViewController

@property(nonatomic,strong)NSDictionary *place;
@property(nonatomic,strong)NSArray *photos;

@end
