# acube-ios
Test project
This project is a test project which will detect the BLE devices, connect to the device and send some data

## Prerequisites
Alamofire swift library (https://github.com/Alamofire/Alamofire)

SwiftyJSON library (https://github.com/SwiftyJSON/SwiftyJSON)

SwiftyRSA library (https://github.com/TakeScoop/SwiftyRSA)

An oauth2 authentication server where the refresh token and oauth2 token will be sent upon request.
This is configurable in config file.

## Installing
Open Acube io project in Xcode
Add specified library projects

## Description
App will get the auth token and refresh token from oAuth2 server upon successful login.
Once the tokens are received, app will store tokens(encrypted) in local database which is designed using core data.
And it will request for the user profile using the Authtoken. 
The received user profile is also stored in local database.

In Home screen if user scans for devices, it will list all BLE devices with the UUID stored in config file.
Once user clicks on the BLE device, it will connect to BLE device and navigate to page for sending the characters.
In Bluetooth Communication screen, User can send SUCCESS and FAILURE to the connected Bluetooth peripheral with the write characteristic configured in the config file.
