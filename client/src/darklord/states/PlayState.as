package darklord.states
{
	import away3d.containers.View3D;
	
	import darklord.Engine;
	import darklord.GameState;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.*;
	import flash.utils.*;
	
	public class PlayState extends GameState
	{
		
		
		
		public function PlayState(engine:Engine)
		{
			super(engine);
			this.name = "PlayState";
		}
		
		
		override public function init(view):void 
		{
			super.init(view);
		}
		
		override public function onMouseClick(ev:Event):void
		{
			
		}
		
		override public function onKeyDown(ev:Event):void
		{
			
		}
		
		override public function onKeyUp(ev:Event):void
		{
			
		}
		
	}
}