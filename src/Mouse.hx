package ;
import flash.display.Sprite;
import hxlpers.Rnd;
import hxlpers.shapes.Rect;

/**
 * ...
 * @author damrem
 */
class Mouse extends Sprite
{
	public var speed:Float;
	
	public function new() 
	{
		super();
		renew();
		addChild(new Rect(Rnd.int(8, 16), Rnd.int(8, 16)));
	}
	
	public function renew()
	{
		speed = Rnd.float(1.0, 2.0);
	}
	
}