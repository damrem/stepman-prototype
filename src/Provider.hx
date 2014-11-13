package ;

/**
 * ...
 * @author damrem
 */
class Provider<T:IRenewable>
{
	var unused:Array<T>;
	var cl:Class<T>;
	public var nbProvided:UInt;
	public var nbRetaken:UInt;
	
	public function new(Cl:Class<T>, size:UInt=256) 
	{
		trace("new");
		cl = Cl;
		unused = new Array<T>();
		
		nbProvided = 0;
		nbRetaken = 0;
		
		for (i in 0...size)
		{
			unused.push(Type.createInstance(cl, []));
		}
		//trace("unusedMice", unusedMice);
	}
	
	public function provide():T
	{
		trace("provide");
		//trace("unusedMice", unusedMice);
		var item:T;
		if (unused.length > 0)
		{
			item = unused.pop();
			item.renew();
		}
		else
		{
			item = Type.createInstance(cl, []);
		}
		nbProvided++;
		return item;
	}
	
	public function retake(item:T):T
	{
		trace("retake");
		unused.push(item);
		nbRetaken++;
		return item;
	}
}