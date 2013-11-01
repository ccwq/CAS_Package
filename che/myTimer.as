
/*
用法举例
var tm:myTimer=new myTimer(1500,onTimer);
function onTimer(e){trace(111);}
*/


package che{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	public class myTimer extends Timer{
		public var onTimer:Function;
		public function myTimer(dlay:int,exec:Function,times:uint=int.MAX_VALUE){
			onTimer=exec;
			addEventListener(TimerEvent.TIMER,onTimer);
			super(dlay,times);
			start();
			}
		}
	}