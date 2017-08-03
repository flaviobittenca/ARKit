/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Popover view controller for choosing virtual objects to place in the AR scene.
 */

import UIKit

enum PresentationType {
    case category, object
}

// MARK: - ObjectCell

class ObjectCell: UITableViewCell {
    
    static let reuseIdentifier = "ObjectCell"
    
    @IBOutlet weak var objectTitleLabel: UILabel!
    @IBOutlet weak var objectImageView: UIImageView!
    
    var element: Any? {
        didSet {
            if let category = element as? VirtualCategoryDefinition {
                objectTitleLabel.text = category.category
                objectImageView.image = UIImage()
            } else if let object = element as? VirtualObjectDefinition {
                objectTitleLabel.text = object.displayName
                objectImageView.image = UIImage()
            }
            
        }
    }
}

protocol VirtualCategorySelectionDelegate: class {
    func virtualCategorySelectionDelegate(_: VirtualCategorySelectionViewController, didSelectCategoryAt index: Int)
}

class VirtualCategorySelectionViewController: UITableViewController {

    weak var delegate: VirtualCategorySelectionDelegate?
    private var elements: [Any] {
        get {
            return VirtualObjectManager.availableCategories
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .light))
    }
    
    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: 250, height: tableView.contentSize.height)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Check if the current row is already selected, then deselect it.
        
        delegate?.virtualCategorySelectionDelegate(self, didSelectCategoryAt: indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ObjectCell.reuseIdentifier, for: indexPath) as? ObjectCell else {
            fatalError("Expected `ObjectCell` type for reuseIdentifier \(ObjectCell.reuseIdentifier). Check the configuration in Main.storyboard.")
        }
        
        cell.element = elements[indexPath.row]
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = UIColor.clear
    }
    
}
