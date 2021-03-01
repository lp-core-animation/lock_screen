// image by NASA: https://www.flickr.com/photos/nasacommons/29193068676/

import UIKit

class LockScreenViewController: UIViewController {

  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var dateTopConstraint: NSLayoutConstraint!

  let blurView = UIVisualEffectView(effect: nil)

  var settingsController: SettingsViewController!

  override func viewDidLoad() {
    super.viewDidLoad()

    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 44, height: 33))
    let image = renderer.image {
      context in
      UIColor(white: 0, alpha: 0.4).setFill()
      UIBezierPath(roundedRect: context.format.bounds, cornerRadius: 10).fill()
    }.stretchableImage(withLeftCapWidth: 11, topCapHeight: 11)
    searchBar.setSearchFieldBackgroundImage(image, for: .normal)
    view.bringSubviewToFront(searchBar)
    blurView.effect = UIBlurEffect(style: .dark)
    blurView.alpha = 0
    blurView.isUserInteractionEnabled = false
    view.insertSubview(blurView, belowSubview: searchBar)

    tableView.estimatedRowHeight = 130.0
    tableView.rowHeight = UITableView.automaticDimension
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.transform = CGAffineTransform(scaleX: 0.67, y: 0.67)
    tableView.alpha = 0
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let scale = UIViewPropertyAnimator(duration: 0.33, curve: .easeIn)
    scale.addAnimations {
      self.tableView.alpha = 1.0
    }

    scale.addAnimations({
      self.tableView.transform = .identity
    }, delayFactor: 0.33)

    scale.addCompletion { _ in
      print("ready")
    }

    scale.startAnimation()
  }
  

  override func viewWillLayoutSubviews() {
    blurView.frame = view.bounds
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  @IBAction func presentSettings(_ sender: Any? = nil) {
    //present the view controller
    settingsController = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
    present(settingsController, animated: true, completion: nil)
  }
  
}

extension LockScreenViewController: WidgetsOwnerProtocol { }

extension LockScreenViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Footer") as! FooterCell
      cell.didPressEdit = {[unowned self] in
        self.presentSettings()
      }
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! WidgetCell
      cell.tableView = tableView
      cell.owner = self
      return cell
    }
  }
}
