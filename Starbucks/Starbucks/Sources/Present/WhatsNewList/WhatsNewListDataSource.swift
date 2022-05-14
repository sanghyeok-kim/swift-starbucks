//
//  WhatsNewListDataSource.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/14.
//

import UIKit

class WhatsNewListDataSource: NSObject, UITableViewDataSource {
    private var events: [StarbucksEntity.Event] = []
    
    func updateEvents(_ events: [StarbucksEntity.Event]) {
        self.events = events
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WhatsNewListViewCell.identifier, for: indexPath) as? WhatsNewListViewCell else {
            return UITableViewCell()
        }
        
        let event = events[indexPath.item]
        cell.setTitle(event.title)
        cell.setDate(event.newsDate)
        cell.setThumbnail(event.thumbnail.isEmpty ? nil : event.thumbnailUrl)
        return cell
    }
}
