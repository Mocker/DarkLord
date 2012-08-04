package darklord
{
	import flash.events.*;
	import flash.net.XMLSocket;

	/**
	 * darklord.NetManager
	 * implements an xmlserver socket connections and handles passing message between socket and engine
	 * */
	
	public class NetManager
	{
		private var xmlserver:XMLSocket;
		private var eng:Engine;
		public var isConnected:Boolean = false;
		public const SERVERIP:String = "darklord.thegup.com";
		public const SERVERPORT:Number = 9001;
		
		
		public function NetManager(engine)
		{
			this.eng = engine;
		}
		
		public function connect():void
		{
			xmlserver = new XMLSocket(SERVERIP,SERVERPORT);
			xmlserver.addEventListener(Event.CONNECT, onConnect);  
			xmlserver.addEventListener(IOErrorEvent.IO_ERROR, onError);
			
		}
		
		public function sendData(data:*):void
		{
			
			xmlserver.send(data);
		}
		
		private function onConnect(ev:Event):void 
		{
			this.isConnected = true;
			xmlserver.addEventListener(DataEvent.DATA, onDataReceived);  
			xmlserver.addEventListener(Event.CLOSE, onSocketClose);
			eng.onNetConnect(null);
		}
		
		private function onError(ev:IOErrorEvent):void
		{
			
		}
		
		private function onDataReceived(ev:DataEvent):void
		{
			eng.onNetMSG(ev.text);
		}
		
		private function onSocketClose(ev:Event):void
		{
			this.isConnected = false;
			eng.onNetClose(ev);
		}
		
		
	}
}