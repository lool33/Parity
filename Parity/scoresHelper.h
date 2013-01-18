//
//  scoresHelper.h
//  Parity
//
//  Created by Laurent GAIDON on 21/11/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GAME_SCORES @"scores"

#define GAME_LEVEL_EASY @"easy"
#define GAME_LEVEL_MEDIUM @"medium"
#define GAME_LEVEL_HARD @"hard"


@interface scoresHelper : NSObject


+(NSDictionary *)scoresForLevel:(NSString *)level;

+(void)saveScore:(NSNumber *)score
       ForPlayer:(NSString *)player
        forLevel:(NSString *)level;





@end
