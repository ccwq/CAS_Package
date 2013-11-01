package che
{
	import che.EasyEvent;
	import che.tool;
	import flash.events.IEventDispatcher;
	import flash.utils.flash_proxy;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author 
	 */
	public dynamic class EventCenter extends Proxy implements IEventDispatcher 
	{
		private var dispatcher:EventDispatcher;
		
		public function EventCenter() 
		{
			dispatcher = new EventDispatcher(this);
		}
		
		
		override flash_proxy function callProperty(name:*, ...rest):* 
		{
			var e:EasyEvent= new EasyEvent(name.toString(), rest.shift[0], rest[1]?true:false);
			this.dispatchEvent(e);
		}
		
		public function sendEvent(type:String, info:Object, flg:Boolean = true):void {
			this.dispatchEvent(new EasyEvent(type, info, flg));
		}
		
		 override flash_proxy function nextNameIndex (index:int):int {
			return 0;
		 }
		 
		 override flash_proxy function nextName(index:int):String {
			 return 'ss';//_item[index - 1];
		 }

		
		//IEventDispatcher 继承
   		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			dispatcher.addEventListener(type, listener, useCapture, priority);
		}
			   
		public function dispatchEvent(evt:Event):Boolean{
			return dispatcher.dispatchEvent(evt);
		}
		
		public function hasEventListener(type:String):Boolean{
			return dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			dispatcher.removeEventListener(type, listener, useCapture);
		}
					   
		public function willTrigger(type:String):Boolean {
			return dispatcher.willTrigger(type);
		}
	}

}