//
//  IconSet+Fetch.h
//  Parity
//
//  Created by Laurent GAIDON on 23/11/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import "IconSet.h"

@interface IconSet (Fetch)


+(NSArray *)iconsSetInManagedObjectContext:(NSManagedObjectContext *)context;

+(IconSet *)singleIconSetInManagedObjectContext:(NSManagedObjectContext *)context
                                       withName:(NSString *)name;



@end
