//用法 new xmlLoader(xml的路径String，加载完毕执行的函数:Function); 函数必须有一个xmlEvt或者*类型的参数，此参数的xml属性返回xml对象


package che{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	//import che.xmlEvt;
	public class xmlLoader extends Sprite {
		public var xml:XML;
		public var ld:URLLoader;
		public var loaded:Function;
		public function xmlLoader(xmlUrl:String,loadExec:Function,errorFunc:Function = null) {
			ld=new URLLoader  ;
			ld.addEventListener(Event.COMPLETE, onXmlLoad);
			loaded=loadExec;
			addEventListener(xmlEvt.XO,loaded);
            if (errorFunc!=null)	onError = errorFunc;
			ld.load(new URLRequest(xmlUrl));
			//addEventListener(xmlEvt.XO,loaded);
		}
		public function set onError(onErr:Function) {
			ld.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent) {//如果出错
				onErr(e);
			});
		}
		private function onXmlLoad(e:Event) {
			xml=new XML(e.target.data);
			var evt:xmlEvt=new xmlEvt(xmlEvt.XO);
			evt.xml=xml;
			if (loaded!=null) {
				dispatchEvent(evt);
			} else {
				trace("请给xmlLoader的loaded方法赋值");
			}//if
		}//function
		private function nullFunction() {
			
		}
		
		

	}//class
}

import flash.events.Event;
class xmlEvt extends Event {
	public static const XMLLOADOVER:String="xmlLoadOver";
	public static const XO:String="xmlLoadOver";
	public var xml:XML;
	public function xmlEvt(evtName:String) {
		super(evtName,true);
	}

}