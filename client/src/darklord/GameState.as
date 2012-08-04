package darklord
{
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;

	/**
	 * darklord.GameState
	 * 
	 * Virtual class to layout common update -> render cycle, handle event hooks
	 * links to engines scene object
	 * 
	 * */

		
	public class GameState
	{
		private var scene:Scene3D;
		private var view:View3D;
		public function GameState()
		{
			super();
		}
		
		private function init(scene,view)
		{
			this.scene = scene;
			this.view = view;
		}
		
		public function update()
		{
			
		}
		
		public function render()
		{
			
		}
	}
}