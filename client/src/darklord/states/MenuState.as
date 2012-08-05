package darklord.states
{
	import away3d.containers.View3D;
	
	import darklord.Alert;
	import darklord.Engine;
	import darklord.GameState;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.*;
	import flash.utils.*;
	
	public class MenuState extends GameState
	{
		[Embed(source="../assets/crap/title.png")]
		private var TitleGFX:Class;
		
		private var userTXT:TextField = new TextField();
		private var passTXT:TextField = new TextField();
		private var googleBTN:TextField = new TextField();
		private var facebookBTN:TextField = new TextField();
		
		public var status:String = "menu";
		private var alert:Alert;
		
		public function MenuState(engine:Engine)
		{
			super(engine);
			this.name = "MenuState";
		}
		
		override public function init(view:View3D):void
		{
			super.init(view);
			trace("Menu state initialized");
			
			var bgRect:Sprite = new Sprite();
			bgRect.name="bgRect";
			bgRect.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0x660000], [1,1],[0,155]);
			bgRect.graphics.drawRect(0,0, this.eng.gameWidth, this.eng.gameHeight);
			this.addChild(bgRect);
			
			var titleBMP:Bitmap = new TitleGFX(); titleBMP.alpha = 0.5;
			//bgRect.graphics.beginBitmapFill(titleBMP.bitmapData);
			//bgRect.graphics.drawRect(0,0, this.eng.gameWidth, this.eng.gameHeight);
			
			var titleText:TextField = new TextField();
			var titleFormat:TextFormat = new TextFormat("null",50,0xffffff,true);
			titleText.defaultTextFormat = titleFormat;
			titleText.text = "Dark Lord";
			titleText.width = 300;
			//titleText.textColor = 0xffffff;
			titleText.x = this.eng.gameWidth/2 - 100;
			titleText.y = this.eng.gameHeight/2 - 100;
			titleText.filters = [ new DropShadowFilter() ];
			this.addChild(titleText);
			
			
			var inputFormat:TextFormat = new TextFormat(null,20,0x000000,false,true,null);
			var btnFormat:TextFormat = new TextFormat(null,20,0xffffff,true,null,null,null,null,TextFormatAlign.CENTER);
			
			userTXT.defaultTextFormat = inputFormat;
			userTXT.text = "Enter Username";
			userTXT.width = 150;
			userTXT.height = 30;
			userTXT.background=true; userTXT.backgroundColor=0xffffff;
			userTXT.border=true; userTXT.borderColor=0xaaaaaa;
			userTXT.type = TextFieldType.INPUT;
			userTXT.x = eng.gameWidth/2 - userTXT.width/2; userTXT.y = titleText.y + 100;
			
			
			passTXT.defaultTextFormat = inputFormat;
			passTXT.text = "Enter Password";
			passTXT.width = 150;
			passTXT.height = 30;
			passTXT.background=true; passTXT.backgroundColor=0xffffff;
			passTXT.border=true; passTXT.borderColor=0xaaaaaa;
			passTXT.type = TextFieldType.INPUT;
			passTXT.x = eng.gameWidth/2 - passTXT.width/2; passTXT.y = userTXT.y + 50;
			
			userTXT.addEventListener(MouseEvent.CLICK,onInputClick);
			passTXT.addEventListener(MouseEvent.CLICK,onInputClick);
			
			var submitBTN:TextField = new TextField();
			submitBTN.defaultTextFormat = btnFormat;
			submitBTN.background=true; submitBTN.backgroundColor=0x331111;
			submitBTN.border=true; submitBTN.borderColor=0xcccccc;
			submitBTN.text = "Login/Register";
			submitBTN.x = eng.gameWidth/2 - submitBTN.width/2; submitBTN.y = passTXT.y + 100;
			
			submitBTN.addEventListener(MouseEvent.CLICK,onSubmitClick);
			
			googleBTN.defaultTextFormat = btnFormat;
			facebookBTN.defaultTextFormat = btnFormat;
			
			googleBTN.background=true; googleBTN.backgroundColor=0x331111;
			googleBTN.border=true; googleBTN.borderColor=0xcccccc;
			googleBTN.text = "Login via Google";
			googleBTN.width = 180; googleBTN.height = 25;
			googleBTN.x = eng.gameWidth/2 - googleBTN.width - 20; googleBTN.y = titleText.y + 150;
			googleBTN.mouseEnabled = true;
			
			facebookBTN.background=true; facebookBTN.backgroundColor=0x331111;
			facebookBTN.border=true; facebookBTN.borderColor=0xcccccc;
			facebookBTN.text = "Login via Facebook";
			facebookBTN.width = 180; facebookBTN.height = 25;
			facebookBTN.x = eng.gameWidth/2 +20; facebookBTN.y = titleText.y + 150;
			facebookBTN.mouseEnabled = true;
			
			facebookBTN.addEventListener(MouseEvent.CLICK,onFacebookClick);
			googleBTN.addEventListener(MouseEvent.CLICK,onGoogleClick);
			
			this.addChild(userTXT); this.addChild(passTXT); this.addChild(submitBTN);
			//this.addChild(googleBTN); this.addChild(facebookBTN);
			
			
			this.alert = new Alert();
			this.addChild(alert);
		}
		
		public function onSubmitClick(ev:MouseEvent):void
		{
			if(status != "menu") return;
			if(!eng.net.isConnected){ alert.show("Not connected to the server!"); return; }
			if(userTXT.text=="Enter Username" || passTXT.text == "Enter Password"){
				alert.show("Please enter an existing username/password or create a new one");
				return;
			}
			if(userTXT.text.indexOf('~') > -1 || passTXT.text.indexOf("~") > -1){
				alert.show("Invalid character in password or username. Alphanumeric only");
				return;
			}
			this.status = "logging in";
			eng.net.sendData("1,"+userTXT.text+"~"+passTXT.text);
		}
		
		public function onGoogleClick(ev:MouseEvent):void
		{
			trace("google btn clicked");
			eng.net.loginGoogle();
			if(eng.net.isConnected){
				eng.net.sendData("1,Google button clicked");
			}
		}
		public function onFacebookClick(ev:MouseEvent):void
		{
			eng.net.loginFB();
		}
		
		public function onInputClick(ev:MouseEvent):void
		{
			trace("input click");
			var targ:TextField = ev.target as TextField;
			if(targ.text == "Enter Username" || targ.text == "Enter Password") targ.text = "";
		}
		
		override public function onMouseClick(ev:Event):void
		{
			//trace("click!");
			//trace( getQualifiedClassName(ev.target)  );
			if( "flash.display::Sprite" == getQualifiedClassName(ev.target) ){
				
				//trace((ev.target as Sprite).name);
			}
			
		}
		
		override public function update():void
		{
			
			super.update();
		}
		
		override public function render():void
		{
			
			super.render();
		}
		
		override public function onNetMSG(ev:DataEvent):void
		{
			alert.show(ev.data);	
			//trace("Menu received net msg"); trace(ev);
		}
		override public function onNetClose(ev):void
		{
			alert.show("Connection to server dropped!");
		}
		override public function onNetError(ev):void
		{
			alert.show("Network Error!");
		}
	}
}