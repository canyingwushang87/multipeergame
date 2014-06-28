//
//  SessionHelper.h
//  P2PTest
//
//  Created by KAKEGAWA Atsushi on 2013/10/05.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MultipeerConnectivity;

@class SessionHelper;

@protocol SessionHelperDelegate <NSObject>

@required
- (void)sessionHelperDidChangeConnectedPeers:(SessionHelper *)sessionHelper;
- (void)sessionHelperDidRecieveData:(NSData *)data peer:(MCPeerID *)peerID;

@end

@interface SessionHelper : NSObject

@property (nonatomic, readonly) MCSession *session;
@property (nonatomic, retain) NSString *serviceType;
@property (nonatomic, readonly) NSUInteger connectedPeersCount;
@property (nonatomic, weak) id <SessionHelperDelegate> delegate;

- (instancetype)initWithCreateRoom:(NSString *)roomName WithPlayerName:(NSString *)playerName;
- (instancetype)initWithJoinRoom:(NSString *)roomName WithPlayerName:(NSString *)playerName;
- (MCPeerID *)connectedPeerIDAtIndex:(NSUInteger)index;
- (void)sendData:(NSData *)data toPeerID:(MCPeerID *)peerID;
- (void)sendData:(NSData *)data toPeerIDs:(NSArray *)peerIDs;
- (void)sendDataToAll:(NSData *)data;

@end
