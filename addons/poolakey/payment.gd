class_name Payment
extends Object
## Poolakey is a new library for implementing in-app marketplace payment, developed with Kotlin programming language and supporting ReactiveX framework. The purpose of implementing this library is to improve the process of implementing CafeBazaar in-app payment for CafeBazaar developers.
##
## To connect to the Bazaar, you need to use the [method start_setup] function in the [Payment] class:[br]
## [codeblock]
## var public_key = "YOUR PUBLIC KEY"
##
## @onready var payment = Payment.new(public_key)
## [/codeblock]
## [codeblock]
##     payment.start_setup()
##     payment.connection_succeed.connect(func():
##     ...
##     ,CONNECT_ONE_SHOT)
##     payment.connection_failed.connect(func(error : String):
##     ...
##     ,CONNECT_ONE_SHOT)
##     payment.disconnected.connect(func():
##     ...
##     ,CONNECT_ONE_SHOT)
## [/codeblock]
## In the body of the [method start_setup] function, you have access to three callbacks: [br]
## [code]connection_succeed[/code] Emitted when a connection to the Bazaar is established [br]
## [code]connection_failed[/code] Emitted when a connection to the CafeBazaar fails [br]
## [code]disconnected[/code] is Emitted when your application is disconnected from the Bazaar according to an event [br]
## As you can see, in [code]connection_failed[/code], you have access to the [param error], which can help you understand the problem that caused your application to not connect to the Bazaar. [br]
## To avoid problems such as Memory Leak, you must disconnect from the Bazaar: [br]
## Call [method finish] [br]
## [br]
## To start the process of purchasing a product, you must use the [method purchase_product] function from the [Payment] class to start the process of purchasing the desired product: [br]
## [codeblock]
##     payment.purchase_product("product_id")
##     payment.purchase_succeed.connect(func(info : PurchaseInfo):
##     ...
##     ,CONNECT_ONE_SHOT)
##     payment.purchase_flow_began.connect(func():
##     ...
##     ,CONNECT_ONE_SHOT)
##     payment.failed_to_begin_flow.connect(func(error : String):
##     ...
##     ,CONNECT_ONE_SHOT)
##     payment.purchase_canceled.connect(func():
##     ...
##     ,CONNECT_ONE_SHOT)
##     payment.purchase_failed.connect(func(error : String):
##     ...
##     ,CONNECT_ONE_SHOT)
## [/codeblock]
## [b]Note:[/b] Instead of the [param product_id] value, you should replace the product ID value that you intend to buy. To get the value of the desired product ID, visit the developer's front desk and create a new product in the "In-app payment" tab on the program information page and consider an ID for it. Or you can replace the [param product_id] value with the ID of the products you have already created. [br]
## In the body of the [method purchase_product] function, you have access to the following callbacks: [br]
## [code]purchase_flow_began[/code] is emitted when the process of directing the user to the CafeBazaar purchase page is done correctly. [br]
## [code]failed_to_begin_flow[/code] is emitted when the process of directing the user to the CafeBazaar purchase page fails. [br]
## As you can see, you have access to an [param error] in [code]failed_to_begin_flow[/code], which can be used to understand the problem at the beginning of the purchase process. [br]
## [code]purchase_succeed[/code] Emitted when the purchase is successful, in which case the purchase information can be retrieved via the [param PurchaseInfo]. Note that if the purchase is successful, it is highly recommended that you also check the authenticity of the payment yourself through the CafeBazaar Payment API. [br]
## [code]purchase_canceled[/code] Emitted when the user cancels the purchase. [br]
## [code]purchase_failed[/code] Emitted when there is a problem with the purchase. This problem can be due to incorrect purchase information and similar problems. In this case, with the help of the [param error] sample in this callback, you can find out about the problem. [br]
## [br]
## To subscribe a product, act exactly like starting to buy a product and instead of using the [method purchase_product] function, use the [method subscribe_product] function in the [Payment] class. [br]
## [br]
## When the user buys one of the digital products of your application, he becomes the owner of a copy of the desired product, and if you redirect the user to the payment page again, the user cannot make the purchase again and open your application with the previous purchase information. ([code]purchase_succeed[/code]). But you can consider the expiration date or special conditions for the product you want to purchase. In this case, the user can make the purchase again. To consume a purchase, use the [method consume_product] function in the [Payment] class:
## [codeblock]
##     payment.consume_product("purchase_token")
##     payment.consume_succeed.connect(func():
##     ...
##     ,CONNECT_ONE_SHOT)
##     payment.consume_failed.connect(func(error : String):
##     ...
##     ,CONNECT_ONE_SHOT)
## [/codeblock]
## As you can see, you have access to two callbacks in the [method consume_product] body: [br]
## [code]consume_succeed[/code] Emitted when the purchase purchase operation succeeds. [br]
## [code]consume_failed[/code] is Emitted when the purchase consumption operation is not done, in this situation you can find out the problem by using the [param error] in this callback. [br]
## Note that instead of the value of [param purchase_token] in the above code example, you should put the actual value of the purchase token that you want to consume. Access to the purchase token is possible through the [param PurchaseInfo] class. When the user makes a purchase, Poolakey will give you a [param PurchaseInfo] in [code]purchase_succeed[/code]. You can also get all purchases made by the user in your application through the [method get_purchased_products] function, in which case, Poolakey will give you a list of [param PurchaseInfo], which can also access the purchase token. [br]
## [b]Note:[/b] You cannot consume subscription products. [br]
## [b]Note:[/b] Note that you must make sure the user is logged in to their CafeBazaar account before [method consuming_product] works, otherwise [code]consume_failed[/code] will be emitted. [br]
## [br]
## You can use the [method get_purchased_products] function in the [Payment] class to find out about the purchases made by the user in your application:
## [codeblock]
##     payment.get_purchased_products()
##     payment.purchased_query_succeed.connect(func():
##     ...
##     ,CONNECT_ONE_SHOT)
##     payment.purchased_query_failed.connect(func(error : String):
##     ...
##     ,CONNECT_ONE_SHOT)
## [/codeblock]
## As you can see, you have access to two callbacks in the [method get_purchased_products] body: [br]
## [code]purchased_query_succeed[/code] is emitted when the connection with the Bazaar is well established and there is no problem in receiving the list of purchases. In this case, you can access the user's purchases using purchasedProducts, which is a list of PurchaseInfo. [br]
## [code]purchased_query_failed[/code] is emitted when the connection to the Bazaar cannot be established or there is a problem in getting the list of purchases. In this case, you can find the problem by using the [param error] in this callback. [br]
## [b]Note:[/b] Note that before working with [method get_purchased_products] you must make sure the user is logged in to their CafeBazaar account, otherwise [code]purchased_query_failed[/code] will be emitted. [br]
## [br]
## You can use the [method get_subscribed_products] function in the [Payment] class to find out about the products that the user has subscribed to in your application:
## [codeblock]
##     payment.get_subscribed_products()
##     payment.subscribed_query_succeed.connect(func():
##     ...
##     ,CONNECT_ONE_SHOT)
##     payment.subscribed_query_failed.connect(func(error : String):
##     ...
##     ,CONNECT_ONE_SHOT)
## [/codeblock]
## As you can see, you have access to two callbacks in the body of [method get_subscribed_products]:
## [code]subscribed_query_succeed[/code] is emitted when the connection with the Bazaar is well established and there is no problem in getting the list of subscriptions, in which case, you can access the user's subscriptions using [method purchased_products], which is a list of [param PurchaseInfo].
## [code]subscribed_query_failed[/code] is emitted when the connection to the Bazaar cannot be established or there is a problem in receiving the list of subscriptions, in which case, you can find out the problem by using the error in this callback.
## [b]Note:[/b] Before working with [method get_subscribed_products] you must ensure that the user is logged in to their CafeBazaar account, otherwise [code]subscribed_query_failed[/code] will be emitted.

## Emitted when a connection to the Bazaar is established.
signal connection_succeed

## Emitted when a connection to the CafeBazaar fails.
signal connection_failed(error : String)

## Emitted when your application is disconnected from the Bazaar according to an event.
signal disconnected

## Emitted when the purchase is successful, in which case the purchase information can be retrieved via the [param PurchaseInfo].
signal purchase_succeed(info : PurchaseInfo)

## Emitted when the process of directing the user to the CafeBazaar purchase page is done correctly
signal purchase_flow_began

## Emitted when the process of directing the user to the CafeBazaar purchase page fails.
signal failed_to_begin_flow(error : String)

## Emitted when the user cancels the purchase.
signal purchase_canceled

## Emitted when there is a problem with the purchase.
signal purchase_failed(error : String)

## Emitted when the purchase operation succeeds.
signal consume_succeed

## Emitted when the purchase consumption operation is not done.
signal consume_failed(error : String)

## Emitted when the connection with the Bazaar is well established and there is no problem in receiving the list of purchases.
signal purchased_query_succeed(items : Array[PurchaseInfo])

## Emitted when the connection to the Bazaar cannot be established or there is a problem in getting the list of purchases.
signal purchased_query_failed(error : String)

## Emitted when the connection with the Bazaar is well established and there is no problem in getting the list of subscriptions.
signal subscribed_query_succeed(items : Array[PurchaseInfo])

## Emitted when the connection to the Bazaar cannot be established or there is a problem in receiving the list of subscriptions.
signal subscribed_query_failed(error : String)

## Holds your public key.
var public_key : String = ""

var _plugin : JNISingleton = null
var _plugin_name : String = "GodotPoolakeyPlugin"

func _init(public_key : String) -> void:
	if not has_poolakey(): return
	self.public_key = public_key
	_plugin = Engine.get_singleton(_plugin_name)
	

## Check the device support poolakey.
func has_poolakey() -> bool:
	return Engine.has_singleton(_plugin_name)
	

## Start connecting to Bazaar.
func start_setup() -> void:
	if not has_poolakey(): return
	_plugin.start_setup(public_key)
	_plugin.connection_succeed.connect(func():
		emit_signal("connection_succeed")
		,CONNECT_ONE_SHOT)
	_plugin.connection_failed.connect(func(error : String):
		emit_signal("connection_failed",error)
		,CONNECT_ONE_SHOT)
	_plugin.disconnected.connect(func():
		emit_signal("disconnected")
		,CONNECT_ONE_SHOT)
	

## Start the process of purchasing a product.
func purchase_product(product_id : String, payload : String = "", dynamic_price_token : String = "") -> void:
	if not has_poolakey(): return
	_plugin.purchase_product(product_id, payload, dynamic_price_token)
	_plugin.purchase_succeed.connect(func(info : Dictionary):
		emit_signal("purchase_succeed",PurchaseInfo.new(info))
		,CONNECT_ONE_SHOT)
	_plugin.purchase_flow_began.connect(func():
		emit_signal("purchase_flow_began")
		,CONNECT_ONE_SHOT)
	_plugin.failed_to_begin_flow.connect(func(error : String):
		emit_signal("failed_to_begin_flow",error)
		,CONNECT_ONE_SHOT)
	_plugin.purchase_canceled.connect(func():
		emit_signal("purchase_canceled")
		,CONNECT_ONE_SHOT)
	_plugin.purchase_failed.connect(func(error : String):
		emit_signal("purchase_failed",error)
		,CONNECT_ONE_SHOT)
	

## Start the process of subscribing to a product.
func subscribe_product(product_id : String, payload : String = "", dynamic_price_token : String = "") -> void:
	if not has_poolakey(): return
	_plugin.subscribe_product(product_id, payload, dynamic_price_token)
	_plugin.purchase_succeed.connect(func(info : Dictionary):
		emit_signal("purchase_succeed",PurchaseInfo.new(info))
		,CONNECT_ONE_SHOT)
	_plugin.purchase_flow_began.connect(func():
		emit_signal("purchase_flow_began")
		,CONNECT_ONE_SHOT)
	_plugin.failed_to_begin_flow.connect(func(error : String):
		emit_signal("failed_to_begin_flow",error)
		,CONNECT_ONE_SHOT)
	_plugin.purchase_canceled.connect(func():
		emit_signal("purchase_canceled")
		,CONNECT_ONE_SHOT)
	_plugin.purchase_failed.connect(func(error : String):
		emit_signal("purchase_failed",error)
		,CONNECT_ONE_SHOT)
	

## To consume a purchase. [br]
## [b]Note:[/b] You cannot consume subscription products.
func consume_product(purchase_token : String) -> void:
	_plugin.consume_product(purchase_token)
	_plugin.consume_succeed.connect(func():
		emit_signal("consume_succeed")
		,CONNECT_ONE_SHOT)
	_plugin.consume_failed.connect(func(error : String):
		emit_signal("consume_failed",error)
		,CONNECT_ONE_SHOT)
	

## Get all the purchases made by the user in your application.
func get_purchased_products() -> void:
	_plugin.get_purchased_products()
	_plugin.purchased_query_succeed.connect(func(items : Dictionary):
		emit_signal("purchased_query_succeed", _get_all_items_as_array(items))
		,CONNECT_ONE_SHOT)
	_plugin.purchased_query_failed.connect(func(error : String):
		emit_signal("purchased_query_failed",error)
		,CONNECT_ONE_SHOT)
	

## Get all the products that the user has subscribed to in your application.
func get_subscribed_products() -> void:
	_plugin.get_subscribed_products()
	_plugin.subscribed_query_succeed.connect(func(items : Dictionary):
		emit_signal("subscribed_query_succeed", _get_all_items_as_array(items))
		,CONNECT_ONE_SHOT)
	_plugin.subscribed_query_failed.connect(func(error : String):
		emit_signal("subscribed_query_failed",error)
		,CONNECT_ONE_SHOT)
	

## Disconnect from Bazaar.
func finish() -> void:
	if not has_poolakey(): return
	_plugin.finish()
	

func _get_all_items_as_array(items : Dictionary) -> Array[PurchaseInfo]:
	var purchases_infos : Array[PurchaseInfo]
	for key in items.keys():
		var item : Dictionary = items.get(key)
		item.order_id = key
		var p : PurchaseInfo = PurchaseInfo.new(item)
		purchases_infos.append(p)
	return purchases_infos
