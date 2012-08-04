package
{
	import darklord.Engine;
	
	import flash.display.Sprite;
	
	public class DarkLord extends Sprite
	{
		private var engine:Engine;
		public function DarkLord()
		{
		
			engine = new Engine();
			this.addChild(engine);
			engine.init();
		}
	}
}