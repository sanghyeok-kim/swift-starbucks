//
//  WhatsNewDataSource.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/12.
//

import UIKit

class WhatsNewDataSource: NSObject, UICollectionViewDataSource {
    private var events: [StarbucksEntity.Event] = []
    
    func updateEvents(_ events: [StarbucksEntity.Event]) {
        self.events = events
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WhatsNewCellView.identifier, for: indexPath) as? WhatsNewCellView else {
            return UICollectionViewCell()
        }
        
        let event = events[indexPath.item]
        cell.setTitle(event.title)
        cell.setThumbnail(uploadPath: event.imageUploadPath, thumbnailName: event.thumbnail)
        return cell
    }
}
