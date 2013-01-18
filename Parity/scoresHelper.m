//
//  scoresHelper.m
//  Parity
//
//  Created by Laurent GAIDON on 21/11/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import "scoresHelper.h"

@implementation scoresHelper


+(NSArray *)scoresOfPlayer:(NSString *)player
            inGlobalScores:(NSDictionary *)scores
{
 
    NSMutableArray *playerScores = [scores objectForKey:player];
    
    if(!playerScores) return nil;
    
    return [playerScores sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
}


+(void)saveScore:(NSNumber *)score
       ForPlayer:(NSString *)player
        forLevel:(NSString *)level
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *scores = [defaults objectForKey:GAME_SCORES];
    
    if(!scores) scores = [NSDictionary dictionary];
    
    
    NSMutableDictionary *scoresForLevel = [scores objectForKey:level];

    NSMutableArray *playerScores = [[self scoresOfPlayer:player inGlobalScores:scoresForLevel] mutableCopy];
    
    [playerScores insertObject:score atIndex:0];
    [scoresForLevel setObject:playerScores forKey:player];
    [scores setValue:scoresForLevel forKey:level];
    
    
    [defaults setObject:scores forKey:GAME_SCORES];
    [defaults synchronize];

}


+(NSDictionary *)scoresForLevel:(NSString *)level
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *scores = [defaults objectForKey:GAME_SCORES];
    
    return [scores objectForKey:level];
    
}



@end
