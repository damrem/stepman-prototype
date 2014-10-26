package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;

/**
 * ...
 * @author damrem
 */
class Game extends Sprite
{
	var hero:SteppingHero;
	
	public function new() 
	{
		super();
		hero = new SteppingHero();
		hero.x = 50;
		hero.y = 400;
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