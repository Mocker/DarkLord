package
{
	import darklord.Engine;
	
	import flash.display.Sprite;
	
	[SWF(backgroundColor="#000000", frameRate="30", quality="LOW",width="800",height="600")]
	public class DarkLord extends Sprite
	{
		private var engine:Engine;
		
		public function DarkLord()
		{
			trace("main name: "+this.name);
			engine = new Engine();
			this.addChild(engine);
			engine.init();
		}
	}
}