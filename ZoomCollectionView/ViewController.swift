import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    
    var collectionView: ZoomCollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let itemWidth = (self.view.frame.width - 40.0)/5.0
        
        let layout = ZoomGridLayout(
            itemSize: CGSize(width: itemWidth, height: itemWidth),
            columns: 5,
            itemSpacing: 10.0,
            scale: 1.0
        )
        
        collectionView = ZoomCollectionView(
            frame: CGRect(origin: .zero, size: self.view.frame.size),
            layout: layout
        )
        collectionView!.dataSource = self
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
        collectionView!.backgroundColor = .white
        
        view.addSubview(collectionView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath)
        cell.backgroundColor = indexPath.row % 2 == 0 ? .blue : .yellow
        
        return cell
    }

}

