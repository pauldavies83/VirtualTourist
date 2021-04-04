//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Paul Davies on 04/04/2021.
//

import UIKit

class PhotoAlbumViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
     
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

}
