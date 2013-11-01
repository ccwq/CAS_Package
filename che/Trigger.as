package che
{
	import che.EasyEvent;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	public class Trigger extends EventDispatcher 
	{
		public static const EV_UP_TRIGGER:String = 'EV_UP_TRIGGER';
		public static const EV_DOWN_TRIGGER:String = 'EV_DOWN_TRIGGER';
		public static const EV_TRIGGER:String = 'EV_TRIGGER';
		
		//lastStatus 1表示上升完毕    -1表示下降完毕
		public static const EV_TRIGGER_COMPLETE:String = 'EV_TRIGGER_COMPLETE';
		
		private var _timer:Timer;
		private var _min:int = 0;
		private var _max:int = 0;
		private var _current:int = 0;
		public function get current():int {
			return _current;
		}
		
		//停止0 下降-1 上升1
		private var _status:int = 0;
		public function get status():int {
			return _status;
		}
		
		private var _timeSpace:Number = 500;
		
		public function Trigger(timeSpace:Number=500,min:int=0,max:int=10) 
		{
			_timer = new Timer(timeSpace);
			_timeSpace = timeSpace;
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			setScale(min, max);
		}
		
		public function setTimeSpace(timeSpace:Number, tempFlag:Boolean = false):void {
			if (!tempFlag) 
				_timeSpace = timeSpace;
			
			_timer.delay = timeSpace;
			
		}
		
		public function setScale(minVa:int,maxVa:int):void {
			_min = minVa;
			_max = maxVa;
		}
		
		////参数 临时改变时间间隔
		public function down(delay:int=-1):void {
			if (_status == -1)
				return;
			
			_current = _max + 1;
				
			_timer.stop();
			if (delay != -1)
				setTimeSpace(delay, true);
			else
				setTimeSpace(_timeSpace);
				
			_status = -1;
			_timer.start();
		}
		
		//参数 临时改变时间间隔
		public function up(delay:int=-1):void {
			if (_status == 1)
				return;
				
			_current = _min - 1;
			
			_timer.stop();
			if (delay != -1)
				setTimeSpace(delay, true);
			else
				setTimeSpace(_timeSpace);
				
			_status = 1;
			_timer.start();
		}
		
		
		private function onTimer(e:TimerEvent):void {
			if (_status == -1) {//递减
				_current--;
				if (_current < _min) { 
					_timer.stop(); 
					dispatchEvent(new EasyEvent(
						EV_TRIGGER_COMPLETE,
						{ current:current, status:0, lastStatus:_status }
					));
					_status = 0;
					setTimeSpace(_timeSpace);
					return; 
				}
				
				dispatchEvent(new EasyEvent(
					EV_DOWN_TRIGGER, 
					{current:current,status:status }
				));
				
				dispatchEvent(new EasyEvent(
					EV_TRIGGER,
					{current:current,status:status }
				));
			}else if (_status == 1) {//递增
				_current++;
				if (_current > _max) { 
					_timer.stop(); 
					dispatchEvent(new EasyEvent(
						EV_TRIGGER_COMPLETE,
						{ current:current, status:0, lastStatus:_status }
					));
					_status = 0;
					setTimeSpace(_timeSpace);
					return; 
				}
				
				dispatchEvent(new EasyEvent(
					EV_UP_TRIGGER,
					{current:current,status:status}
				));
				dispatchEvent(new EasyEvent(
					EV_TRIGGER,
					{current:current,status:status }
				));
			}
		}
	}//class
}