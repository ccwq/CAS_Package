package che {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.utils.Dictionary;
	public class Squery {
		private static var _stage:Stage;
		private static var _s:Squery;
		public static function get ins():Squery {
			if (!_s)	_s = new Squery;
			return _s;
		}
		
		///////////////查找模式///////////////
		public static const MODE_HAS_ATTR:String = '*';
		public static const MODE_EQUAL:String = '=';
		public static const MODE_NOT_EQUAL:String = '!=';
		public static const MODE_START_STRING:String = '^=';
		
		//如果有非英文字符 故障
		public static const MODE_END_STRING:String = '$=';
		
		public static const MODE_HAS_STRING:String = '*=';
		
		public static const MODE_SPLITBY_HAS:String = '_=';
		public static const MODE_SPLITEBY_FIRST:String = '_=0';
		public static const MODE_SPLITEBY_SECOND:String = '_=1';
		///////////////查找模式///////////
		
		
		private var _dic:Dictionary = new Dictionary;
		public function Squery():void {
			
		}
		
		public function init(s:Stage):void {
			_stage = s;
		}
		
		/**
		 * 通过条件获取dom中的元素列表
		 * 
		 * @param 要查找的属性和查询的值(例如{name:'pop'})
		 * @param 以此显示对象为根开始查找
		 * @param 查找方式，等于，不等于，包含等
		 * @param 查到一个立即返回，以增加效率（只需要找到一个，或者已知全局只有一个）
		 * @param 是否从缓存里取值
		 * @return Array查找到的对象列表数组
		 */
		public function get(attrObject:Object, root:DisplayObject = null, findMode:Object = '=', getOneMode:Boolean = false, flyMode:Boolean = false):Array {
			if (!root) root = _stage;
			if (!(root is DisplayObjectContainer))	return [];
			
			var key:Object = getKey(attrObject, root, findMode, getOneMode);
			if (_dic[key] && flyMode) return _dic[getKey].concat();
			
			var returnArray:Array = [];
			
			//可以进行复合查询
			if (!(attrObject is Array)) attrObject = [attrObject];
			if (!(findMode is Array))	findMode = [findMode];
						
			for each(var attr:Object in attrObject) {
				for each(var flmd:String in findMode) {
					returnArray = returnArray.concat(findInTree(attr, DisplayObjectContainer(root), flmd, [], getOneMode));
					if (getOneMode)	return returnArray;
				}
			}
			
			_dic[key] = returnArray.concat();
			return returnArray;
		}
		
		public function fly(attrObject:Object, root:DisplayObject = null, findMode:Object = '=', getOneMode:Boolean = false):Array {
			return get(attrObject, root, findMode, getOneMode, true);
		}
		
		public function getOne(attrObject:Object, root:DisplayObject = null, findMode:Object = '=',flyMode:Boolean = false):Array {
			return get(attrObject, root, findMode, true, flyMode);
		}
		
		private function findInTree(attrObj:Object, dio:DisplayObjectContainer, findMode:String = '=',returnArray:Array=null,getOneMode:Boolean=false):Array { 
			var currentDio:DisplayObject;
			for (var i:int = 0; i < dio.numChildren; i++ ) {
				currentDio = dio.getChildAt(i);
				
				if (currentDio&&judge2Object(attrObj, currentDio, findMode)) {
					returnArray.push(currentDio);
					if (getOneMode)	return returnArray;
				}
				
				//发现 容器，继续遍历
				if (currentDio is DisplayObjectContainer && (currentDio as DisplayObjectContainer).numChildren > 0) {
					findInTree(attrObj, DisplayObjectContainer(currentDio), findMode, returnArray);
				}
			}
			
			return returnArray;
		}//findInTree
		
		private function judge2Object(attrObj:Object, obj:DisplayObject, findMode = '=') { 
			var returnFlag:Boolean = true;
			
			//搜索all返回所有
			if (attrObj == 'all')	return true;
			for (var i:String in attrObj) {
				if (!(attrObj[i] is String)) {
					if (findMode == MODE_NOT_EQUAL)	returnFlag = (returnFlag && (attrObj[i] != obj[i]));
					else returnFlag = (returnFlag && (attrObj[i] == obj[i]));
				}else {
					//如果匹配的比匹配目标的长度还长  除了MODE_NOT_EQUAL 都为false
					if (attrObj[i].length > obj[i].length) {
						returnFlag = returnFlag && (findMode == MODE_NOT_EQUAL);
						break;
					}
					
					switch(findMode) {
						case MODE_EQUAL:
							returnFlag = (returnFlag && (attrObj[i] == obj[i]));
							break;
						case MODE_START_STRING:
							returnFlag = (returnFlag && (obj[i].indexOf(attrObj[i]) == 0));
							break;
						case MODE_HAS_STRING:
							returnFlag = (returnFlag && (obj[i].indexOf(attrObj[i]) != -1));
							break;
						case MODE_END_STRING:
							returnFlag = (returnFlag && (obj[i].indexOf(attrObj[i]) == obj[i].length - attrObj[i].length));
							break;
						case MODE_NOT_EQUAL:
							returnFlag = (returnFlag && (attrObj[i] != obj[i]));
							break;
						case MODE_HAS_ATTR:
							returnFlag = (returnFlag && obj[i].hasOwnProperty(attrObj[i]));
							break;
						case MODE_SPLITBY_HAS:
							returnFlag = (returnFlag && obj[i].split('_').indexOf(attrObj[i]) != -1);
							break;
						case MODE_SPLITEBY_FIRST:
							returnFlag = (returnFlag && obj[i].split('_').indexOf(attrObj[i]) == 0);
							break;
						case MODE_SPLITEBY_SECOND:
							returnFlag = (returnFlag && obj[i].split('_').indexOf(attrObj[i]) == 1);
							break;
					}//switcht
				}// if not string
			}//end for
			return returnFlag;
		}
		
		private function getKey(attrObject:Object, root:DisplayObject, findMode:Object,oneMode:Boolean):Object {
			return [attrObject, root, findMode,oneMode];
		}
	}
}