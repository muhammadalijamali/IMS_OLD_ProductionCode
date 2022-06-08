//
//  KeychainMethods.h
//  vpn
//
//  Created by Muhammad Ali on 10/4/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainMethods : NSObject
-(NSMutableDictionary *)newSearchDictionary:(NSString *)identifier;
- (NSData *)searchKeychainCopyMatching:(NSString *)identifier;
- (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier;
+ (void) storeData: (NSString * )key data:(NSString *)value;

+ (NSData *) getData: (NSString *)key ;

+ (void)deleteAllKeychain;




@end
