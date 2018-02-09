/**
 * Jahasa Technology Ltd all rights reserved
 *
 * @author Sudhindra sudhindra@jahasatech.com
 * @since 5.02.2018
 * <p>
 * Config.swift
 * To hold all the constants and the configurations required for AcubeIO project
 * Copyright © 2018 Jahasa. All rights reserved.
 */

import Foundation

class Config  {
    
    public static var PUBLIC_KEY :String                        = "";
    public static var PRIVATE_KEY :String                       = "";
    public static var CLIENT_ID :String                         = "ClientId";
    public static var CLIENT_SECRET :String                     = "secrete";
    public static var ACCESS_TOKEN_RESPONSE_TYPE :String        = "token";
    
    public static var ENDPOINT :String                          = "http://ec2-54-157-226-234.compute-1.amazonaws.com:8300/";
    public static var AUTH_TOKEN_ENDPOINT :String               = ENDPOINT + "uaa/oauth/token";
    public static var USER_PROFILE_ENDPOINT :String             = ENDPOINT + "user/me";
    
    public static var ACUBE_BLEID :String                       = "ffffffff-ffff-ffff-ffff-fffffffffff0";
    
     public static var ACUBE_WRITEBLEID :String                       = "ffffffff-ffff-ffff-ffff-fffffffffff4";
    public init() {
    }


}
