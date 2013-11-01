package che{
	import flash.display.DisplayObject;
	
	import com.greensock.TweenLite
	import com.greensock.TweenMax;
	public class t {
		public static function rdmFl(a:Number,b:Number):int {
			return tool.rdmFl(a,b);
		}
		public static function rdm(a:Number,b:Number):Number {
			return tool.rdmNu(a,b);
		}
		public static function rdmNu(a:Number,b:Number):Number {
			return tool.rdmNu(a,b);
		}

		public static function tlto($target:Object,$duration:Number,$vars:Object) :TweenLite{
			return TweenLite.to($target,$duration,$vars);
		}
		public static function tlfm($target:Object,$duration:Number,$vars:Object) :TweenLite{
			return TweenLite.from($target,$duration,$vars);
		}
		public static function tmto($target:Object,$duration:Number,$vars:Object) :TweenMax{
			return TweenMax.to($target,$duration,$vars);
		}
		public static function tmfm($target:Object,$duration:Number,$vars:Object) :TweenMax{
			return TweenMax.from($target,$duration,$vars);
		}
		public static function get r():Number {//获得随机数0-1
			return Math.random();
		
		}//使数组乱序，随机
		public static function dsArr(a:Array):Array {
			return tool.dasanArray(a);
		}
		//输出函数
		public static function set w(a:*):void{
			trace(a);
		}
		public static function sortByZ(aa:Array,d:DisplayObject):Array {//在flash自带的3d中，按照z进行深度排序，返回数组//aa,对象数组，d基点对象，相对于D进行排序
			return tool.sortByZ(aa,d);
		}
		public static function putOnContainer(cont:Array,pic:Array,space:Number=0):Array{
			 return tool.putOnContainer(cont,pic,space);
		}
		public static function evtSend(dobj:DisplayObject,str:String,inf:Object):void{
			tool.evtSend(dobj,str,inf);
		}
		public static function killTween(obj:Object, flg:Boolean = false ):void{
		    TweenLite.killTweensOf(obj, flg);	
		}
		public static function delayCall(time:Number,fun:Function,arr:Array=null):void{
		    TweenLite.delayedCall(time, fun, arr);
		}
		public static function KillDelayCall(fun:Function,runFunctionFlg:Boolean=false):void{
		   // TweenLite.killDelayedCallsTo = fun;	
			TweenLite.killTweensOf(fun, runFunctionFlg);
		}

	}//class
}