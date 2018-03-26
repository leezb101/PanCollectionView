//
//  ViewController.swift
//  PanCollectionView
//
//  Created by leezb101 on 2017/5/19.
//  Copyright © 2017年 AsiaInfo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var flowLayout: UICollectionViewFlowLayout?
    var collectionview: UICollectionView!
    var cellWidth: CGFloat?
    var firstSecArr: [String] = [String]()
    var secondSecArr: [String] = [String]()
    var dragingCell: TestCell?
    var dragingIp: IndexPath?
    var targetIp: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildDataArr()
        buildUI()
        addLongPressGesture()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Did receiveMemory Warning...!!!")
        // Dispose of any resources that can be recreated.
    }
    
    func buildDataArr() {
        for i in 0...8 {
            firstSecArr.append("S0R\(i)")
            secondSecArr.append("S1R\(i)")
        }
    }
    
    func buildUI() {
        
        cellWidth = ((view.bounds.width) - 2 * 10 + 4 * 4) / 5
        flowLayout = UICollectionViewFlowLayout()
        
        flowLayout!.itemSize = CGSize(width: cellWidth!, height: cellWidth!)
        flowLayout!.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        flowLayout!.minimumLineSpacing = 5
        flowLayout!.minimumInteritemSpacing = 4
        flowLayout!.headerReferenceSize = CGSize(width: view.bounds.width, height: 50)
        
        collectionview = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout!)
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.backgroundColor = UIColor.clear
        collectionview.register(TestCell.self, forCellWithReuseIdentifier: "TestCell")
        collectionview.delegate = self
        collectionview.dataSource = self
        
        view.addSubview(collectionview)
    }
    
    func addLongPressGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        longPress.minimumPressDuration = 0.3
        collectionview.addGestureRecognizer(longPress)
        
        dragingCell = TestCell(frame: CGRect(x: 0, y: 0, width: cellWidth!, height: cellWidth!))
        dragingCell!.isHidden = true
        collectionview.addSubview(dragingCell!)
    }
    
    
}

extension ViewController {
    func longPress(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            dragBegin(gesture: gesture)
        case .changed:
            dragChanged(gesture: gesture)
        case .ended:
            dragEnd(gesture: gesture)
        default:
            break
        }
    }
    
    func dragBegin(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: collectionview)
        dragingIp = getDragingIndexPathWith(point: point)
        if let draging = dragingIp {
            print("begin draging indexPath = \(draging)")
            
            collectionview.bringSubview(toFront: dragingCell!)
            dragingCell!.frame = collectionview.cellForItem(at: draging)!.frame
            dragingCell!.isHidden = false
            
            UIView.animate(withDuration: 0.3, animations: { 
                self.dragingCell!.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            })
            
        }else {
            
        }
    }
    
    func dragChanged(gesture: UILongPressGestureRecognizer) {
        print("Draging!!!")
        let point = gesture.location(in: collectionview)
        
        dragingCell!.center = point
        targetIp = getTargetIndexPathWith(point: point)
        if (dragingIp != nil) && (targetIp != nil) {
            collectionview.moveItem(at: dragingIp!, to: targetIp!)
            dragingIp = targetIp!
        }
    }
    
    func dragEnd(gesture: UILongPressGestureRecognizer) {

        if let drag = dragingIp {
            let endFrame = collectionview.cellForItem(at: drag)?.frame
            UIView.animate(withDuration: 0.3, animations: { 
                self.dragingCell!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.dragingCell!.frame = endFrame!
            }, completion: { (finished) in
                self.dragingCell!.isHidden = true
            })
        }
    
    }
    
    func getDragingIndexPathWith(point: CGPoint) -> IndexPath? {
        var draging: IndexPath?
        for ip in collectionview.indexPathsForVisibleItems {
            if let isContaining = collectionview.cellForItem(at: ip)?.frame.contains(point) {
                
                if isContaining {
                    draging = ip
                    break
                }
            }
        }
        return draging
    }
    
    func getTargetIndexPathWith(point: CGPoint) -> IndexPath? {
        var target: IndexPath?
        for ip in collectionview.indexPathsForVisibleItems {
            if ip == dragingIp! {
                continue
            }
            if let isContaining = collectionview.cellForItem(at: ip)?.frame.contains(point) {
                if isContaining {
                    target = ip
                }
            }
        }
        return target
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return firstSecArr.count
        default:
            return secondSecArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath) as! TestCell
        
        switch indexPath.section {
        case 0:
            cell.label.text = firstSecArr[indexPath.row]
        default:
            cell.label.text = secondSecArr[indexPath.row]
        }
        
        return cell
    }
}


