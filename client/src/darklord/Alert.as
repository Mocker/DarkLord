package darklord
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	
	public class Alert extends Sprite
	{
		public var borderColor:uint = 0x000000;
		public var backgroundColor:uint = 0xcccccc;
		public var textColor:uint = 0x000000;
		public var msgFormat:TextFormat;
		public var btnFormat:TextFormat;
		
		public var msg:TextField;
		public var btn:TextField;
		
		public function Alert()
		{
			super();
			
			msgFormat = new TextFormat(null,14,textColor,true,null,null,null,null,TextFormatAlign.CENTER);
			btnFormat = new TextFormat(null,16,textColor,true,null,null,null,null,TextFormatAlign.CENTER);
			
			msg = new TextField(); msg.defaultTextFormat = msgFormat;
			msg.wordWrap = true;
			msg.width = 300; msg.height = 120;
			msg.border = true; msg.borderColor = 0x000000;
			msg.background=true; msg.background = this.backgroundColor;
			
			btn = new TextField(); btn.defaultTextFormat = btnFormat;
			btn.backgroundColor = 0xeeeeee; btn.background = true;
			btn.borderColor = 0x999999; btn.border = true;
			btn.text = "Ok";
			btn.width = 34; btn.height = 22;
			
			btn.addEventListener(MouseEvent.CLICK, hide);
			
			this.addChild(msg); this.addChild(btn);
			
			this.visible = false;
		}
		
		public function show(txt:String):void
		{
			if(!txt) return;
			msg.text = txt;
			this.width = msg.width + 40;
			this.height = msg.height + 60;
			msg.y = 10; msg.x = this.width/2 - msg.width/2 ;
			btn.y = msg.height + 30; btn.x = this.width/2 - btn.width /2 ;
			
			//this.graphics.beginFill(this.borderColor);
			//this.graphics.drawRect(0,0,this.width, this.height);
			//this.graphics.beginFill(this.backgroundColor);
			//this.graphics.drawRect(10,10,this.width-10,this.height-10);
			
			this.x = this.parent.width/2 - this.width/2; this.y = this.parent.height/2 - this.height/2;
			
			this.visible = true;
		}
		
		public function hide(ev:MouseEvent):void
		{	
			this.visible = false;
		}
	}
}