package che {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class Debug {
		static private var tf:TextField = new TextField;
		static private var counter:uint = 0;
		static private var initedFlg:Boolean = false;

		static public function init(d:DisplayObject,bgFlg:Boolean=false):void {
			if (!initedFlg){
				initedFlg = true;
				tool.onStage(d, function(e:Event){
						d.stage.addChild(tf);
						tf.width = 500;
						tf.height = d.stage.stageHeight * 0.2;
						tf.text = "debug";
						//tf.autoSize = TextFieldAutoSize.RIGHT;
						tf.background = bgFlg;
						tf.multiline = true;
						tf.wordWrap = true;
						tf.mouseEnabled = false;
					//tf.alpha = 0.5;

					});
			}

		}

		static public function set w(s:*):void {
			if (typeof(s) != "String")
				s = s.toString();
			with (tf){
				appendText((counter++).toString() + "::" + s + "\n");
				//trace(tf.numLines);
				tf.scrollV = tf.numLines;
			} //with
		}

		static public function hide(flg:Boolean = true){
			if (flg){
				tf.visible = false;
			} else {
				tf.visible = true;
			}
		}
	} //class
}