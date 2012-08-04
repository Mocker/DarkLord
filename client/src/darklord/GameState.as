package darklord
{
	
	
	/**
	 * darklord.GameState
	 * 
	 * Virtual class to layout common update -> render cycle, handle event hooks
	 * links to engines scene object
	 * 
	 * */
	
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	
	import flash.display.Sprite;
	import flash.events.Event;

		
	public class GameState extends Sprite
	{
		private var scene:Scene3D;
		private var view:View3D;
		public var eng:Engine;
		public function GameState(engine:Engine):void
		{
			super();
			this.eng = engine;
			this.mouseEnabled = true;
			this.mouseChildren = true;
			this.name = "game state";
		}
		
		public function init(view:View3D):void
		{
			this.scene = view.scene;
			this.view = view;
		}
		
		
		public function update():void
		{
			
		}
		
		public function render():void
		{
			view.render();
		}
		
		
		
		//INPUT handlers - state overwrites any it needs
		// INPUT HANDLERS //
		public function onMouseClick(ev:Event):void 
		{
			
		}
		public function onMouseUp(ev:Event):void 
		{
			
		}
		public function onMouseDown(ev:Event):void 
		{
			
		}
		
		public function onKeyDown(ev:Event):void 
		{
			
		}
		public function onKeyUp(ev:Event):void 
		{
			
		}
		
		//place holders for network events
		public function onNetConnect(ev):void
		{
			
		}
		public function onNetMSG(ev):void
		{
			
		}
		public function onNetClose(ev):void
		{
			
		}
	}
}