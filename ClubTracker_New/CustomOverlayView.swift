//
//  CustomOverlayView.swift
//  CustomCamera
//
//  Created by Mohan Singh Thagunna on 11/13/16.
//  Copyright © 2016 CreatuDevelopers. All rights reserved.
//
import UIKit

protocol CustomOverlayDelegate{
  //  func didCancel(overlayView:CustomOverlayView)
    func libraryShow()
  
}

class CustomOverlayView: UIView {

    var delegate:CustomOverlayDelegate! = nil

    @IBAction func libraryTapped(_ sender: Any) {
        delegate.libraryShow()
    }
  
   
}
