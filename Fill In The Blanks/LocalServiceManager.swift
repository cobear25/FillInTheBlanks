//
//  LocalServiceManager.swift
//  Fill In The Blanks
//
//  Created by Cody Mace on 2/15/18.
//  Copyright © 2018 Cody Mace. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol LocalServiceDelegate {
    func connectedDevicesChanged(manager : LocalServiceManager, connectedDevices: [String])
}

class LocalServiceManager: NSObject {
    private let serviceType = "fill-in-blanks"

    private let myPeerId = MCPeerID(displayName: UserDefaults.standard.string(forKey: "displayname") ?? UIDevice.current.name)
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    private let serviceBrowser : MCNearbyServiceBrowser

    var delegate: LocalServiceDelegate?

    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    static let shared = LocalServiceManager()

    override init() {
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        super.init()
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()

        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
    }

    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
    
    func stop() {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }

    func host() {

    }

    func join() {

    }

    private func sendData(data: Data, name: String) {

        if session.connectedPeers.count > 0 {
            do {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            }
            catch {
                print("failed to send: \(name), \n error:\(error)")
            }
        }
    }

    func sendString(string: String) {
        sendData(data: string.data(using: .utf8)!, name: "string")
    }

    // sends an updated name for the other players to see instead of the peerId's displayName
    func updateName(name: String) {
        let dict = [EventKey.updateName: name]
        let data = NSKeyedArchiver.archivedData(withRootObject: dict)
        sendData(data: data, name: "updated name")
    }

    // informs the other players that the game is starting
    func startGame() {
        let dict = [EventKey.startGame: true]
        let data = NSKeyedArchiver.archivedData(withRootObject: dict)
        sendData(data: data, name: "start game")
    }

    // send a new message out to the game
    func sendMessage(message: String) {
        let dict = [EventKey.sendMessage: message]
        let data = NSKeyedArchiver.archivedData(withRootObject: dict)
        sendData(data: data, name: "sent message")
    }
}

extension LocalServiceManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("failed to advertise: \(error)")
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("got invitation: \(myPeerId)")

        // accept the invitation then send the avatar
        invitationHandler(true, session)
        sendData(data: NSKeyedArchiver.archivedData(withRootObject: [EventKey.avatarIndex : UserDefaults.standard.integer(forKey: EventKey.avatarIndex)]), name: "avatar index")
    }
}

extension LocalServiceManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("found peer: \(peerID)")
        print("inviting peer: \(peerID)")
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lost peer: \(peerID)")
    }
}

extension LocalServiceManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("peer: \(peerID) changed state: \(state)")
        self.delegate?.connectedDevicesChanged(manager: self, connectedDevices: session.connectedPeers.map { $0.displayName })
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : Any] {
            for (k, v) in dict {
                switch k {
                case EventKey.updateName:
                    print("new name \(v) from peer \(peerID)")
                case EventKey.startGame:
                    print("start game!")
                case EventKey.sendMessage:
                    print("message: \(v), sent from peer \(peerID)")
                case EventKey.avatarIndex:
                    print("avatar name: \(v) from peer \(peerID)")
                default:
                    break
                }
            }
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
}
