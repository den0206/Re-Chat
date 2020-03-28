//
//  Page1.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/16.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import SegementSlide

private let reuserIdentifer = "Cell"
class Page1 : UITableViewController {
    
    var parser = XMLParser()
    var newsItems = [NewsItems]()
    
    var currentElementName : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .clear
        
        // set image
        
        let image = UIImage(named: "0")
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height))
        iv.image = image
        
        self.tableView.backgroundView = iv
        
        let urlString : String = "https://news.yahoo.co.jp/pickup/rss.xml"
        let url : URL = URL(string: urlString)!
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.parse()
        
        print(newsItems.count)
        
    }
    
    
}

//MARK: - Table View Delegate

extension Page1  {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height / 5
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newsItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuserIdentifer)
       
        
        let newsItem = newsItems[indexPath.row]
        cell.textLabel?.text = newsItem.title
        cell.detailTextLabel?.text = newsItem.url
        
        return cell

        
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = .clear
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.textLabel?.textColor = .white
    
    
        cell.detailTextLabel?.textColor = .white
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let webVC = WebViewController()
        
        webVC.modalTransitionStyle = .crossDissolve
        let newsItem = newsItems[indexPath.row]
        
        UserDefaults.standard.set(newsItem.url, forKey: "url")
        
        self.present(webVC, animated: true, completion: nil)
        
    }
    
    
}

//MARK: - XML ParserDelegate

extension Page1 : XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElementName = nil
        
        if elementName == "item" {
            self.newsItems.append(NewsItems())
        } else {
            currentElementName = elementName
        }
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if self.newsItems.count > 0 {
            
            let lastItem = self.newsItems[self.newsItems.count - 1]
            
            switch self.currentElementName {
            case "title":
                lastItem.title = string
            case "link" :
                lastItem.url = string
            case "pubDate" :
                lastItem.pubDate = string
            default :
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        self.currentElementName = nil
        
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.tableView.reloadData()
    }
}


extension Page1 : SegementSlideContentScrollViewDelegate {
    
    @objc var scrollView: UIScrollView {
           return tableView
       }
    
}
