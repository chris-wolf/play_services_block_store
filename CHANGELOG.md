## 0.7.0

* adjustment for chunk logic
 
## 0.6.0

* small readme fix.

## 0.5.0

* saveString/saveByte methods now return false if play services not available.

## 0.4.0

* Data is now automatically split into chunks when reaching the 4000 byte limit per value

## 0.3.0

* Saved byte data as bytes and not as base64encoded to be more space efficient
* Removed retrieveAll since don't know if it is string data or byte data

## 0.2.0

* Made PlayServicesBlockStore methods static for easier access

## 0.0.1

* Added all functions of play services block store and created example
