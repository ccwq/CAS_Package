package che{
	import flash.events.Event;
	public class evtSend extends DisplayObject {
		public var info:Object={};
		public function evtSend(str:String="noName",inf:Object={}) {
			info=inf;
			dispatchEvent(new evt(str,info));
		}
	}//class
}
import flash.events.Event;
class evt extends Event {
	public var info:Object={};
	public function evt(str:String,inf:Object={}) {
		super(str,super);
		info=inf;
	}
}