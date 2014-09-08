package;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.group.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;


class PlayState extends FlxState
{
private var _player:Player;
private var _map:FlxOgmoLoader;
private var _mWalls:FlxTilemap;
private var _gprCoins:FlxTypedGroup<Coin>;
private var _gprEnemies:FlxTypedGroup<Enemy>;

	
	override public function create():Void
	{
		_map = new FlxOgmoLoader(AssetPaths.room_001__oel);
		_mWalls = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "walls");
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);
		add(_mWalls);
		
		_gprCoins = new FlxTypedGroup<Coin>();
		add(_gprCoins);
		
		_gprEnemies = new FlxTypedGroup<Enemy>();
		add(_gprEnemies);
		
		_player = new Player();
		_map.loadEntities(placeEntities, "entities");
		add(_player);
		
		FlxG.camera.follow(_player, FlxCamera.STYLE_TOPDOWN, 1);	
		
		super.create();
	}
	

	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		super.update();
		
		FlxG.collide(_player, _mWalls);
		FlxG.overlap(_player, _gprCoins, playerTouchCoin);
		
		FlxG.collide(_gprEnemies, _mWalls);
		_gprEnemies.forEachAlive(checkEnemyVision);
	}	
	
	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "player")
		{
			_player.x = x;
			_player.y = y;
		}
		else if (entityName == "coin")
		{
			_gprCoins.add(new Coin(x + 4, y + 4));
		}
		else if (entityName == "enemy")
		{
			_gprEnemies.add(new Enemy(x + 4, y, Std.parseInt(entityData.get("etype"))));
		}
	}
	
	private function playerTouchCoin(P:Player, C:Coin):Void
	{
		if (P.alive && C.alive && C.exists)
		{
			C.kill();
		}
	}
	
	private function checkEnemyVision(e:Enemy):Void
	{
		if (_mWalls.ray(e.getMidpoint(), _player.getMidpoint()))
		{
			e.seesPlayer = true;
			e.playerPos.copyFrom(_player.getMidpoint());
		}
		else
		e.seesPlayer = false;
	}
	
}