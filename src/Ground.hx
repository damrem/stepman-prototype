package ;

import flash.display.Shape;
import flash.display.Sprite;
import hxlpers.Rnd;
import hxlpers.shapes.Rect;

/**
 * ...
 * @author damrem
 */
class Ground extends Sprite
{
	static public var WIDTH:Float = 800.0;
	static public inline var HEIGHT:Float = 64.0;
	static inline var GRANULARITY:UInt = 64;
	public var finalHeightOffset:Float;
	var shape:Shape;

	public function new()
	{
		super();
		trace("new");
		shape = new Shape();
		addChild(shape);
		
		var g = shape.graphics;
		g.clear();
		g.beginFill(0xff0000);
		g.moveTo(0, finalHeightOffset);
		for (X in 0...GRANULARITY)
		{
			finalHeightOffset = Rnd.float( -1, 0);
			g.lineTo((X + 1) * WIDTH / GRANULARITY, finalHeightOffset);
		}
		g.lineTo(WIDTH, HEIGHT);
		g.lineTo(0, HEIGHT);
		g.lineTo(0, 0);
		g.endFill();
	}
}