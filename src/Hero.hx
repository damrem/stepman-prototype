package ;

import flash.display.Sprite;
import helpers.shapes.Rect;
import openfl.Assets;
import spritesheet.AnimatedSprite;
import spritesheet.data.BehaviorData;
import spritesheet.importers.BitmapImporter;
import spritesheet.Spritesheet;

/**
 * ...
 * @author damrem
 */
class Hero extends Sprite
{
	var isControlled:Bool;
	var state:HeroState;
	
	static public inline var HEAD_WIDTH:Float = 4.0;
	static public inline var HEAD_HEIGHT:Float = 8.0;
	
	static public inline var BODY_WIDTH:Float = 12.0;
	static public inline var BODY_HEIGHT:Float = 16.0;

	static public inline var LEG_WIDTH:Float = 2.0;
	static public inline var LEG_HEIGHT:Float = 16.0;
	
	var head:Rect;
	var body:Rect;
	var leftLeg:Rect;
	var rightLeg:Rect;
	
	var frontLegX:Float;
	var backLegX:Float;
	
	public function new() 
	{
		super();
		
		/*
		leftLeg = new Rect(LEG_WIDTH, LEG_HEIGHT, 0xff0000);
		leftLeg.x = backLegX = -BODY_WIDTH / 2;
		leftLeg.y = -LEG_HEIGHT;
		
		rightLeg = new Rect(LEG_WIDTH, LEG_HEIGHT, 0xff0000);
		rightLeg.x = frontLegX = BODY_WIDTH / 2 - LEG_WIDTH;
		rightLeg.y = -LEG_HEIGHT;
		
		body = new Rect(BODY_WIDTH, BODY_HEIGHT, 0xff0000, 0, 0xffffff);
		body.x = -BODY_WIDTH / 2;
		body.y = -LEG_HEIGHT - BODY_HEIGHT;

		head = new Rect(HEAD_WIDTH, HEAD_HEIGHT, 0xff0000);
		head.x = - HEAD_WIDTH / 2;
		head.y = body.y - HEAD_HEIGHT;
		
		addChild(head);
		addChild(body);
		addChild(leftLeg);
		addChild(rightLeg);
		*/
		
		var bmd = Assets.getBitmapData('assets/img/hero.png');
		var sheet:Spritesheet = BitmapImporter.create(bmd, 7, 1, 16, 48);
		sheet.addBehavior(new BehaviorData('idle', [0]));
		sheet.addBehavior(new BehaviorData('step', [1, 2, 3, 4, 5, 6, 0]));
		var animated:AnimatedSprite = new AnimatedSprite(sheet);
		animated.showBehavior('idle');
		addChild(animated);
	}
	
	public function control()
	{
		isControlled = true;
	}
	
	function update()
	{
		switch(state)
		{
			case Standing:
				if (isControlled)
				{
					isControlled = false;
					state = LeftStep;
				}
				
			case LeftStep:
				step(leftLeg);
				
			case RightStep:
				step(rightLeg);
			
			case Jumping:
				
		}
	}
	
	function step(leg:Rect)
	{
		
	}
	
}

enum HeroState
{
	LeftStep;
	RightStep;
	Standing;
	Jumping;
}