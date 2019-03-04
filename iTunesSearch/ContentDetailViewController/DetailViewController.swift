//
//  DetailViewController.swift
//  iTunesSearch
//
//  Created by Ulaş Sancak on 4.03.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import UIKit
import Kingfisher

protocol DetailViewControllerDelegate: class {
    
    func detailViewController(detailViewController: DetailViewController, deleteContentFor viewModel: ContentViewModel)
    
}

class DetailViewController: UIViewController {
    
    static let segueIdentifier = "detail"
    
    var viewModel: ContentViewModel!
    
    @IBOutlet weak var contentView: ContentView!
    
    weak var delegate: DetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewModel.load(view: self.contentView)
        do {
            try self.viewModel.read()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func deleteContent(_ sender: Any) {
        let alertController = UIAlertController(title: NSLocalizedString("Content Deletion", comment: ""), message: NSLocalizedString("Are you sure to delete this content from the search list?", comment: ""), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive, handler: { (action) in
            self.delegate?.detailViewController(detailViewController: self, deleteContentFor: self.viewModel)
        }))
        self.present(alertController, animated: true, completion: nil)
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
