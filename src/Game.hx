package ;

import openfl.text.TextFieldAutoSize;
import openfl.utils.Object;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.geom.Rectangle;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import hxlpers.Overlap;
import hxlpers.Rnd;
//import h2d.Scene;

@:font('assets/fonts/PressStart2P-Regular.ttf') class DefaultFont extends Font {}

/**
 * ...
 * @author damrem
 */
class Game extends Sprite
{
	public static var verbose:Bool = true;
	var hero:SteppingHero;
	var dwarves:Array<Dwarf>;
	var dwarfProvider:Provider<Dwarf>;
	
	var score:UInt;
	var tfScore:TextField;
	var ftScore:TextFormat;
	
	var world:Sprite;
	var hud:Sprite;
	
	var grounds:Array<Ground>;
	
	var watcheds:Array<Watched>;
	var monitor:TextField;
	var collidableDwarves:Array<Dwarf>;
	
	public function new() 
	{
		super();
		
		Font.registerFont(DefaultFont);
		ftScore = new TextFormat(new DefaultFont().fontName , 32.0, 0xff0000, true, false, false, null, null, TextFormatAlign.RIGHT);
		
		watcheds = new Array<Watched>();
		monitor = new TextField();
		monitor.background = true;
		monitor.autoSize = TextFieldAutoSize.LEFT;
		
		dwarfProvider = new Provider<Dwarf>(Dwarf);
		watch(dwarfProvider, 'nbProvided', "dwarfProvider");
		watch(dwarfProvider, 'nbRetaken', "dwarfProvider");
		dwarves = new Array<Dwarf>();
		watch(dwarves, 'length', "dwarves");
		
		collidableDwarves = new Array<Dwarf>();
		watch(collidableDwarves, 'length', "collidable");
		
		grounds = new Array<Ground>();
		
		world = new Sprite();
		watch(world, 'scrollRect', "world");
		hud = new Sprite();
				
		addEventListener(Event.ADDED_TO_STAGE, onStage);
	}
	
	function onStage(e:Event)
	{
		removeEventListener(Event.ADDED_TO_STAGE, onStage);
		
		world.scrollRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
		addChild(world);
		
		addChild(hud);
		
		hero = new SteppingHero();
		//hero.x = 50;
		hero.y = stage.stageHeight - Ground.HEIGHT;
		hero.onStep.add(incScore);
		
		Ground.WIDTH = stage.stageWidth;
		
		grounds.push(new Ground());
		grounds.push(new Ground());
		grounds[1].x = Ground.WIDTH;
		grounds[0].y = grounds[1].y = stage.stageHeight - Ground.HEIGHT;

		world.addChild(grounds[0]);
		world.addChild(grounds[1]);
		world.addChild(hero);

		trace(grounds[0].getBounds(world));
		
		tfScore = new TextField();
		tfScore.defaultTextFormat = ftScore;
		tfScore.text = "" + score;
		tfScore.x = stage.stageWidth - 20 - tfScore.width;
		tfScore.y = 20;
		tfScore.embedFonts = true;
		tfScore.selectable = false;
		
		hud.addChild(tfScore);
		
		addChild(monitor);
	}
	
	function incScore() 
	{
		trace("incScore");
		score++;
		tfScore.text = "" + score;
		tfScore.setTextFormat(ftScore);
		
	}
	
	public function start() 
	{
		trace("start");
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function update(e:Event):Void 
	{
		generateDwarves();
		
		//hero.alpha = hero.isSteppingDown()?1.0:0.5;
		
		detectCollision();
		recycleDwarves();
		//trace("backLeg.x", hero.x + hero.backLeg.x, "backLeg.y", hero.backLeg.y + SteppingHero.LEG_HEIGHT * 2);
		
		scroll();
		
		updateMonitor();
	}
	
	function updateMonitor() 
	{
		monitor.text = "";
		for (watched in watcheds)
		{
			monitor.text += (watched.label == ""? watched.obj: watched.label) + "." + watched.prop + " = " + Reflect.field(watched.obj, watched.prop) + "\n";
		}
	}
	
	function scroll() 
	{
		var rect = world.scrollRect;
		rect.x = hero.body.x - stage.stageWidth/2;
		world.scrollRect = rect;
		
		//trace("world.scrollRect", world.scrollRect);
		
		for (ground in grounds)
		{
			if (ground.getBounds(world).x < world.scrollRect.x - Ground.WIDTH)
			{
				ground.x += Ground.WIDTH * 2;
			}
		}
	}
	
	function detectCollision()
	{
		untyped collidableDwarves.length = 0;
		//trace("hero", hero.body.x);
		for (dwarf1 in dwarves)
		{
			//trace("dwarf", dwarf.x);
			if (dwarf1.x >= hero.body.x)
			{
				collidableDwarves.push(dwarf1);
			}
			else
			{
				
				dwarf1.alpha = 0.75;
			}
			
		}
		for (dwarf2 in collidableDwarves)
		{
			var legBox:Rectangle = hero.backLeg.getBounds(world);
			var dwarfBox:Rectangle = dwarf2.getBounds(world);
			
			if (Overlap.rectangles(legBox, dwarfBox) && hero.isSteppingDown())
			{
				dwarf2.alpha = 0.25;
			}
			
		}
	}
	
	function generateDwarves()
	{
		if (Rnd.chance(0.1))
		{
			var dwarf = dwarfProvider.provide();
			dwarf.x = world.scrollRect.x + world.scrollRect.width;
			dwarf.y = stage.stageHeight - Ground.HEIGHT - dwarf.height;
			world.addChild(dwarf);
			if (verbose && dwarves.indexOf(dwarf) >= 0)	trace("dwarf already in dwarves");
			dwarves.push(dwarf);
		}
	}
	
	function recycleDwarves()
	{
		var splices = new Array<UInt>();
		for (i in 0...dwarves.length)
		{
			var dwarf = dwarves[i];
			dwarf.x -= dwarf.speed;
			if (dwarf.x < world.scrollRect.x - dwarf.width)
			{
				if (verbose && dwarf.parent == null)	trace("parent null");
				if(dwarf.parent != null)
				try
				{
					if (verbose)	trace("recycleDwarves");
					dwarf.parent.removeChild(dwarf);
					splices.push(i);
					dwarfProvider.retake(dwarf);
				}
				catch (msg:String)
				{
					if(verbose)	trace(msg+":"+i);
				}
			}
		}
		trace(splices);
		for (i in 0...splices.length)
		{
			dwarves[splices[i]].y = 250;
			dwarves.splice(splices[i], 1);
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
		hero.freeze();
	}
	
	function onKeyDown(event:KeyboardEvent)
	{
		hero.advance();
	}
	
	function watch(obj:Object, prop:String, ?label:String = "")
	{		
		watcheds.push({ obj:obj, prop:prop, label:label });
	}
	
}

typedef Watched = {
	var obj:Object;
	var prop:String;
	var label:String;
}