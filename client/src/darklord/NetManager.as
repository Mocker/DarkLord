package darklord
{
	import com.facebook.graph.Facebook;
	
	import darklord.Config;
	import darklord.net.NetMSG;
	
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.XMLSocket;
	import flash.net.navigateToURL;
	import flash.system.Security;

	/**
	 * darklord.NetManager
	 * implements an xmlserver socket connections and handles passing message between socket and engine
	 * Also handles facebook/google api and stores user details
	 * */
	
	public class NetManager
	{
		private var xmlserver:XMLSocket;
		private var eng:Engine;
		public var isConnected:Boolean = false;
		public const SERVERIP:String = "darklord.thegup.com";
		public const SERVERPORT:Number = 9001;
		private var msgSplit:RegExp = /^(.+?),(.+?)$/ ;
		private var conRE:RegExp = /^Hello/ ;
		
		public var userInfo:Object;
		
		
		
		
		
		
		public function NetManager(engine:Engine):void
		{
			this.eng = engine;
			userInfo = new Object();
			userInfo.fb = false;
			userInfo.google = false;
		}
		
		public function loginFB():void
		{
			trace("Initializing facebook app " );
			Facebook.init(Config.FB_APP_ID, onFBInit);
			
		}
		public function onFBInit(result:Object, fail:Object):void
		{
			trace(onFBInit);
			if(result){
				trace('logging into facebook');
				var opts:Object = {scope:"publish_stream, user_photos"};
				Facebook.login(onFBLogin, opts);
			}
			else {
				trace("Unable to initialize facebook app");
			}
		}
		public function onFBLogin(result:Object, fail:Object):void
		{
			if(result){
				trace("FB Logged in!");
				trace(result);
				userInfo.fb = new Object();
			}
			else { trace("fb login FAILED"); trace(fail); }
		}
		
		public function loginGoogle():void
		{
			// set up the call
			trace("Setting up google call");
			//var oauth2:OAuth2 = new OAuth2("https://accounts.google.com/o/oauth2/auth", "https://accounts.google.com/o/oauth2/token", LogSetupLevel.ALL);
			/*var grant:IGrantType = new AuthorizationCodeGrant(stageWebView,                     // the StageWebView object for which to display the user consent screen
				"INSERT_CLIENT_ID_HERE",          // your client ID
				"INSERT_CLIENT_SECRET_HERE",      // your client secret
				"INSERT_REDIRECT_URI_HERE",       // your redirect URI
				"INSERT_SCOPE_HERE",              // (optional) your scope
				"INSERT_STATE_HERE");             // (optional) your state
			
			// make the call
			oauth2.addEventListener(GetAccessTokenEvent.TYPE, onGetAccessToken);
			oauth2.getAccessToken(grant);
			*/
		}
		
		//public function onGetAccessToken(getAccessTokenEvent:GetAccessTokenEvent):void
		//{
			
		//}
		
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
		
		public function send(msgType:String,data:Object):void
		{
			var datStr:String = data.toString();
			xmlserver.send(msgType+","+datStr);
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
			eng.onNetError(ev);
		}
		
		private function onDataReceived(ev:DataEvent):void
		{
			var matches:Array = msgSplit.exec(ev.data);
			//var msg:NetMSG
			if(matches && matches.length > 2){ eng.onNetMSG(new NetMSG(matches[1],matches[2],ev) ); }
			else { eng.onNetMSG( new NetMSG(0,null,ev) ); }
		}
		
		private function onSocketClose(ev:Event):void
		{
			this.isConnected = false;
			eng.onNetClose(ev);
		}
		
		
	}
}