//
//  TodayViewController.swift
//  widget
//
//  Created by Taichi Kato on 27/8/16.
//  Copyright © 2016 Taichi Kato. All rights reserved.
//

import UIKit
import NotificationCenter
var area = "null"
var i = 0
var nationalPSI = "000"
class TodayViewController: UIViewController, NCWidgetProviding, XMLParserDelegate {
    @IBOutlet weak var psi: UILabel!
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view from its nib.
        loadxml()
        psi.text = nationalPSI
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadxml(){
        let url_text = "http://api.nea.gov.sg/api/WebAPI/?dataset=psi_update&keyref=781CF461BB6606AD0308169EFFAA82314F88CE06E5BB1E82"
        
        guard let url = URL(string: url_text) else{
            return
        }
        
        guard let parser = XMLParser(contentsOf: url) else{
            return
        }
        parser.delegate = self;
        parser.parse()
    }
    // Method that will get exectued when parsing starts
    func parserDidStartDocument(_ parser: XMLParser) {
        print("Started XML Parsing")
    }
    
    // Mehod executed when there is start tag
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "reading"{
            if attributeDict["type"] == "NPSI_PM25_3HR"{
                let PSIValue = attributeDict["value"]! as String
                print(i)
                switch i {
                case 0:
                    area = "North"
                case 1:
                    area = "NRS"
                    nationalPSI = PSIValue
                case 2:
                    area = "South"
                case 3:
                    area = "Central"
                case 4:
                    area = "West"
                case 5:
                    area = "East"
                default:
                    area = ""
                }
                i += 1
                print(area, ":", PSIValue)
            }
            psi.text = nationalPSI
            
        }
    }
    //Method executed when parsing ends
    func parserDidEndDocument(_ parser: XMLParser) {
        print("Ended XML Parsing")
    }
    
    // Method that will be excuted when there is an error parsing XML
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Error =>" + parseError.localizedDescription)
    }
    
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    
}
