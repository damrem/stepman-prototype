package ;

import flash.display.Sprite;
import flash.Lib;
import helpers.geom.V2d;
import helpers.shapes.Rect;
import motion.actuators.GenericActuator.IGenericActuator;
import motion.easing.Linear;
import openfl.Assets;
import spritesheet.AnimatedSprite;
import spritesheet.data.BehaviorData;
import spritesheet.importers.BitmapImporter;
import spritesheet.Spritesheet;
import motion.Actuate;
import motion.MotionPath;

/**
 * ...
 * @author damrem
 */
class SteppingHero extends Sprite
{
	var isControlled:Bool;
	var state:HeroState;
	
	static public inline var LEG_WIDTH:Float = 16.0;
	static public inline var LEG_HEIGHT:Float = 48.0;
	
	static public inline var STEP_LENGTH:Float = 96.0;
	static public inline var STEP_HALFLENGTH:Float = STEP_LENGTH / 2;
	static public inline var STEP_HEIGHT:Float = STEP_LENGTH / 4;
	static public inline var STEP_DURATION:Float = 0.25;
	
	static public inline var BODY_WIDTH:Float = STEP_HALFLENGTH + LEG_WIDTH;
	static public inline var BODY_HALFWIDTH:Float = BODY_WIDTH / 2;
	static public inline var BODY_HEIGHT:Float = BODY_WIDTH * 2;
	
	var leftLeg:Rect;
	var rightLeg:Rect;
	var backLeg:Rect;
	
	var body:Rect;
	
	public var velocity:V2d;
	public var acceleration:V2d;
	
	public function new() 
	{
		super();
		
		trace("new");
		
		state = Standing;
		
		acceleration = new V2d();
		velocity = new V2d();
		
		leftLeg = backLeg = new Rect(LEG_WIDTH, LEG_HEIGHT);
		leftLeg.x -= STEP_HALFLENGTH / 2;
		leftLeg.y -= LEG_HEIGHT;
		addChild(leftLeg);
		
		rightLeg = new Rect(LEG_WIDTH, LEG_HEIGHT);
		rightLeg.x += STEP_HALFLENGTH / 2;
		rightLeg.y -= LEG_HEIGHT;
		addChild(rightLeg);
		
		body = new Rect(BODY_WIDTH, BODY_HEIGHT);
		updateBody();
		addChild(body);
	}
	
	function updateBody() 
	{
		//body.x = (leftLeg.x + rightLeg.x) / 2 - LEG_WIDTH * 2;
		body.x = Math.min(leftLeg.x, rightLeg.x);
		body.y = (leftLeg.y + rightLeg.y) / 2 - BODY_HEIGHT + 8;// - LEG_HEIGHT;
		body.width = Math.abs(rightLeg.x - leftLeg.x) + LEG_WIDTH;
	}
	
	public function update()
	{
		velocity.x += acceleration.x;
		velocity.y += acceleration.y;
		//trace("velocity", velocity);
		x += velocity.x;
		y += velocity.y;
	}
	
	public function control()
	{
		trace("control");
		
		switch(state)
		{
			case Standing:
				step();
				
			case Stepping:
				jump();
			
			case Jumping:
				land();
		}
	}
	
	function land() 
	{
		Actuate.resume(backLeg);
	}
	
	function jump() 
	{
		trace("jump");
		state = Jumping;
		Actuate.pause(backLeg);
		
		acceleration.y -= 10;
		trace("acceleration", acceleration);
	}
	
	function step()
	{
		trace("step");
		state = Stepping;
		var path = new MotionPath().bezier(backLeg.x + STEP_LENGTH, backLeg.y, backLeg.x + STEP_HALFLENGTH, backLeg.y - STEP_HEIGHT);
		Actuate.motionPath(backLeg, STEP_DURATION, { x:path.x, y:path.y } ).ease(Linear.easeNone).onUpdate(updateBody).onComplete(finishStep);
	}
	
	function finishStep() 
	{
		state = Standing;
		if (backLeg == leftLeg)
		{
			backLeg = rightLeg;
		}
		else
		{
			backLeg = leftLeg;
		}
	}
	
	
	
}

enum HeroState
{
	Standing;
	Stepping;
	Jumping;
}