//
//  Score.h
//  Parity
//
//  Created by Laurent GAIDON on 27/11/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IconSet;

@interface Score : NSManagedObject

@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSString * player;
@property (nonatomic, retain) IconSet *iconSet;

@end
