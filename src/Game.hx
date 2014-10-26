package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import helpers.geom.V2d;
import helpers.shapes.Rect;
//import h2d.Scene;

/**
 * ...
 * @author damrem
 */
class Game extends Sprite
{
	static public inline var GROUND_Y:Float = 400.0;
	static public inline var GRAVITY:Float = 2.0;
	
	var hero:SteppingHero;
	
	public function new() 
	{
		super();
		
		hero = new SteppingHero();
		hero.x = 50;
		hero.y = GROUND_Y;
		
		var ground = new Rect(800, 2, 0xff0000);
		ground.y = GROUND_Y;

		addChild(ground);
		addChild(hero);
	}
	
	public function start() 
	{
		trace("start");
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	private function update(e:Event):Void 
	{
		hero.update();
		if (hero.y < GROUND_Y)
		{
			hero.acceleration.y += GRAVITY;
		}
		else 
		{
			trace("landing");
			hero.y = GROUND_Y;
			hero.acceleration.y = 0;
		}
	}
	
	public function pause()
	{
		trace("pause");
		removeEventListener(Event.ENTER_FRAME, update);
		stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	
	function onKeyUp(event:KeyboardEvent)
	{
		trace("onKeyUp");
		hero.control();
	}
	
	
	
}