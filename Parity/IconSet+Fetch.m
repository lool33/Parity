//
//  IconSet+Fetch.m
//  Parity
//
//  Created by Laurent GAIDON on 23/11/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import "IconSet+Fetch.h"

@implementation IconSet (Fetch)

+(NSArray *)iconsSetInManagedObjectContext:(NSManagedObjectContext *)context
{
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"IconSet"];
    NSError *error;
    
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    return matches;
    
    
}


+(IconSet *)singleIconSetInManagedObjectContext:(NSManagedObjectContext *)context
                                       withName:(NSString *)name
{
    
    
    IconSet *iconSet;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"IconSet"];
    request.predicate = [NSPredicate predicateWithFormat:@"IconSet.name = %@",name];
    
    NSError *error;
    
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1 || error){
     //error or mulitple entry
        
        NSLog(@"Error with request for IconSet entity name search: %@ %@", matches, error);
        
    }else if([matches count] == 0){
     //no match found
        iconSet = [NSEntityDescription insertNewObjectForEntityForName:@"IconSet" inManagedObjectContext:context];
        
    
    }else{
        //iconSet Found
        
        iconSet = [matches lastObject];
        
    }
    
    return iconSet;
}


@end
