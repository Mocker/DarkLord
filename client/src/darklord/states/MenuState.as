package darklord.states
{
	import away3d.containers.View3D;
	
	import darklord.GameState;
	
	import flash.events.Event;
	
	public class MenuState extends GameState
	{
		public function MenuState()
		{
			super();
		}
		
		override public function init(view:View3D):void
		{
			super.init(view);
			trace("Menu state initialized");
			
		}
		
		override public function onMouseClick(ev:Event):void
		{
			trace("click!");
			trace(ev);
		}
		
		override public function update():void
		{
			
			super.update();
		}
		
		override public function render():void
		{
			
			super.render();
		}
	}
}