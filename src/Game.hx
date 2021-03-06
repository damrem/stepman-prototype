package ;

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
	static public inline var WIDTH:Float = 1600.0;
	static public inline var GRAVITY:Float = 2.0;
	
	var hero:SteppingHero;
	var mice:Array<Mouse>;
	var mouseProvider:MouseProvider;
	
	var score:UInt;
	var tfScore:TextField;
	var ftScore:TextFormat;
	
	var world:Sprite;
	var hud:Sprite;
	
	var grounds:Array<Ground>;
	var groundProvider:Provider<Ground>;
	
	public function new() 
	{
		super();
		
		Font.registerFont(DefaultFont);
		ftScore = new TextFormat(new DefaultFont().fontName , 32.0, 0xff0000, true, false, false, null, null, TextFormatAlign.RIGHT);
		
		mouseProvider = new MouseProvider();
		mice = new Array<Mouse>();
		
		groundProvider = new Provider<Ground>(Ground);
		grounds = new Array<Ground>();
		
		world = new Sprite();
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
		
		grounds.push(groundProvider.provide());
		grounds.push(groundProvider.provide());
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
		generateMice();
		recycleMice();
		
		//hero.alpha = hero.isSteppingDown()?1.0:0.5;
		
		detectCollision();
		//trace("backLeg.x", hero.x + hero.backLeg.x, "backLeg.y", hero.backLeg.y + SteppingHero.LEG_HEIGHT * 2);
		
		scroll();
	}
	
	function scroll() 
	{
		var rect = world.scrollRect;
		rect.x = hero.body.x - stage.stageWidth/2;
		world.scrollRect = rect;
		
		trace("world.scrollRect", world.scrollRect);
		
		for (ground in grounds)
		{
			if (ground.getBounds(world).x < world.scrollRect.x - Ground.WIDTH)
			{
				ground.x += Ground.WIDTH * 2;
			}
			trace(ground.getBounds(stage));
			//ground.x = 
			if (ground.getBounds(world).x < world.scrollRect.x)
			{
				
			}
		}
	}
	
	function detectCollision()
	{
		var collidableMouse = new Array<Mouse>();
		for (mouse in mice)
		{
			if (mouse.x >= hero.x)
			{
				collidableMouse.push(mouse);
			}
		}
		for (mouse in collidableMouse)
		{
			var legBox:Rectangle = hero.backLeg.getBounds(this);
			var mouseBox:Rectangle = mouse.getBounds(this);
			
			if (Overlap.rectangles(legBox, mouseBox) && hero.isSteppingDown())
			{
				mouse.alpha = 0.25;
			}
			
		}
	}
	
	function generateMice()
	{
		if (Rnd.chance(0.01))
		{
			var mouse = mouseProvider.provide();
			mouse.x = 800;
			mouse.y = stage.stageHeight - Ground.HEIGHT - mouse.height;
			world.addChild(mouse);
			mice.push(mouse);
		}
	}
	
	function recycleMice()
	{
		var splices = new Array<UInt>();
		for (i in 0...mice.length)
		{
			var mouse = mice[i];
			mouse.x -= mouse.speed;
			if (mouse.x < -mouse.width && mouse.parent == this)
			{
				world.removeChild(mouse);
				splices.push(i);
				mouseProvider.retake(mouse);
			}
		}
		for (i in 0...splices.length)
		{
			mice.splice(splices[i], 1);
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
	
	
	
}