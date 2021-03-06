//
//  FaceSnapsConstants.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/2/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation

extension FaceSnapsClient {
    
    enum Environment {
        case production, development
    }
    
    // MARK: - Set Application Environment
    static let ApplicationEnvironment: Environment = .development
    
    enum Constant {
        static let ApiScheme = "http"
        static let ApiHost = FaceSnapsClient.ApplicationEnvironment == .production ? "TBD" : "localhost"//"67.81.24.198"
        static let ApiPort: NSNumber? = FaceSnapsClient.ApplicationEnvironment == .production ? nil : 3000// 81
        static let ApiPath = ""
        static let ApiKey = ""
        static let ClientType = APIConstants.Client.facesnaps
        
        enum ErrorResponseKey {
            static let error = "error"
            static let title = "title"
            static let message = "message"
        }
        
        
        // MARK: - API Methods
        enum APIMethod {
            enum UserEndpoint {
                // Sign up new user
                static let signUpUser = "/users/sign_up"
                // Check if a username is available
                static let checkAvailability = "/users/sign_up/check_availability"
                // Sign in with username and password
                static let signInUser = "/sessions"
                // Sign out the user
                static func signOutUser(auth_token: String) -> String {
                    return "/sessions/\(auth_token)"
                }
                // Get current user
                static let getCurrentUser = "/users/self"
                // Get information about a user
                static let getUser = "/users/"
                // Get most recent posts of the current user (*paginated)
                static let getCurrentUserMedia = "/users/self/posts/recent"
                // Get most recently liked posts by the current user (*paginated)
                static let getCurrentUserLikedMedia = "/users/self/posts/liked"
                // Get most recent posts of a user (*paginated)
                static func getUserMedia(userId: Int) -> String {
                    return "users/\(userId)/posts/recent"
                }
                // Search for a user by name (*paginated)
                static let getUsersQuery = "/users/search"
                
            }
            
//            enum RelationshipsEndpoint {
//                
//            }
//            
//            enum PostsEndpoint {
//                
//            }
//            
//            enum LikesEndpoint {
//                
//            }
//            
//            enum CommentsEndpoint {
//                
//            }
//            
//            enum TagsEndpoint {
//                
//            }
//            
//            enum LocationsEndpoint {
//                
//            }
        }
        
        // MARK: - JSON Response Keys
        enum JSONResponseKey {
            
            // MARK: - Error
            enum Error {
                static let errors = "errors"
                static let title = "title"
                static let message = "message"
            }
            
            // MARK: - User Data
            enum User {
                static let user = "user"
                static let id = "id"
                static let username = "username"
                static let email = "email"
                static let authToken = "auth_token"
                static let available = "available"
            }
            // MARK: - Relationship Data
            
            // MARK: - Post data
            
            // MARK: - Comments Data
            
            // MARK: - Tags Data
            
            // MARK: - Locations Data
            
            // MARK: - Pagination (should be header response)
        }
    }
    
    // MARK: - HTTP Header Response Keys
    enum HTTPHeaderResponseKey {
        
    }
    
    
}
