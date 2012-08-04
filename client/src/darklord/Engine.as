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
	
	import darklord.states.MenuState;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	
	public class Engine extends Sprite
	{
		private var states:Array = new Array();
		private var scene:Scene3D;
		private var view:View3D;
		private var awayStats:AwayStats;
		private var menu:MenuState;
		public var net:NetManager;
		
		public const gameWidth:int = 800;
		public const gameHeight:int = 600;

		
		public function Engine():void
		{
			this.mouseChildren = true;
			this.name = "game engine";
			trace(this.name);
		}
		
		//init- create scene/view and first game state stack
		public function init():void
		{
			this.net = new NetManager(this);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			view = new View3D();
			view.backgroundColor = 0x662222;
			view.antiAlias = 4;
			view.name = "3d view";
			
			addChild(view);
			
			awayStats = new AwayStats(view);
			addChild(awayStats);
			
			initListeners();
			initState();
		}
		
		//load first menu state push it onto the stack
		private function initState():void
		{
			menu = new MenuState(this);
			menu.init(view);
			states.push(menu);
			
			addChildAt(menu,1);
			
		}
			
		private function initListeners():void
		{
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.addEventListener(MouseEvent.CLICK, onMouseClick);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseDown);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		//run - enable game loop to run update/render
		public function run():void
		{
			
		}
		
		//pause - disable all update/render loops passing through to stack
		public function pause():void
		{
			
		}
		
		
		// INPUT HANDLERS //
		private function onMouseClick(ev:Event):void 
		{
			if(states.length < 1) return;
			
			(states[0] as GameState).onMouseClick(ev);
		}
		private function onMouseUp(ev:Event):void 
		{
			if(states.length < 1) return;
			(states[0] as GameState).onMouseUp(ev);
		}
		private function onMouseDown(ev:Event):void 
		{
			if(states.length < 1) return;
			(states[0] as GameState).onMouseDown(ev);
		}
		
		private function onKeyDown(ev:Event):void 
		{
			if(states.length < 1) return;
			(states[0] as GameState).onKeyDown(ev);
		}
		private function onKeyUp(ev:Event):void 
		{
			if(states.length < 1) return;
			(states[0] as GameState).onKeyUp(ev);
		}
		
		//Network Events
		public function onNetConnect(ev):void
		{
			trace("connected to the server!");
			if(states.length < 1) return;
			(states[0] as GameState).onNetConnect(ev);
		}
		public function onNetMSG(ev):void
		{
			trace(ev);
			if(states.length < 1) return;
			(states[0] as GameState).onNetMSG(ev);
		}
		public function onNetClose(ev):void
		{
			if(states.length < 1) return;
			(states[0] as GameState).onNetClose(ev);
		}
		public function onNetError(ev):void
		{
			trace("Network error!");
			trace(ev);
		}
		
		
		//UPDATE->RENDER loop
		private function onEnterFrame(ev:Event):void 
		{
			if(states.length < 1) return; //no states on the stack
			var state = states[0]; //grab first state on the stack
			var currentState:GameState = state as GameState;
			
			currentState.update();
			currentState.render();
			
			
			
			//view.render();
		}
	}
}