extends CharacterBody2D
var gravity : Vector2
@export var jump_height : float ## How high should they jump?
@export var movement_speed : float ## How fast can they move?
@export var horizontal_air_coefficient : float ## Should the player move more slowly left and right in the air? Set to zero for no movement, 1 for the same
@export var speed_limit : float ## What is the player's max speed? 
@export var friction : float ## What friction should they experience on the ground?

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity = Vector2(0, 100)
	pass # Replace with function body.


func _get_input():
	if is_on_floor(): ##checks if character is touching the floor
		if Input.is_action_pressed("move_left"): #when input indicates a move left
			velocity += Vector2(-movement_speed,0) #increases horizontal velocity in the left direction 

		if Input.is_action_pressed("move_right"):#when input indicates a move right
			velocity += Vector2(movement_speed,0)#increases horizontal velocity in the right direction 

		if Input.is_action_just_pressed("jump"): # Jump only happens when we're on the floor (unless we want a double jump, but we won't use that here)
			velocity += Vector2(1,-jump_height) #subtracting jump height from y component of velocity causes upward movement

	if not is_on_floor(): #checks if character is in the air
		#adjusts the left or right movement speed to reflect whether the 
		#character is supposed to move at a different speed in the air than on the ground
		if Input.is_action_pressed("move_left"): 
			velocity += Vector2(-movement_speed * horizontal_air_coefficient,0)

		if Input.is_action_pressed("move_right"):
			velocity += Vector2(movement_speed * horizontal_air_coefficient,0)

func _limit_speed():
	if velocity.x > speed_limit: #prevents the character from moving too fast to the right
		velocity = Vector2(speed_limit, velocity.y) #resets velocity in the right-x direction to the speed limit
					#velocity in the y direction is unchanged

	if velocity.x < -speed_limit: #prevents the character from moving too fast to the left
		velocity = Vector2(-speed_limit, velocity.y) #resets velocity in the left-x direction to the speed limit
					#velocity in the y direction is unchanged

func _apply_friction():
	if is_on_floor() and not (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		# only applys friction if the player is not actively moving the character
		velocity -= Vector2(velocity.x * friction, 0) #apply the effects of friction, velocity is subtracted by 
		if abs(velocity.x) < 5:
			velocity = Vector2(0, velocity.y) # if the velocity in x gets close enough to zero, we set it to zero

func _apply_gravity():
	if not is_on_floor(): #when the character is in the air
		velocity += gravity #increases velocity by gravity, which acts as an acceleration

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#calls all of the helper functions each frame
	#to determine how the character should move
	_get_input()
	_limit_speed()
	_apply_friction()
	_apply_gravity()

	move_and_slide() #calculates slide behavior 
	pass
