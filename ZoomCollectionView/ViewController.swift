import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    
    static let cellId = "CellId"
    
    var zoomView: ZoomCollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(scrollViewWasTapped(sender:)))
           tap.numberOfTapsRequired = 1
        
        let itemWidth = (self.view.frame.width - 20.0)/5.0
        let layout = ScalingGridLayout(
            itemSize: CGSize(width: itemWidth, height: itemWidth),
            columns: 5,
            itemSpacing: 5.0,
            scale: 1.0
        )
        
        zoomView = ZoomCollectionView(
            frame: CGRect(origin: .zero, size: self.view.frame.size),
            layout: layout
        )
        zoomView!.collectionView.dataSource = self
        zoomView!.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ViewController.cellId)
        zoomView!.collectionView.backgroundColor = .white
        
        zoomView!.scrollView.minimumZoomScale = 1.0
        zoomView!.scrollView.zoomScale = 1.0
        zoomView!.scrollView.maximumZoomScale = 4.0
        zoomView!.scrollView.addGestureRecognizer(tap)
        
        view.addSubview(zoomView!)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewController.cellId, for: indexPath)
        cell.backgroundColor = indexPath.row % 2 == 0 ? .orange : .blue
        
        return cell
    }

    @objc func scrollViewWasTapped(sender:UITapGestureRecognizer) {
        let point = sender.location(in: zoomView!.collectionView)
        let path = zoomView!.collectionView.indexPathForItem(at: point)
        print(path ?? IndexPath(row: 0, section: 0))
       
    }
}

