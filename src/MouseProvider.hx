package ;

/**
 * ...
 * @author damrem
 */
class MouseProvider
{
	var unusedMice:Array<Mouse>;
	
	public function new(size:UInt=256) 
	{
		trace("new");
		unusedMice = new Array<Mouse>();
		for (i in 0...size)
		{
			unusedMice.push(new Mouse());
		}
		//trace("unusedMice", unusedMice);
	}
	
	public function provide():Mouse
	{
		trace("provide");
		//trace("unusedMice", unusedMice);
		var mouse = unusedMice.pop();
		mouse.renew();
		return mouse;
	}
	
	public function retake(mouse:Mouse)
	{
		trace("retake");
		unusedMice.push(mouse);
	}
}