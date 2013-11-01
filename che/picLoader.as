/*用法举例
   var ld:picLoader=new picLoader("2.jpg",onLd);
   function onLd(e){addChild(e.pic);}
 */

package che {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.ProgressEvent;
	import flash.system.LoaderContext;
	import flash.events.IOErrorEvent;

	public class picLoader extends Sprite {
		static public const LOADOVER:String = "picLoadOver";
		public var loaded:Function;
		private var _ioEr:Function; //url错误，文件不存在，访问不到
		private var ld:Loader;
		public var content:*; //加载的内容
		public var info:Object;
		public var state:Boolean = false;
		private var onProgress:Function;

		public function picLoader(url:String=null, exec:Function=null, checkDoname:Boolean = false, progresss:Function = null, ioErr:Function = null){
			if (url == null) {
				
			}else {
				load(url, exec, checkDoname, progresss, ioErr);
			}
		}

		public function load(url:String, exec:Function, checkDoname:Boolean = false, progresss:Function = null, ioErr:Function = null){
			loaded = exec;
			ld = new Loader;
			ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onLd);
			ld.contentLoaderInfo.addEventListener("open", function(e){
					state = true;
				}); //打开流状态设置为1

			if (progresss != null)
				progress = progresss;
			if (ioErr != null)
				ioError = ioErr;

			//addEventListener(picEvt.PO, loaded); //加载完成，先调用onLd函数，onLd函数，发出事件传给loaded函数（外部）
			ld.load(new URLRequest(url), checkDoname ? new LoaderContext(true) : null);
		}

		private function onLd(e:Event) {
			state = false; //状态0，说明没有打开的流
			content = ld.content;
			var pic:Sprite = new Sprite;
			pic.addChild(ld);
			var evt:picEvt = new picEvt(picEvt.PO);
			evt.pic = pic;
			evt.content = content;
			evt.info = info;
			dispatchEvent(evt.clone());
			if (loaded != null){
				//dispatchEvent(evt);
                                loaded(evt);
			} else {
				trace("请给picLoader的loaded方法赋值");
			}
		}

		public function set ioError(fun:Function){
			ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, fun);
		}

		public function set progress(fun:Function){
			onProgress = fun;
			ld.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
		}

		public function unLoad(){
			ld.unload();
		}

		public function close(){
			if (state){
				ld.close();
				ld.unload();
				if (onProgress != null){
					ld.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				}
				ld.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLd);
			}
			state = false;
		}

		public function destroy():void {
			//ld.removeEventListener();
			close();
			ld = null;
		}
	} //class
}

import flash.events.Event;
import flash.display.Sprite;

class picEvt extends Event {
	public static const PICLOADOVER:String = "picLoadOver";
	public static const PO:String = "picLoadOver";
	public var pic:Sprite;
	public var content:*; //加载到的内容
	public var info:Object;

	public function picEvt(evtName:String){
		super(evtName, true);
	}
	public override function clone():Event {
		var cl:picEvt = new picEvt(PO);
		    cl.pic = pic;
			cl.info = info;
		return cl;
	}

}