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
import hxlpers.Range;
import hxlpers.Rnd;
import hxlpers.shapes.Rect;
//import h2d.Scene;

@:font('assets/fonts/PressStart2P-Regular.ttf') class DefaultFont extends Font {}

/**
 * ...
 * @author damrem
 */
class Game extends Sprite
{
	static public inline var GROUND_Y:Float = 400.0;
	static public inline var GRAVITY:Float = 2.0;
	
	var hero:SteppingHero;
	var mice:Array<Mouse>;
	var mouseProvider:MouseProvider;
	
	var score:UInt;
	var tfScore:TextField;
	var ftScore:TextFormat;
	
	public function new() 
	{
		super();
		
		addEventListener(Event.ADDED_TO_STAGE, onStage);
	}
	
	function onStage(e:Event)
	{
		removeEventListener(Event.ADDED_TO_STAGE, onStage);
		
		hero = new SteppingHero();
		hero.x = 50;
		hero.y = GROUND_Y;
		hero.onStep.add(incScore);
		
		mouseProvider = new MouseProvider();
		mice = new Array<Mouse>();
		
		var ground = new Rect(800, 2, 0xff0000);
		ground.y = GROUND_Y;

		addChild(ground);
		addChild(hero);
		
		Font.registerFont(DefaultFont);
		
		tfScore = new TextField();
		ftScore = new TextFormat(new DefaultFont().fontName , 32.0, 0xff0000, true, false, false, null, null, TextFormatAlign.RIGHT);
		tfScore.defaultTextFormat = ftScore;
		tfScore.text = "" + score;
		tfScore.x = stage.stageWidth - 20 - tfScore.width;
		tfScore.y = 20;
		tfScore.embedFonts = true;
		tfScore.selectable = false;
		
		addChild(tfScore);
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
			trace("legBox", legBox);
			
			//if(hero.isSteppingDown() && bound.x
		}
	}
	
	function generateMice()
	{
		if (Rnd.chance(0.01))
		{
			var mouse = mouseProvider.provide();
			mouse.x = 800;
			mouse.y = GROUND_Y - mouse.height;
			addChild(mouse);
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
			if (mouse.x < -mouse.width)
			{
				removeChild(mouse);
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