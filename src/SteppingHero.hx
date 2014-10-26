package ;

import flash.display.Sprite;
import flash.Lib;
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
	
	static public inline var STEP_LENGTH:Float = 64.0;
	static public inline var STEP_HALFLENGTH:Float = STEP_LENGTH / 2;
	static public inline var STEP_HEIGHT:Float = 16.0;
	static public inline var STEP_DURATION:Float = 0.25;
	
	static public inline var BODY_WIDTH:Float = 16.0;
	static public inline var BODY_HALFWIDTH:Float = BODY_WIDTH / 2;
	static public inline var BODY_HEIGHT:Float = 32.0;	
	
	var leftFoot:Rect;
	var rightFoot:Rect;
	var backFoot:Rect;
	
	var body:Rect;
	
	public function new() 
	{
		super();
		
		trace("new");
		
		state = Standing;
		
		leftFoot = backFoot = new Rect(8, 2);
		leftFoot.x -= STEP_HALFLENGTH / 2;
		addChild(leftFoot);
		
		rightFoot = new Rect(8, 2);
		rightFoot.x += STEP_HALFLENGTH / 2;
		addChild(rightFoot);
		
		body = new Rect(BODY_WIDTH, BODY_HEIGHT);
		
		update();
		addChild(body);
	}
	
	public function update() 
	{
		body.x = (leftFoot.x + rightFoot.x - BODY_HALFWIDTH) / 2;
		body.y = (leftFoot.y + rightFoot.y) / 2 - 48;
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
		Actuate.resume(backFoot);
	}
	
	function jump() 
	{
		trace("jump");
		state = Jumping;
		Actuate.pause(backFoot);
	}
	
	function step()
	{
		trace("step");
		state = Stepping;
		var path = new MotionPath().bezier(backFoot.x + STEP_LENGTH, backFoot.y, backFoot.x + STEP_HALFLENGTH, backFoot.y - STEP_HEIGHT);
		Actuate.motionPath(backFoot, STEP_DURATION, { x:path.x, y:path.y } ).ease(Linear.easeNone).onComplete(finishStep);
	}
	
	function finishStep() 
	{
		state = Standing;
		if (backFoot == leftFoot)
		{
			backFoot = rightFoot;
		}
		else
		{
			backFoot = leftFoot;
		}
	}
	
	
	
}

enum HeroState
{
	Standing;
	Stepping;
	Jumping;
}