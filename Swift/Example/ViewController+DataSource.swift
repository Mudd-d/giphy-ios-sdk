//
//  ViewController+DataSource.swift
//  Example
//
//  Created by Jonny Mclaughlin on 3/20/19.
//  Copyright © 2019 GIPHY. All rights reserved.
//

import UIKit
import GiphyUISDK

enum ChatUser: Int {
    case abraHam
    case sueRender
    
    var avatar: GiphyYYImage? {
        switch self {
        case .abraHam: return GiphyYYImage(contentsOfFile: Bundle.main.path(forResource: "abraham", ofType: "gif") ?? "")
        case .sueRender: return GiphyYYImage(contentsOfFile: Bundle.main.path(forResource: "suerender", ofType: "gif") ?? "")
        }
    }
    
    var isMe: Bool {
        switch self {
        case .abraHam: return false
        case .sueRender: return true
        }
    }
}

struct ChatMessage {
    var text: String?
    var user: ChatUser
    var media: GPHMedia?
    var playClipOnLoad: Bool = false
    
    init(text: String? = "", user: ChatUser, media: GPHMedia? = nil, playClipOnLoad: Bool = false) {
        self.text = text
        self.user = user
        self.media = media
        self.playClipOnLoad = playClipOnLoad
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let genericCell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCell.id, for: indexPath)
        guard let cell = genericCell as? ChatCell else { return genericCell }
        let message = conversation[indexPath.item]
        cell.videoPlayer = videoPlayer
        cell.clipsPlaybackSetting = settingsViewController.clipsPlaybackSetting
        cell.playClipOnLoad = message.playClipOnLoad
        cell.media = message.media
        // To ensure we don't start playing it every time the cell becomes visible.
        conversation[indexPath.item].playClipOnLoad = false
        cell.text = message.text
        cell.avatarImage = message.user.avatar
        cell.isReply = message.user == .abraHam
        cell.theme = settingsViewController.theme
        cell.imageView.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return conversation.count
    }
}
