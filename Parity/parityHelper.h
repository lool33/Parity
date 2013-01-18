//
//  parityHelper.h
//  Parity
//
//  Created by Laurent GAIDON on 23/11/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_PARITY_BASE_DIRECTORY @"Players Data"
#define DEFAULT_PARITY_PLAYER_NAME @"Player 1"
#define DEFAULT_PARITY_ICON_SET @"default IconSet"


@interface parityHelper : NSObject

@property (nonatomic,strong)NSString *player;
@property (nonatomic,strong)UIManagedDocument *dataBase;
@property (nonatomic,strong)NSFileManager *fileManager;



+(NSArray *)getPlayers;


+(parityHelper *)sharedPlayer:(NSString *)playerName;


+(void)openplayer:(NSString *)player
       usingBlock:(void (^)(BOOL success))block;


+(void)deletePlayer:(NSString *)player;

+(void)createTestDatabase;

@end
