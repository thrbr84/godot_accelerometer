extends Camera2D

var tween = Tween.new()
var wait: bool = false

export(float) var accelerometerAccuracy: float = .01
export(bool) var useAccelerometer: bool = true
export(bool) var debugMode: bool = false
export(Vector2) var offsetParallax_h: Vector2 = Vector2(-300.0, 300.0)
export(Vector2) var offsetParallax_v: Vector2 = Vector2.ZERO

func _ready() -> void:
	call_deferred("add_child", tween)

func _process(delsdfta):
	if !useAccelerometer: return
	if wait: return
	wait = true # lock process
	
	# Get accelerometer information
	var accelerometer = _accelerometerInfo()

	# clamp offset, betweem min and max value to movement
	var off_h = self.offset.x + (offsetParallax_h.y * accelerometer.x)
	off_h = clamp(off_h, offsetParallax_h.x, offsetParallax_h.y)
	
	var off_v = self.offset.y + (offsetParallax_v.y * accelerometer.y)
	off_v = clamp(off_v, offsetParallax_v.x, offsetParallax_v.y)
	
	self.offset = Vector2(off_h, off_v)
	wait = false # unlock process

func _accelerometerInfo() -> Vector3:
	if !useAccelerometer: return Vector3.ZERO
	var accelerometer = Vector3.ZERO
	var debugText = "no sensor"
		
	if Input.get_accelerometer() != Vector3.ZERO:
		accelerometer = Input.get_accelerometer()
		debugText = "using accelerometer()"
	
	# If movement not is ZERO 0,0,0
	if accelerometer != Vector3.ZERO:
		accelerometer = (accelerometer + Vector3(.5, 4, 0)) / 10
		# adjust movement accuracy
		accelerometer.x = stepify(accelerometer.x, accelerometerAccuracy)
		accelerometer.y = stepify(accelerometer.y, accelerometerAccuracy)
		accelerometer.z = stepify(accelerometer.z, accelerometerAccuracy)
		# If debugMode, prepare string log
		debugText += str("\nX:",accelerometer.x, "- Y:",accelerometer.y, "- Z:",accelerometer.z )
	
	if debugMode:
		prints(debugText)

	return accelerometer

func _move(dir:int) -> void:
	if tween.is_active(): return
	# Move action
	var view_port_size_w = get_viewport_rect().size.x
	tween.interpolate_property(self, "position", self.position, self.position + Vector2(view_port_size_w * dir,0), .3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
