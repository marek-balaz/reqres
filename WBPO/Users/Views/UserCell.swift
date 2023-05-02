//
//  UserCell.swift
//  WBPO
//
//  Created by Marek Baláž on 02/05/2023.
//

import UIKit
import Kingfisher

class UserCell: UITableViewCell {
    
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var followUnfollowBtn: UIButton!
    
    private var userViewModel: UsersViewModel!
    private var user: User!
    
    @IBAction func followUnfollowBtnAction(_ sender: UIButton) {
        user.followUnfollow()
        userViewModel.followingDataService.saveFollowing(user: user)
        if userViewModel.followingDataService.savedEntities.contains(where: {$0.id == user.id }) {
            followUnfollowBtn.setTitle("Unfollow", for: .normal)
        } else {
            followUnfollowBtn.setTitle("Follow", for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImg.layer.cornerRadius = avatarImg.layer.bounds.height / 2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func set(user: User, userViewModel: UsersViewModel) {
        
        self.userViewModel = userViewModel
        self.user = user
        
        emailLbl.text = user.email
        firstNameLbl.text = user.firstName
        lastNameLbl.text = user.lastName
        if userViewModel.followingDataService.savedEntities.contains(where: {$0.id == user.id }) {
            followUnfollowBtn.setTitle("Unfollow", for: .normal)
            self.user.follow()
        } else {
            followUnfollowBtn.setTitle("Follow", for: .normal)
        }
        
        let url = URL(string: user.avatar)
        avatarImg.kf.setImage(with: url)
    }
    
}
