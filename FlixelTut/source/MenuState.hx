package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
using flixel.util.FlxSpriteUtil;
import flixel.util.FlxDestroyUtil;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	private var _btnPlay:FlxButton;
	
	private function clickPlay():Void
	{
		FlxG.switchState(new PlayState());
	}
	
	override public function create():Void
	{	
		_btnPlay = new FlxButton(0, 0, "Play", clickPlay);
		add(_btnPlay);
		
		_btnPlay.screenCenter();
		
		super.create();
	}
	

	override public function destroy():Void
	{
		super.destroy();
		
		_btnPlay = FlxDestroyUtil.destroy(_btnPlay);
	}


	override public function update():Void
	{
		super.update();
	}	
}