package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import helpers.geom.V2d;
import helpers.Rnd;
import helpers.shapes.Rect;
import openfl.Assets;
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
	
	private function update(e:Event):Void 
	{
		if (Rnd.chance(0.01))
		{
			var mouse = mouseProvider.provide();
			mouse.x = 800;
			mouse.y = GROUND_Y - mouse.height;
			addChild(mouse);
			mice.push(mouse);
		}
		
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
		trace("onKeyUp");
		hero.freeze();
	}
	
	function onKeyDown(event:KeyboardEvent)
	{
		trace("onKeyUp");
		hero.advance();
	}
	
	
	
}