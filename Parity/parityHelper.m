//
//  parityHelper.m
//  Parity
//
//  Created by Laurent GAIDON on 23/11/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import "parityHelper.h"
#import "FlickrFetcher.h"
#import "Icon+Fetch.h"

@interface parityHelper ()

@property(nonatomic,strong)NSURL *baseDirectory;

@end


@implementation parityHelper


@synthesize player = _player;
@synthesize dataBase = _dataBase;
@synthesize fileManager = _fileManager;
@synthesize baseDirectory = _baseDirectory;

#pragma mark - Setters And getters

-(NSFileManager *)fileManager
{
    if(!_fileManager)
    {
        _fileManager = [[NSFileManager alloc]init];
        
    }
    
    return _fileManager;
}



//property that provide the base directory of all the database
-(NSURL *)baseDirectory
{
    if(!_baseDirectory){
        
        NSFileManager *fm = self.fileManager;
        _baseDirectory = [[[fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:DEFAULT_PARITY_BASE_DIRECTORY isDirectory:YES];
        
        BOOL isDir = NO;
        NSError *error;
        if(![fm fileExistsAtPath:[_baseDirectory path] isDirectory:&isDir] || !isDir){
            //if the directory is not a directory or if the directory does not exist then create it
            [fm createDirectoryAtURL:_baseDirectory
         withIntermediateDirectories:YES
                          attributes:nil
                               error:&error];
        }
        if(error) return nil;
        
    }
    return _baseDirectory;
}


-(UIManagedDocument *)dataBase;
{
        
        if(!_dataBase)
        {
            NSLog(@"player is:%@",self.player);
            
            _dataBase = [[UIManagedDocument alloc]initWithFileURL:[self.baseDirectory URLByAppendingPathComponent:self.player]];
        }
        
        return _dataBase;
        
    
        
        
        /*
        NSURL *documentURL = [self.baseDirectory URLByAppendingPathComponent:self.player];
        _dataBase = [[UIManagedDocument alloc]initWithFileURL:documentURL];
        //we can set here the persistent store option with a dictionnary
        
        
        
        
        
        if([self.fileManager fileExistsAtPath:[documentURL path]])
           {
               
               
               [_dataBase openWithCompletionHandler:^(BOOL success) {
                   if(!success){
                       NSLog(@"error opening the database, its status is: %@",_dataBase.description);

                   }
               }];
               
               
               
           }else{
               
               NSLog(@"the database will be now created");
               //here we should create the base

               
               NSLog(@"%@",_dataBase.description);
               
               //create the file on the flash
               [_dataBase saveToURL:[self.baseDirectory URLByAppendingPathComponent:self.player] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
                   if(!success) NSLog(@"the databse saving operation crashed");
                   if(success) NSLog(@"the database is now saved");
               }];
                        
           }
    }
    return _dataBase;
         */
}



#pragma mark - class Method

+(NSArray *)getPlayers
{
    NSFileManager *fm = [[NSFileManager alloc]init];
    
    NSURL *directory = [[[fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:DEFAULT_PARITY_BASE_DIRECTORY isDirectory:YES];
    
    BOOL isDir = NO;
    NSError *error;
    
    if(![fm fileExistsAtPath:[directory path] isDirectory:&isDir] || !isDir)
    {
        [fm createDirectoryAtURL:directory
     withIntermediateDirectories:YES
                      attributes:nil
                           error:&error];
        
    }
    
    if(error) return nil;
    
    
    //code intended to retrieve the files in the directory
    NSArray *files = [fm contentsOfDirectoryAtURL:directory
                       includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey]
                                          options:NSDirectoryEnumerationSkipsHiddenFiles
                                            error:&error];
    
    
    if(error) return nil;
    
    //code intended to retrieve the file name
    NSString *name;
    NSMutableArray *players = [[NSMutableArray alloc]initWithCapacity:[files count]];
    
    for(NSURL *url in files)
    {
        [url getResourceValue:&name forKey:NSURLNameKey error:&error];
        if(error) continue;
        [players addObject:name];
        
    }
    
    if([players count]) return players;
    
    return [NSArray arrayWithObject:DEFAULT_PARITY_PLAYER_NAME];

}


+(parityHelper *)sharedPlayer:(NSString *)playerName
{
    
    static dispatch_once_t pred = 0;
    __strong static parityHelper *_sharedPlayer = nil;
    dispatch_once(&pred, ^{
        _sharedPlayer = [[self alloc] init];
    });
    
    if (playerName && ![playerName isEqualToString:_sharedPlayer.player]) {
        if (_sharedPlayer.player)
            _sharedPlayer.dataBase = nil;
        _sharedPlayer.player = playerName;
    }
    return _sharedPlayer;
}


+(void)openplayer:(NSString *)player
       usingBlock:(void (^)(BOOL success))block
{
    parityHelper *ph = [parityHelper sharedPlayer:player];
    if(!player && !ph.player) ph.player = DEFAULT_PARITY_PLAYER_NAME;
    
    
    if(![ph.fileManager fileExistsAtPath:[ph.dataBase.fileURL path]])
    {
        //file doesn't exist, create it
        [ph.dataBase saveToURL:ph.dataBase.fileURL
              forSaveOperation:UIDocumentSaveForCreating
             completionHandler:block];
        
    }else if(ph.dataBase.documentState == UIDocumentStateClosed){
        //file is close, open it
        [ph.dataBase openWithCompletionHandler:block];
        
    }else{
        //any other case
        BOOL success = YES;
        block(success);
    }

}


+(void)deletePlayer:(NSString *)player
{
    parityHelper *ph = [parityHelper sharedPlayer:player];
    
    if([ph.fileManager fileExistsAtPath:[ph.dataBase.fileURL path]]){
        //so the file to delete exist, so we delete it
        
        NSError *error;
        [ph.fileManager removeItemAtURL:ph.dataBase.fileURL error:&error];
        
        if(error) NSLog(@"error in deleting the requested file: %@",player);
        
    }
    
}

+(void)createTestDatabase
{
    
    parityHelper *ph = [parityHelper sharedPlayer:DEFAULT_PARITY_PLAYER_NAME];
    
    if([ph.fileManager fileExistsAtPath:[ph.dataBase.fileURL path]]){
        ph.dataBase = nil;
        return;
    }
    
    NSArray *icons = [FlickrFetcher recentGeoreferencedPhotos];
    [parityHelper openplayer:DEFAULT_PARITY_PLAYER_NAME usingBlock:^(BOOL success) {
       
        for(NSMutableDictionary *icon in icons)
        {
            [icon setObject:[icon objectForKey:@"place_id"] forKey:FLICKR_PHOTO_PLACE_NAME];
            [Icon iconForFlickrInfo:icon inManagedObjectContext:ph.dataBase.managedObjectContext];
        }
        //now save the database to the flash
        [ph.dataBase saveToURL:ph.dataBase.fileURL
              forSaveOperation:UIDocumentSaveForCreating
             completionHandler:nil];
        
    }];
    
    
}

@end
