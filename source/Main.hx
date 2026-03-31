package;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import openfl.system.Capabilities;

import flixel.FlxGame;
import flixel.FlxG;
import flixel.util.FlxColor;

class Main extends Sprite
{
    public static var WIDTH:Int = 1280;
    public static var HEIGHT:Int = 720;
    public static var ZOOM:Float = -1; // auto
    public static var FRAMERATE:Int = 60;

    public function new()
    {
        super();

        if (stage != null)
            init();
        else
            addEventListener(Event.ADDED_TO_STAGE, init);
    }

    function init(?e:Event):Void
    {
        if (e != null)
            removeEventListener(Event.ADDED_TO_STAGE, init);

        setupGame();
    }

    function setupGame():Void
    {
        var stageWidth:Int = Lib.current.stage.stageWidth;
        var stageHeight:Int = Lib.current.stage.stageHeight;

        // Auto zoom inteligente
        if (ZOOM == -1)
        {
            var ratioX:Float = stageWidth / WIDTH;
            var ratioY:Float = stageHeight / HEIGHT;
            ZOOM = Math.min(ratioX, ratioY);
        }

        var gameWidth:Int = Math.ceil(stageWidth / ZOOM);
        var gameHeight:Int = Math.ceil(stageHeight / ZOOM);

        // Criar o jogo
        var game = new FlxGame(
            gameWidth,
            gameHeight,
            PlayState,
            ZOOM,
            FRAMERATE,
            FRAMERATE,
            true // skip splash
        );

        addChild(game);

        setupSettings();
    }

    function setupSettings():Void
    {
        // FPS fixo
        FlxG.updateFramerate = FRAMERATE;
        FlxG.drawFramerate = FRAMERATE;

        // Debug automático (PC)
        #if debug
        FlxG.debugger.visible = true;
        #else
        FlxG.debugger.visible = false;
        #end

        // Fundo padrão
        FlxG.cameras.bgColor = FlxColor.BLACK;

        // Mobile ajustes
        #if mobile
        FlxG.autoPause = false;
        #end

        // Fullscreen toggle (F11)
        #if desktop
        openfl.Lib.current.stage.addEventListener(openfl.events.KeyboardEvent.KEY_DOWN, function(e)
        {
            if (e.keyCode == 122) // F11
            {
                FlxG.fullscreen = !FlxG.fullscreen;
            }
        });
        #end

        // Info do sistema (debug)
        trace("=== Sonic Legacy Engine ===");
        trace("OS: " + Capabilities.os);
        trace("Is Mobile: " + (Capabilities.mobile ? "Yes" : "No"));
        trace("Resolution: " + Lib.current.stage.stageWidth + "x" + Lib.current.stage.stageHeight);
    }
}
