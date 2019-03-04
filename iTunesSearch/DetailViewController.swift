//
//  DetailViewController.swift
//  iTunesSearch
//
//  Created by Ulaş Sancak on 4.03.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    static let segueIdentifier = "detail"
    
    var viewModel: ContentViewModel!
    
    @IBOutlet weak var contentView: ContentView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewModel.load(view: self.contentView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
