package che {
		import flash.events.Event;
		public class EasyEvent extends Event {
		public var info:Object = {};
        
		private var eventName:String;//事件名称 供克隆
		private var flowAble:Boolean;//可参与事件流 供克隆
		public function EasyEvent(evetName:String, inf:Object, flg:Boolean = true):void{
			info = inf;
			super(evetName, flg);
			/////////////////////////
			eventName = evetName;
			flowAble = flg;
		}
		
		override public function clone():Event {//克隆之后 记得转换类型
			return new EasyEvent(eventName, info, flowAble);
		}
		
		override public function toString():String{
			return eventName;
		}

		
	} //class
}
