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

	import flash.events.Event;

		
	public class GameState
	{
		private var scene:Scene3D;
		private var view:View3D;
		public function GameState():void
		{
			super();
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
		public function onNetConnect():void
		{
			
		}
		public function onNetMSG():void
		{
			
		}
	}
}