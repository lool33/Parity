//
//  Icon.h
//  Parity
//
//  Created by Laurent GAIDON on 26/11/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IconSet;

@interface Icon : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSSet *iconSet;
@end

@interface Icon (CoreDataGeneratedAccessors)

- (void)addIconSetObject:(IconSet *)value;
- (void)removeIconSetObject:(IconSet *)value;
- (void)addIconSet:(NSSet *)values;
- (void)removeIconSet:(NSSet *)values;

@end
