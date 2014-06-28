//
//  SessionHelper.m
//  P2PTest
//
//  Created by KAKEGAWA Atsushi on 2013/10/05.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
//

#import "SessionHelper.h"

@interface SessionHelper () <MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate>

@property (nonatomic) MCNearbyServiceAdvertiser *advertiserAssistant;
@property (nonatomic) MCNearbyServiceBrowser *nearbySBrowser;
@property (nonatomic) MCPeerID *myPeerID;

@end

@implementation SessionHelper

#pragma mark - Accessor methods

- (NSUInteger)connectedPeersCount
{
    return self.connectedPeerIDs.count;
}

#pragma mark - Lifecycle methods

- (instancetype)initWithCreateRoom:(NSString *)roomName WithPlayerName:(NSString *)playerName;
{
    self = [super init];
    if (self) {
        self.connectedPeerIDs = [NSMutableArray new];
        
        _myPeerID = [[MCPeerID alloc] initWithDisplayName:playerName];
        _session = [[MCSession alloc] initWithPeer:_myPeerID];
        _session.delegate = self;
        self.serviceType = roomName;
        self.advertiserAssistant = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_myPeerID discoveryInfo:nil serviceType:_serviceType];
        _advertiserAssistant.delegate = self;
        [_advertiserAssistant startAdvertisingPeer];
        
        _nearbySBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:_myPeerID serviceType:self.serviceType];
        _nearbySBrowser.delegate = self;
        [_nearbySBrowser startBrowsingForPeers];
    }
    return self;
}

- (instancetype)initWithJoinRoom:(NSString *)roomName WithPlayerName:(NSString *)playerName
{
    self = [super init];
    if (self) {
        self.connectedPeerIDs = [NSMutableArray new];
        
        _myPeerID = [[MCPeerID alloc] initWithDisplayName:playerName];
        _session = [[MCSession alloc] initWithPeer:_myPeerID];
        _session.delegate = self;
        self.serviceType = roomName;
        self.advertiserAssistant = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_myPeerID discoveryInfo:@{@"master":@"1"} serviceType:_serviceType];
        _advertiserAssistant.delegate = self;
        [self.advertiserAssistant startAdvertisingPeer];
        
        _nearbySBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:_myPeerID serviceType:self.serviceType];
        _nearbySBrowser.delegate = self;
        [_nearbySBrowser startBrowsingForPeers];
    }
    return self;
}

- (void)dealloc
{
    [self.advertiserAssistant stopAdvertisingPeer];
    [self.nearbySBrowser stopBrowsingForPeers];
    [self.session disconnect];
}

#pragma mark - MCSessionDelegate methods

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    if (state == MCSessionStateConnected) {
        if (![self.connectedPeerIDs containsObject:peerID]) {
            [self.connectedPeerIDs addObject:peerID];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate sessionHelperDidAddPeers:self addedPeer:peerID];
            });
        }
    } else {
        if ([self.connectedPeerIDs containsObject:peerID]) {
            [self.connectedPeerIDs removeObject:peerID];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate sessionHelperDidRemovePeers:self removedPeer:peerID];
            });
        }
    }
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate sessionHelperDidRecieveData:data peer:peerID];
    });
}

- (void)session:(MCSession *)session
didStartReceivingResourceWithName:(NSString *)resourceName
       fromPeer:(MCPeerID *)peerID
   withProgress:(NSProgress *)progress
{
    // Do nothing
}

- (void)session:(MCSession *)session
didFinishReceivingResourceWithName:(NSString *)resourceName
       fromPeer:(MCPeerID *)peerID
          atURL:(NSURL *)localURL
      withError:(NSError *)error
{
    // Do nothing
}

- (void)session:(MCSession *)session
didReceiveStream:(NSInputStream *)stream
       withName:(NSString *)streamName
       fromPeer:(MCPeerID *)peerID
{
    // Do nothing
}

#pragma mark - Public methods

- (MCPeerID *)connectedPeerIDAtIndex:(NSUInteger)index
{
    if (index >= self.connectedPeerIDs.count) {
        return nil;
    }
    
    return self.connectedPeerIDs[index];
}

- (void)sendData:(NSData *)data toPeerID:(MCPeerID *)peerID
{
    NSError *error;
    [self.session sendData:data
                   toPeers:@[peerID]
                  withMode:MCSessionSendDataReliable
                     error:&error];
    if (error) {
        NSLog(@"Failed %@", error);
    }
}

- (void)sendData:(NSData *)data toPeerIDs:(NSArray *)peerIDs
{
    NSError *error;
    [self.session sendData:data
                   toPeers:peerIDs
                  withMode:MCSessionSendDataReliable
                     error:&error];
    if (error) {
        NSLog(@"Failed %@", error);
    }
}

- (void)sendDataToAll:(NSData *)data
{
    NSError *error;
    [self.session sendData:data
                   toPeers:self.connectedPeerIDs
                  withMode:MCSessionSendDataReliable
                     error:&error];
    if (error) {
        NSLog(@"Failed %@", error);
    }
}

#pragma mark - MCNearbyServiceBrowserDelegate methods

// Found a nearby advertising peer
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    [browser invitePeer:peerID toSession:_session withContext:nil timeout:60*60];
}

// A nearby peer has stopped advertising
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    
}

#pragma mark - MCNearbyServiceAdvertiserDelegate methods

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    invitationHandler(YES, _session);
}

// Advertising did not start due to an error
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    
}

@end
