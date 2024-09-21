class_name PurchaseInfo
extends Object
## [PurchaseInfo] class can hold your purchase info.
## 
## 

## Purchase order id.
var order_id: String

## Purchase token.
var purchase_token: String

## Purchase payload.
var payload : String

## Purchase package name.
var package_name : String

## Purchase state.
var purchase_state : String

## Purchase time.
var purchase_time : int

## Purchase product id.
var product_id : String

## Purchase original json.
var original_json : String

## Purchase data signature.
var data_signature : String

func _init(data : Dictionary):
	self.order_id = data.order_id
	self.purchase_token = data.purchase_token
	self.payload = data.pay_load
	self.package_name = data.package_name
	self.purchase_state = data.purchase_state
	self.purchase_time = data.purchase_time
	self.product_id = data.product_id
	self.original_json = data.original_json
	self.data_signature = data.data_signature

## Check purchase has a specific order id.
func has_order_id(order_id : String) -> bool:
	return self.order_id == order_id
	

## Check purchase has a specific purchase token.
func has_purchase_token(purchase_token : String) -> bool:
	return self.purchase_token == purchase_token
	

## Check purchase has a specific payload.
func has_payload(payload : String) -> bool:
	return self.payload == payload
	

## Check purchase has a specific package name.
func has_package_name(package_name : String) -> bool:
	return self.package_name == package_name
	

## Check purchase has a specific purchase state.
func has_purchase_state(purchase_state : String) -> bool:
	return self.purchase_state == purchase_state
	

## Check purchase has a specific purchase time.
func has_purchase_time(purchase_time : int) -> bool:
	return self.purchase_time == purchase_time
	

## Check purchase has a specific purchase id.
func has_product_id(product_id : String) -> bool:
	return self.product_id == product_id
	
