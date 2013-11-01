package che{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	//全局对象
	public class Global extends EventDispatcher {
		public function Global() {
			
		}
		public var data:Object = { };
		///静态
		private static var _ins:Global;
		public static function get ins():Global {
			return _ins || (_ins = new Global);
		}
	}//class
}
