//
//  iProfile.swift
//  IPSE
//
//  Created by Michaelsun Baluyos on 12/05/2015.
//  Copyright (c) 2015 rmit. All rights reserved.
//

import Foundation

protocol iProfile {
    func getFirstName() -> String
    func getLastName() -> String
    func getProfilePic() -> String
}

struct ProfileTable {
    var id: Int
    var first_name: String
    var last_name: String
    var picture: String
}