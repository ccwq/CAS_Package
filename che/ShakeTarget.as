package che
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class ShakeTarget 
	{
		
		public static function addObject(dio:DisplayObject, config:Object = null):void {
			dic[dio] = new ShakeInfo(dio, config);
		}
		
		public static function deleteObject(dio:DisplayObject):void {
			dic[dio].destory();
			dic[dio] = null;
			delete dic[dio];
		}
		
		private static var dic:Dictionary = new Dictionary;
		
		//静态方法
		public function ShakeTarget(){}
		
		
	}

}
import che.tool;
import com.greensock.Tm;
import com.greensock.TweenMax;
import flash.display.DisplayObject;
import flash.events.Event;
import flash.utils.Timer;
import com.greensock.TweenLite;

class ShakeInfo {
	private var display:DisplayObject;
	private var config:Object;
	private var initPara:Object = { };
	private var tm:com.greensock.TweenLite;
	private var tmvars:Object = { };
	
	private var defaultConfig:Object = {
		times:[0.2, 0.45],				//计时器时间
		twTimes:[0.4,0.85],				//tween时间
		x:[ -15, 15],					//x范围
		y:[ -5, 5],					//y范围
		rotation:[-5,5]				//旋转范围
	};
	
	private var timer:Timer;
	public function ShakeInfo(dio:DisplayObject, _config:Object = null) {
		dio.addEventListener(Event.REMOVED_FROM_STAGE,lostStage);
		display = dio;
		config = _config || {};
		initPara.x = display.x;
		initPara.y = display.y;
		initPara.rotation = display.rotation;
		
		tmvars.dynamicProps ={}
		tmvars.dynamicProps.x = randomx;
		tmvars.dynamicProps.y = randomy;
		tmvars.dynamicProps.rotation = randomro;
		
		//tm = Tm.to(display, randomDelay/1000, tmvars);
		
		timer = new Timer(randomDelay);
		timer.addEventListener("timer", ontime);
		timer.start();
		ontime(null);
	}
	
	private function ontime(...res):void {
		timer.delay = randomDelay;
		//tm.restart();
		//trace(timer.delay, display,"后活动");
		//Tm.to(display, randomDelay, tmvars);
		Tm.to(display,twtime,{x:randomx(),y:randomy(),rotation:randomro()});
	}
	
	
	private function get randomDelay():Number {
		var times:Array = config.times || defaultConfig.times;
		return tool.random(times[0], times[1])*1000;
	}
	
	private function get twtime():Number {
		var times:Array = config.twTimes || defaultConfig.twTimes;
		return tool.random(times[0], times[1]);
	}
	
	//动态属性
	private function randomx():Number {
		var ar:Array = config.x || defaultConfig.x;
		return initPara.x + tool.random(ar[0], ar[1]);
	}
	
	private function randomy():Number {
		var ar:Array = config.y || defaultConfig.y;
		return initPara.y + tool.random(ar[0], ar[1]);
	}
	
	private function randomro():Number {
		var ar:Array = config.rotation || defaultConfig.rotation;
		return initPara.rotation + tool.random(ar[0], ar[1]);
	}
	
	//
	public function destory():void {
		timer.stop();
		timer.removeEventListener("timer",ontime);
	}
	
	private function lostStage(...res):void {
		display.removeEventListener(Event.REMOVED_FROM_STAGE, lostStage);
		che.ShakeTarget.deleteObject(display);
	}
	
}