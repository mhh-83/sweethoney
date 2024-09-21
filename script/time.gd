extends Label

signal timeout

enum MODE {Day, Hour}
@export var mode = MODE.Day
var current_time = {"year": 2023, "month": 1, "day": 1, "second" : 0,  "minute" : 0,  "hour" : 0}
var local_time = 0
@export var open_time = {"year": 2023, "month": 8, "day": 25, "second" : 0,  "minute" : 0,  "hour" : 0}
var month_day = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
var start_timer = false
var time_left = ""
var start_download = true
@export var open_time2 = {"hour":0, "minute":0, "second":0}
var _base_name = "gift"
var save_path = "user://data.cfg"
# Called when the node enters the scene tree for the first time.

func save(_name, num):
	var confige = ConfigFile.new()
	confige.load(save_path)
	confige.set_value("user", _name, num)
	confige.save(save_path)
func load_game(_name, defaulte=null, path=save_path):
	var confige = ConfigFile.new()
	confige.load(path)
	return confige.get_value("user", _name, defaulte)
func day_timer(year : int, month : int, day : int, hour : int, minute : int, second : int):
	open_time = {"year": year, "month": month, "day": day, "second" : second,  "minute" : minute,  "hour" : hour}
	start_timer = true

func hour_timer(hour : int, minute : int, second : int):
	open_time2 = {"hour":hour, "minute":minute, "second":second}
	start_timer = true
func store_time():
	var file = FileAccess.open("res://files/daily_gift_time.json", FileAccess.WRITE)
	file.store_line(JSON.stringify(open_time2))
	file.close()
func stop():
	start_timer = false
func _ready():
	var time_request = HTTPRequest.new()
	add_child(time_request)
	time_request.request_completed.connect(_on_time_request_completed.bind(time_request))
	time_request.request("http://worldtimeapi.org/api/ip")
func start(_name, time, _mode=1):
	_base_name = _name
	mode = _mode
	match mode:
		MODE.Day:
			open_time = time
			day_timer(open_time["year"], open_time["month"], open_time["day"], open_time["hour"], open_time["minute"], open_time["second"])
		MODE.Hour:
			open_time2 = time
			hour_timer(open_time2["hour"], open_time2["minute"], open_time2["second"])
	
func _on_time_request_completed(result, response_code, headers, body, http):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	if response:
		current_time.second = int(response["datetime"].substr(11,8).split(":")[2])
		current_time.minute = int(response["datetime"].substr(11,8).split(":")[1])
		current_time.hour = int(response["datetime"].substr(11,8).split(":")[0])
		current_time.year = int(response["datetime"].substr(0,10).split("-")[0])
		current_time.month = int(response["datetime"].substr(0,10).split("-")[1])
		current_time.day = int(response["datetime"].substr(0,10).split("-")[2])
		start_download = false
		http.queue_free()
	else:
		http.request("http://worldtimeapi.org/api/ip")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_time():
	var time_request = HTTPRequest.new()
	add_child(time_request)
	time_request.request_completed.connect(_on_time_request_completed.bind(time_request))
	time_request.request("http://worldtimeapi.org/api/ip")
func _process(delta):
	local_time += delta
	if local_time > 1:
		local_time -= 1
		if compute_time():
			update_time()
	if start_timer and !start_download:
		var days = 0
		var d = 1
		var t = ""
		var t2 = " : "
		var t3 = " : "
		match mode:
			MODE.Day:
				for x in range(abs((current_time.month - open_time.month))):
					days += month_day[(x + current_time.month - 1) % 12]
				if current_time.month > open_time.month:
					d = -1
				var result = -((current_time.year - open_time.year) * 365 * 24 * 60 * 60) + (days * 24 * d * 60 * 60) - ((current_time.day - open_time.day) * 24 * 60 * 60) - ((current_time.hour - open_time.hour) * 60 * 60) - ((current_time.minute - open_time.minute) * 60) - (current_time.second - open_time.second)
				if int(result / 60) % 60 <= 9:
						t2 = " : 0"
				if result % 60 <= 9:
					t3 = " : 0"
				if result / 3600 <= 9:
					t = "0"
				if result > 0:
					time_left = t + str(result / 3600) + t2 + str(int(result / 60) % 60) + t3 + str(result % 60)
				elif result <= 0:
					emit_signal("timeout")
			MODE.Hour:
				var result = ((open_time2.hour - current_time.hour) * 3600) + ((open_time2.minute - current_time.minute) * 60) + (open_time2.second - current_time.second)
				var last_time = load_game("last_time_"+_base_name, {"year": 2023, "month": 1, "day": 1, "second" : 0,  "minute" : 0,  "hour" : 0})
				for x in range(abs((current_time.month - last_time.month))):
					days += month_day[(x + current_time.month - 1) % 12]
				
				if current_time.month > last_time.month:
					d = -1
				var result2 = -((current_time.year - last_time.year) * 365 * 24 * 60 * 60) + (days * 24 * d * 60 * 60) - ((current_time.day - last_time.day) * 24 * 60 * 60) - ((current_time.hour - last_time.hour) * 60 * 60) - ((current_time.minute - last_time.minute) * 60) - (current_time.second - last_time.second)
				if result > 0:
					if int(result / 60) % 60 <= 9:
						t2 = " : 0"
					if result % 60 <= 9:
						t3 = " : 0"
					if result / 3600 <= 9:
						t = "0"
					time_left = t + str(result / 3600) +t2 + str(int(result / 60) % 60) + t3 + str(result % 60)
					if result - result2 >= 86400:
						save(_base_name, true)
						save("last_time_"+_base_name, current_time)
				elif result < 0:
					var r = 86400 + result
					if int(r / 60) % 60 <= 9:
						t2 = " : 0"
					if r % 60 <= 9:
						t3 = " : 0"
					if r / 3600 <= 9:
						t = "0"
					time_left = t + str(r / 3600) + t2 + str(int(r / 60) % 60) + t3 + str(r % 60)
					if r - result2 >= 86400:
						save(_base_name, true)
						save("last_time" + _base_name, current_time)
				elif result == 0:
					emit_signal("timeout")
					save("last_time" + _base_name, current_time)
	else:
		time_left = ""
	text = time_left
	
func compute_time():
	var r = false
	current_time.second += 1
	if current_time.second >= 60:
		current_time.second = 0
		r = true
		current_time.minute += 1
		if current_time.minute >= 60:
			current_time.minute = 0
			current_time.hour += 1
			if current_time.hour >= 24:
				current_time.hour = 0
	return r

