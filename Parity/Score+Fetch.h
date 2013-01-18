//
//  Score+Fetch.h
//  Parity
//
//  Created by Laurent GAIDON on 26/11/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import "Score.h"

@interface Score (Fetch)

+(Score *)scoreForIconSet:(IconSet *)iconsSet
    inManagedObjectContext:(NSManagedObjectContext *)context;


@end
