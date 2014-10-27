package ;

import flash.display.Sprite;
import hxlpers.shapes.Rect;

/**
 * ...
 * @author damrem
 */
class Ground extends Sprite
{
	static public inline var WIDTH:Float = 1600.0;
	static public inline var HEIGHT:Float = 64.0;

	public function new() 
	{
		super();
		addChild(new Rect(WIDTH, HEIGHT));
	}
	
}