//
//  Score+Fetch.m
//  Parity
//
//  Created by Laurent GAIDON on 26/11/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import "Score+Fetch.h"


@implementation Score (Fetch)


+(Score *)scoreForIconSet:(IconSet *)iconsSet
   inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    Score *score;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Score"];
    request.predicate = [NSPredicate predicateWithFormat:@"Score.iconSet = %@", iconsSet];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1){
        //multiple entry in the base or matches in error something strange to manage
NSLog(@"Error in placeFromPhoto: %@ %@", matches, error);
        
    }else if(![matches count]){
        //no match found in the db so we can create the score object(entity) and set its attribute
        score = [NSEntityDescription insertNewObjectForEntityForName:@"Score" inManagedObjectContext:context];
        score.player = context.description;
        score.iconSet = iconsSet;
        //should do something like:
        //score.time = toto;
        //but we have to think were we should bring back toto here
        
    }else{
        //found a correct match so doesn't add the place object
        score = [matches lastObject];
        if(!score.iconSet) score.iconSet = iconsSet;
        
    }
    
    return score;
    
}

@end
