# ZoomCollectionView for iOS
`UICollectionView` is great, but it is not zoomable (which is rather strange since
it is inherits from `UIScrollView`). This project is an attempt to implement zooming
using custom a `UICollectionViewLayout` which resizes itself to simulate the effect
we know and love from `UIScrollView`.

<img src="./scale-default.png" width="320" alt="Default" />
&nbsp;
&nbsp;
&nbsp;
&nbsp;
<img src="./scale-zoomed.png" width="320" alt="Zoomed" />

## Usage with cocoapods
Add a pod requirement to your podfile:
```ruby
target 'MyApp' do
  ...
  pod 'ZoomCollectionView', :git => 'https://github.com/helmutschneider/ZoomCollectionView.git'
  ...
end
```
Then instantiate the layout & view:
```swift
class ViewController: UIViewController, UICollectionViewDataSource {

    static let cellId = "CellId"
    var zoomView: ZoomCollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()

        let itemWidth = (self.view.frame.width - 20.0)/5.0

        // you can also implement your own scaling layout
        let layout = ScalingFlowLayout(initialScale: 1.0)
        layout.scrollDirection = .vertical

        let itemWidth = (self.view.frame.width - 20.0)/5.0
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = 5.0
        layout.minimumLineSpacing = 5.0

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

        view.addSubview(zoomView!)
    }

    ...UICollectionViewDataSource methods...

}
```
For a complete example, have a look at [ViewController.swift](ZoomCollectionView/ViewController.swift).

## How does it work?
`ZoomCollectionView` is a container view that encapsulates three views:
- A `UICollectionView` for the actual collection data
- A `UIScrollView` for the zoom/scroll hooks
- A dummy `UIView` that the scroll view uses for its zooming capabilities

When the scroll view is zoomed or scrolled it forwards the content offset to
the collection view and the scale factor to the `UICollectionViewLayout` which
implements the following protocol:

```swift
public protocol ScalingLayoutProtocol {
    func getScale() -> CGFloat
    func setScale(_ scale: CGFloat) -> Void
    func contentSizeForScale(_ scale: CGFloat) -> CGSize
}
```

How the layout recalculates its attributes is implementation specific but an example
can be found in [ScalingFlowLayout.swift](Source/ScalingFlowLayout.swift).

## What works
- Scrolling
- Zooming

## What does not work
- The bounce effect when `minimumZoomScale` or `maximumZoomScale` is reached. The reason for this is that the bounce effect does not trigger `scrollViewDidZoom` in the scroll view.
