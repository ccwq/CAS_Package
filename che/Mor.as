//轻量级flash平台debug工具
//二次封装了一下
package che{
	import com.demonsters.debugger.MonsterDebugger
	import com.greensock.events.LoaderEvent;
	import flash.display.DisplayObject;
	public class Mor extends MonsterDebugger {
		
		static public function set enabled(bl:Boolean):void {
			MonsterDebugger.enabled = bl;
		}
		
		static public function get enabled():Boolean {
			return MonsterDebugger.enabled;
		}
		
		static public function set logger(func:Function):void {
			MonsterDebugger.logger = func;
		}
		
		static public function get logger():Function {
			return MonsterDebugger.logger;
		}
		
		static public function init(base:Object,address:String='127.0.0.1'):void {
			MonsterDebugger.initialize(base,address);
		}
		
		//原版中 为breakpoint  p不用大写
		static public function breakPoint(caller:*,id:String='breakPoint'):void {
			MonsterDebugger.breakpoint(caller,id);
		}
		
		static public function breakpoint(caller:*,id:String='breakPoint'):void {
			MonsterDebugger.breakpoint(caller,id);
		}
		
		static public function clear():void {
			MonsterDebugger.clear();
		}
		
		static public function inspect(object:*):void {
			MonsterDebugger.inspect(object);
		}
		
		//暂时无用
		static public function log(...args):void {
			MonsterDebugger.log.apply(null,args);
		}
		
		static public function snapshot(caller:*,object:DisplayObject,person:String,label:String):void {
			MonsterDebugger.snapshot(caller,object,person,label);
		}
		
		static public function trace(caller:*, object:*, person:String='', label:String='', color:uint = 0x000000, depth:int = 3):void {
			MonsterDebugger.trace(caller,object,person,label,color,depth);
		}
		
		//反置 caller和object
		static public function tr(object:*, caller:*=null,  person:String = '', label:String = '', color:uint = 0x000000, depth:int = 3):void { 
			MonsterDebugger.trace(caller,object,person,label,color,depth);
		}
		
		//深度提前
		static public function tc(object:*, depth:int = 3,caller:*=null,  person:String = '', label:String = '', color:uint = 0x000000):void { 
			MonsterDebugger.trace(caller,object,person,label,color,depth);
		}
		
	}
}