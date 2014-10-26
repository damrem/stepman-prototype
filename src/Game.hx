package ;

import flash.display.Sprite;
import flash.events.KeyboardEvent;

/**
 * ...
 * @author damrem
 */
class Game extends Sprite
{
	var hero:Hero;
	
	public function new() 
	{
		super();
		hero = new Hero();
		hero.x = hero.y = 100;
		addChild(hero);
	}
	
	public function start() 
	{
		addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	
	public function pause()
	{
		removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	
	function onKeyUp(event:KeyboardEvent)
	{
		hero.control();
	}
	
	
	
}