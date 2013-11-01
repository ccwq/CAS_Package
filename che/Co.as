//全称 CObject
package che{
	import flash.events.EventDispatcher;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	public dynamic class Co extends EventDispatcher {
		//静态
		public static function one(...rest):Co {
			var co:Co = new Co;
			return co.setme.apply(co,rest);
		}
		//--静态
		private var _list:Array = [];
		/*
		 *长度
		 * */
		public function get length():int { return _list.length }
		public var data:Object = { };	//数据缓存
		
		//增删
		public function push(dio:DisplayObject):Co {
			_list.push(dio);
			return this;
		}
		
		public function pushAt(dio:DisplayObject,index:int):Co {
			_list.splice(index, 0, dio);
			return this;
		}
		
		public function remove(dio:DisplayObject):Co {
			_list.splice(_list.indexOf(dio), 1);
			return this;
		}
		
		public function removeAt(index:int):Co {
			_list.splice(index, 1);
			return this;
		}
		
		public function addChild(dio:DisplayObject):Co {push(dio);return this;}
		public function addChildAt(dio:DisplayObject, index:int):Co { pushAt(dio, index); return this; }
		public function removeChild(dio:DisplayObject):Co { remove(dio); return this; }
		public function removeChildAt(index:int):Co { removeAt(index); return this; }
		//--增删
		
		
		public function Co(...arg) {
			if(arg.length>0) setme.apply(this,arg);
		}
		
		public function setme(...arg):Co {
			if (arg.length > 0) {
				var firstPara:*= arg[0];
				if (firstPara is DisplayObject) {
					arg.forEach(function(dio:DisplayObject, i:int, ti):void {
						if (dio is DisplayObject)
							_list.push(dio);
					});
				}
				if (firstPara is Array) {
					firstPara.forEach(function(dio:DisplayObject, i:int, ti):void {
						if (dio is DisplayObject)
							_list.push(dio);
					});
				}
			}
			return this;
		}
		
		
		
		public function appendTo(co_displayobjectContainer:Object):Co {
			var dic:DisplayObjectContainer;
			if (co_displayobjectContainer is Co)  dic = co_displayobjectContainer.getFirst() as DisplayObjectContainer;
			else dic = co_displayobjectContainer as DisplayObjectContainer;
			 
			if (!dic) {throw(new Error("请传入有效对象:Co或者DisplayObjectContainer，不能添加子对象"));}
				
			
			
			doAction(function (dio:DisplayObject,index:int) {
				dic.addChild(dio);
			});
			return this;
		}
		
		public function append(...paras):Co {
			if (paras.length < 1)	return this;
			var co:Co;
			if (paras[0] is Co) {
				co = paras[0];
			}else {
				trace(paras[0] as DisplayObject)
				co = Co.one(paras);
			}
			
			var dic:DisplayObjectContainer = getFirst() as DisplayObjectContainer;
			if (!dic) { throw(new Error("非DisplayObjectContainer，不能添加子对象")); }

			co.doAction(function(dio:DisplayObject, index:int):void {
				dic.addChild(dio);
			});
			return this;
		}
		
		/*
		 * 对每一项执行操作
		 * */
		public function doAction(actionFunc:Function):Co {
			for (var i:int = 0; i < length; i++ ) {
				var dio:DisplayObject = _list[i];
				actionFunc(dio, i);
			}
			return this;
		}
		
		/*
		 * 对每一项执行操作
		 * */
		public function each(actionFunc:Function):Co {
			return doAction(actionFunc);
		}
		
		
		/*
		 * 返回Arry的拷贝
		 * */
		public function toArray():Array {
			return _list.concat();
		}
		
		//截取
		public function get(index:int):DisplayObject {
			if (index < 0) {
				throw(new Error("索引过小："+ index.toString()));
			}
			
			if (index > length -1 ) {
				throw(new Error("索引过大："+ index.toString()));
			}
			return _list[index];
		}
		
		public function getFirst():DisplayObject { return get(0) };
		public function fir():DisplayObject { return get(0) };
		
		
		public function eq(index:int):Co {
			return new Co(get(index));
		}
		
		public function first():Co {
			if (length == 0) {
				throw(new Error("总体长度为空！"));
				return null;
			}
			
			return new Co(_list[0]);
		}
		
		public function last():Co {
			if (length == 0) {
				throw(new Error("总体长度为空！"));
				return null;
			}
			return new Co(_list[length-1]);
		}
		
		/*
		 * 根据过滤函数，返回新的Co 
		 * 总共4种用法
		 * 1,传入Function, 必须有布尔值的返回值，返回值真不过滤，否则过滤掉
		 * 2,传入Class,传入某中类型 如 DisplayObject，Array，Object
		 * 3,传入属性名，存在此属性名的不过滤
		 * 4,传入类型以及属性值对的Object,其中classs为类型如{classs:Sprite,name:"cc"}
		 * */
		public function filter(filterFunc_filterClass_filterAttrName_filterAttrObject:Object):Co { 
			var co:Co, res:Object = filterFunc_filterClass_filterAttrName_filterAttrObject;
			if (res is Function) {
				co = funcFilter(res as Function);
			}else if(res is Class) {
				co = typeAndAttrFilter(res as Class);
			}else if(res is String){
				co = typeAndAttrFilter(Object,res);
			}else if (res is Object) {
				var classs:Class = res.classs as Class;
				if (!classs)	classs = Object;
				res.classs = null;
				delete res["classs"];
				co = typeAndAttrFilter(classs,res);
			}
			return co;
		}
		
		private function funcFilter(filterFunc:Function):Co {
			var returnCo:Co = new Co;
			for (var i:int = 0; i < length; i++ ) {
				var dio:DisplayObject = _list[i];
				if (filterFunc(dio,i)) {
					returnCo.push(dio);
				}
			}
			return returnCo;
		}
		
		private function typeAndAttrFilter(classs:Class,attrName_attrObject:Object=null):Co {
			return funcFilter(function (di:DisplayObject,i:int):Boolean 
			{
				var bool:Boolean = false;
				if (di is classs) {
					bool = true;	//默认true
					if (attrName_attrObject == null) {
						bool = true;
					}else if (attrName_attrObject is String) {
						bool = di.hasOwnProperty(attrName_attrObject);
					}else if (attrName_attrObject is Object) {
						for ( var k:String in attrName_attrObject) {
							if (di[k] != attrName_attrObject[k]) {
								bool = false;
								break;
							}
						}
					}
				}else {
					bool = false;
				}
				
				return bool;
			});
		}
		
		//--过滤
		
		//--//截取
		
	
		//排序
		public function sort(sortFunc:Function):Co {
			_list.sort(sortFunc);
			return this;
		}
		
		
		public function sortOn(field:Object,options:Object=null):Co {
			_list.sortOn(field, options);
			return this;
		}
		//-排序
		
		//克隆
		public function clone():Co {
			return Co.one(_list.concat());
		}
		//-克隆
		
		//串联
		public function concat(co:Co):Co {
			return Co.one(_list.concat(co.toArray()));
		}
		//--串联
		
		//操作属性
		private static const ATTR_VALUE_NULL:String = "ATTR_VALUE_NULL";
		public function attr(protetype_valueObject:Object, value:Object = ATTR_VALUE_NULL):Object {
			var attrObject:Object;
			if (protetype_valueObject is String) {
				if (value == ATTR_VALUE_NULL) {
				//获取
					return Object(getFirst())[protetype_valueObject];
				}else {
					attrObject = { };
					attrObject[protetype_valueObject] = value;
					setEleAttr(attrObject);
				}
			}else if (protetype_valueObject is Object) {
				setEleAttr(protetype_valueObject);
			}
			return  this;
			
			function setEleAttr(valueObject:Object):void {
				for (var k:String  in valueObject) {
					each(function (dio:*,index:int):void 
					{
						var o:Object = dio as Object;
						o[k] = valueObject[k];
					});
				}
			}
		}
		//--操作属性
		
		override public function toString():String 
		{
			return "che.Co:" + length.toString() + "|" + _list.toString();
		}
		///扩充方法
		
		//Rectangle应用到co
		public function rectangleApply(rec:Rectangle):Co {
			return doAction(function(dio:DisplayObject, index:int):void {
				dio.x = rec.x;
				dio.y = rec.y;
				dio.width = rec.width;
				dio.height = rec.height;
			});
		}
		
		private var _eventHandleDic:Object = { }
		
		//手动增加事件记录，供删除时候 自动删除 //仅供一个对象时使用 //Cprite使用目前
		public function addRecord(evObject:Object):Co {
			for (var k:String in evObject) {
				var list:Array = _eventHandleDic[k] || (_eventHandleDic[k] = []);
				list.push(evObject[k]);
			}
			return this;
		}
		
		public function removeRecord(evObject:Object):Co {
			for (var k:String in evObject) {
				var list:Array = _eventHandleDic[k] as Array;
				if (list && list.length > 0) {
					_eventHandleDic[k] = list.filter(function(item,index,ar):Boolean {
						return item != evObject[k];
					});
				}
			}
			return this;
		}
		
		
		public function addListener(event_handle_object:Object):Co {
			each(function(dio:DisplayObject, index:int):void {
				for (var k:String in event_handle_object) {
					dio.addEventListener(k, event_handle_object[k]);
					var funcList:Array = (_eventHandleDic[k] || (_eventHandleDic[k] = []));
					funcList.push(event_handle_object[k]);
				}
			});
			return this;
		}
		
		
		//删除事件（如果事件不存在或者没关联，不会执行操作）（onlyDeleteRecoderIn_eventHandleDic如果false，evName_func_evNameFuncObject必须为Object方可生效）
		public function removeListener(evName_func_evNameFuncObject:*,onlyDeleteRecoderIn_eventHandleDic:Boolean=true):Co {
			//根据事件名称删除
			if (evName_func_evNameFuncObject is String) {
				var eventHandlList:Array = _eventHandleDic[evName_func_evNameFuncObject] as Array;
				if (eventHandlList && eventHandlList.length > 0) {
					each(function(dio:DisplayObject, index):void {
						eventHandlList.forEach(function(item, index, ar):void {
							dio.removeEventListener(evName_func_evNameFuncObject,item);
						});
					});
				}
				_eventHandleDic[evName_func_evNameFuncObject] = null;
				delete _eventHandleDic[evName_func_evNameFuncObject];
			}else if (evName_func_evNameFuncObject is Function) {
			//根据函数handle删除
				for (var ke:String in _eventHandleDic) {
					var evList:Array = _eventHandleDic[ke] as Array;
					if (evList && evList.length > 0) {
						evList.forEach(function(item,index,ar) {
							if (item == evName_func_evNameFuncObject) {
								each(function(dio:DisplayObject, index:int):void {
									dio.removeEventListener(ke,item);
								});
							}
						});
						//清除
						_eventHandleDic[ke] = evList.filter(function(item, index, ar):Boolean {
							return item != evName_func_evNameFuncObject;
						});
						
						if (_eventHandleDic[ke].length == 0) {
							_eventHandleDic[ke] = null;
							delete _eventHandleDic[ke];
						}
					}
				}
				
			}else {
			//根据事件名称和handle 对象删除如：{click:clickHandle,mousemove:mouseHandle}
				for (var kk:String in evName_func_evNameFuncObject) {
					var elist:Array = _eventHandleDic[kk] as Array;
					if (elist && elist.length > 0) {
						elist.forEach(function(item, index, ar):void {
							if (item == evName_func_evNameFuncObject[kk]) {
								each(function(dio:DisplayObject, index:int):void {
									dio.removeEventListener(kk,item);
								});
							}
						});
						
						//清除
						_eventHandleDic[ke] = evList.filter(function(item, index, ar):Boolean {
							return item != evName_func_evNameFuncObject[kk];
						});
						
						if (_eventHandleDic[ke].length == 0) {
							_eventHandleDic[ke] = null;
							delete _eventHandleDic[ke];
						}
					}
				}
				
				//删除非记录内的事件
				if (!onlyDeleteRecoderIn_eventHandleDic) {
					for (var kkk:String in evName_func_evNameFuncObject) {
						each(function(dio:DisplayObject,index:int) {
							dio.removeEventListener(kkk,evName_func_evNameFuncObject[kkk]);
						});
					}
				}
			}
			
			return this;
		}//func
	}
}