package darklord
{
	/**
	 darklord.Engine
	 * Main game engine for Dark Lord 
	 * handles game state stack, core scene/view objects
	 * and passing render/update events through to current stack
	 * **/
	import away3d.cameras.*;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.*;
	import away3d.debug.*;
	import away3d.events.LoaderEvent;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.Parsers;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	public class Engine extends Sprite
	{
		private var states:Array = new Array();
		private var scene:Scene3D;
		private var view:View3D;
		private var awayStats:AwayStats;
		
		public function Engine():void
		{
		}
		
		//init- create scene/view and first game state stack
		public function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			view = new View3D();
			view.backgroundColor = 0x662222;
			view.antiAlias = 4;
			
			awayStats = new AwayStats(view);
			addChild(awayStats);
		}
		
		//run - enable game loop to run update/render
		public function run():void
		{
			
		}
		
		//pause - disable all update/render loops passing through to stack
		public function pause():void
		{
			
		}
	}
}