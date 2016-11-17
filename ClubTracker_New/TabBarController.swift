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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.navigationController?.interactivePopGestureRecognizer?.enabled = false
       // self.tabBar.hidden = true;
        addTabView()
        let nib = UINib(nibName: "TabBarItem", bundle: Bundle.main)
        tabBarCollectionView.register(nib, forCellWithReuseIdentifier: "TabBarItem")
    }
    
    func addTabView() {
        
        Bundle.main.loadNibNamed("TabBar", owner: self, options: nil)
        tabBarView.frame = CGRect(x: 0, y: Helper.getScreenHeight()-CGFloat(kTabBarHeight), width: Helper.getScreenWidth(), height: CGFloat(kTabBarHeight))
        self.view.addSubview(tabBarView)
        
    }
    
}

//MARK: CollectionView Data Source and Delegate
extension TabBarController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let row = indexPath.row
        selectedTabIndex = row
        self.selectedViewController = self.viewControllers![selectedTabIndex]
        collectionView.reloadData()

       
        tabBarIconTaped(selectedTabIndex)
        
        
    }
    
    func tabBarIconTaped(_ index: Int){
    
//        switch index {
//        case 1:
//            let helpVC = HelpVC(nibName: "HelpVC", bundle: nil)
//            self.navigationController?.pushViewController(helpVC, animated: true)
//        default:
//            break
//        }
        
        
    
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let tabBarItem = collectionView.dequeueReusableCell(withReuseIdentifier: "TabBarItem", for: indexPath) as! TabBarCollectionViewCell
        tabBarItem.configureData(collectionViewItems[indexPath.row], selectedIndex: selectedTabIndex, row: indexPath.row)
        
        return tabBarItem
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.bounds.size.height
        let width = collectionView.bounds.size.width / CGFloat(collectionViewItems.count)
        return CGSize(width: width, height: height)
    }
    

    
    
}




