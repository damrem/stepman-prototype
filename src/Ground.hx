package ;

import flash.display.Shape;
import flash.display.Sprite;
import hxlpers.Rnd;
import hxlpers.shapes.Rect;

/**
 * ...
 * @author damrem
 */
class Ground extends Sprite implements IRenewable
{
	static public inline var HEIGHT:Float = 64.0;
	static inline var GRANULARITY:UInt = 64;
	
	var _finalHeightOffset:Float;
	public var finalHeightOffset(get, null):Float;
	
	var initialHeightOffset:Float;
	var _width:Float;
	
	var shape:Shape;

	public function new(Width:Float, InitialHeightOffset:Float=0.0)
	{
		super();
		_width = Width;
		initialHeightOffset = InitialHeightOffset;
		shape = new Shape();
		renew();
		addChild(shape);
	}
	
	/* INTERFACE IRenewable */
	public function renew():Void 
	{
		var g = shape.graphics;
		g.clear();
		g.beginFill(Rnd.int(0xff0000));
		g.moveTo(0, initialHeightOffset);
		for (X in 0...GRANULARITY)
		{
			_finalHeightOffset = Rnd.float( -1, 0);
			g.lineTo((X + 1) * _width / GRANULARITY, _finalHeightOffset);
		}
		g.lineTo(_width, HEIGHT);
		g.lineTo(0, HEIGHT);
		g.lineTo(0, 0);
		g.endFill();
	}
	
	function get_finalHeightOffset():Float 
	{
		return _finalHeightOffset;
	}
	
}