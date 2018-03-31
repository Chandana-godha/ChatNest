//
//  File.swift
//  ChatNest
//
//  Created by chandana on 2/15/18.
//  Copyright © 2018 chandana. All rights reserved.
//

import Foundation
func updateUsersProfile(){
    //check to see if the user is logged in
    if let userID = FIRAuth.auth()?.currentUser?.uid{
        //create an access point for the Firebase storage
        let storageItem = storageRef.child("profile_images").child(userID)
        //get the image uploaded from photo library
        guard let image = profileImageView.image else {return}
        if let newImage = UIImagePNGRepresentation(image){
            //upload to firebase storage
            storageItem.put(newImage, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }
                storageItem.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    if let profilePhotoURL = url?.absoluteString{
                        guard let newUserName  = self.usernameText.text else {return}
                        guard let newDisplayName = self.displayNameText.text else {return}
                        guard let newBioText = self.bioText.text else {return}
                        
                        let newValuesForProfile =
                            ["photo": profilePhotoURL,
                             "username": newUserName,
                             "display": newDisplayName,
                             "bio": newBioText]
                        
                        //update the firebase database for that user
                        self.databaseRef.child("profile").child(userID).updateChildValues(newValuesForProfile, withCompletionBlock: { (error, ref) in
                            if error != nil{
                                print(error!)
                                return
                            }
                            print("Profile Successfully Update")
                        })
                        
                    }
                })
            })
            
        }//end new image
    }
}
