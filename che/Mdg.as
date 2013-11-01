//我严重最轻的flash平台debug工具
//二次封装了一下
package che{
	import nl.demonsters.debugger.MonsterDebugger;
	import flash.display.DisplayObject;
	public class Mdg extends MonsterDebugger{
		static public function app(target:Object = null):Mdg {
			return new MonsterDebugger(target) as Mdg;
		}
		static public function tr(object:*,target:Object="无名输出",depth:int = 4 , color:uint = 0x111111, functions:Boolean = false):void { 
			MonsterDebugger.trace(target, object, color, functions, depth);
		}
		static public function ph(target:DisplayObject, color:uint = 0x111111):void {
			MonsterDebugger.snapshot(target,color);
		}
	}
}