//
//  AlbanyTabBarController.swift
//  Albany
//
//  Created by Ebpearls on 10/08/2016.
//  Copyright © 2016 Ashwin. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    @IBOutlet var tabBarView: UIView!
    @IBOutlet weak var tabBarCollectionView: UICollectionView!
   
    var selectedTabIndex = 0
    
    let collectionViewItems = ["Home","Help", "FAQ", "Tutorial"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       // self.navigationController?.interactivePopGestureRecognizer?.enabled = false
       // self.tabBar.hidden = true;
        addTabView()
        let nib = UINib(nibName: "TabBarItem", bundle: NSBundle.mainBundle())
        tabBarCollectionView.registerNib(nib, forCellWithReuseIdentifier: "TabBarItem")
    }
    
    func addTabView() {
        
        NSBundle.mainBundle().loadNibNamed("TabBar", owner: self, options: nil)
        tabBarView.frame = CGRectMake(0, Helper.getScreenHeight()-CGFloat(kTabBarHeight), Helper.getScreenWidth(), CGFloat(kTabBarHeight))
        self.view.addSubview(tabBarView)
        
    }
    
}

//MARK: CollectionView Data Source and Delegate
extension TabBarController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewItems.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let row = indexPath.row
        selectedTabIndex = row
        self.selectedViewController = self.viewControllers![selectedTabIndex]
        collectionView.reloadData()

       
        tabBarIconTaped(selectedTabIndex)
        
        
    }
    
    func tabBarIconTaped(index: Int){
    
//        switch index {
//        case 1:
//            let helpVC = HelpVC(nibName: "HelpVC", bundle: nil)
//            self.navigationController?.pushViewController(helpVC, animated: true)
//        default:
//            break
//        }
        
        
    
    }
    

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let tabBarItem = collectionView.dequeueReusableCellWithReuseIdentifier("TabBarItem", forIndexPath: indexPath) as! TabBarCollectionViewCell
        tabBarItem.configureData(collectionViewItems[indexPath.row], selectedIndex: selectedTabIndex, row: indexPath.row)
        
        return tabBarItem
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let height = collectionView.bounds.size.height
        let width = collectionView.bounds.size.width / CGFloat(collectionViewItems.count)
        return CGSize(width: width, height: height)
    }
    

    
    
}




