class_name Intent
extends Object
## What is the Internet? [br] If you want to encourage users to install, buy, comment and give stars in your app, you can use Bazaar intents and assign a link to your apps.


## When you want to refer the user to your application, you can use the following int. In this method, if the bazaar program is installed on the Android device, it will run automatically and the user will be directed to the desired program page.
static func open_details(package_name : String) -> void:
	if Engine.has_singleton("GodotPoolakeyPlugin"):
		var plugin = Engine.get_singleton("GodotPoolakeyPlugin")
		plugin.intent_open_details(package_name)
	

## When you want to refer the user to the page of all your programs, you can use the following intent.
static func open_collection(developer_id : String) -> void:
	if Engine.has_singleton("GodotPoolakeyPlugin"):
		var plugin = Engine.get_singleton("GodotPoolakeyPlugin")
		plugin.intent_open_collection(developer_id)
	

## When you want to direct the user to the user page in Cafe Bazaar, you can use the following interface.
static func open_login() -> void:
	if Engine.has_singleton("GodotPoolakeyPlugin"):
		var plugin = Engine.get_singleton("GodotPoolakeyPlugin")
		plugin.intent_open_login()
