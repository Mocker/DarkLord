package
{
	import darklord.Engine;
	
	import flash.display.Sprite;
	
	[SWF(backgroundColor="#000000", frameRate="30", quality="LOW",width="960",height="540")]
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