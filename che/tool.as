package che {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.ui.Mouse;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	public class tool {
		public static function rdmFl(a:int, b:int):int {
			return Math.floor(rdmNu(a, b));
		}

		public static function rdm(a:Number, b:Number):Number {
			return rdmNu(a, b);
		}

		public static function rdmNu(a:Number, b:Number):Number {
			if (a > b){
				var tmp:Number = a;
				a = b;
				b = tmp;  
			}
			if (a >= 0 && b > 0){
				return Math.random() * (b - a) + a;
			}
			if (a < 0 && b <= 0){
				return Math.random() * (a - b) + b;
			}
			if (a <= 0 && b >= 0){
				return (Math.random() - Math.random()) * (b - a) / 2 + (a + b) / 2;
			}
			return 0; //a==0;b==0;
		}
		
		/*
		 * 用法 ，综合了上面三个函数的用法
		 * random(5)				输出0-5小数
		 * random(5,0,true)			0-5整数
		 * random(5,10)				5-10小数
		 * random(10,5)				5-10小数（前后可以倒置）
		 * random(5,10,true)		5-10整数
		 * */
		public static function random(para1:Number,para2:Object=null,isInt:Boolean=false):Number { 
			if (!(para2 is Number)) {
				if (isInt)	return rdmFl(-para1,para1);
				else return rdm(-para1,para1)
			}else {
				if (isInt) {
					return rdmFl(para1,Number(para2));
				}else {
					return rdm(para1,Number(para2));
				}
			}
		}

		//数组乱序
		public static function dasanArray(a:Array):Array {
			var aa:Array = [];
			var leng:uint = a.length;
			for (var i:uint = 0; i < leng; i++){
				aa.push(
					a.splice(tool.rdmFl(0, a.length), 1)[0]
				);
			}
			return aa;
		}

		public static function set wt(other:*):void {
			trace(other);
		}

		//在flash自带的3d中，按照z进行深度排序，返回数组//aa,对象数组，d基点对象，相对于D进行排序
		public static function sortByZ(aa:Array, d:DisplayObject):Array {
			var leng:uint = aa.length;
			var tmpArr:Array = [];
			for (var i:uint = 0; i < leng; i++){
				tmpArr.push({
					s: aa[i], 
					dep: (aa[i].transform.getRelativeMatrix3D(d))['position'].z
				});
			}
			tmpArr.sortOn("dep", Array.NUMERIC | Array.DESCENDING);
			var rst:Array = [];
			for (i = 0; i < leng; i++){
				rst.push(tmpArr[i].s);
			}
			return rst;
		}
		
		//在flash自带的3d中，按照z进行深度排序，返回数组//aa,对象数组，d基点对象，相对于D进行排序 输入输出对象为displayobject
		public static function sortDisplayObjcetByZ(aa:Vector.<DisplayObject>, d:DisplayObject):Vector.<DisplayObject> {
			var leng:uint = aa.length;
			var list:Vector.<DisplayObject> = aa.concat();
			
			list.sort(function(x:DisplayObject, y:DisplayObject):Number {
				if (x.transform.getRelativeMatrix3D(d).position.z > y.transform.getRelativeMatrix3D(d).position.z) {
					return -1;
				}else {
					return 1;
				}
			});

			return list;
		}

		//使图片按照比例适应容器的大小//（容器大小，图片大小，【留边宽度】）：新 图片大小
		public static function putOnContainer(ct:Object, pc:Object, space:Number = 0):Array {
			var cont:Array;
			var pic:Array;
			if (ct is DisplayObject) {
				if (ct is Stage) {
					cont = [ct.stageWidth, ct.stageHeight];
				}else {
					cont = [ct.width, ct.height];
				}
				
				if (pc is DisplayObject) {
					pic = [pc.width, pc.height];
				}else {
					pic = pc as Array;
				}
			} else {
				cont = ct as Array;
				if (pc is DisplayObject) {
					pic = [pc.width,pc.height];
				}else {
					pic = pc as Array;
				}
			}
			///////////////

			var cw:Number = cont[0] - space;
			var ch:Number = cont[1] - space;
			var pw:Number = pic[0];
			var ph:Number = pic[1];
			
			var cn:Number = cw / ch;
			var pn:Number = pw / ph;

			var tmpArr:Array;
			if (cn > pn){
				tmpArr = [pw * ch / ph, ch];
			} else {
				tmpArr = [cw, cw * ph / pw];
			}
			tmpArr.push((cont[0] - tmpArr[0]) * 0.5);//(2012-11-21重要改版 除0.5改成乘0.5)
			tmpArr.push((cont[1] - tmpArr[1]) * 0.5);
			return tmpArr;
		}
		
		//上个函数的标准版
		public static function inContainer(container:Object, beObject:Object, space:Number = 0):Rectangle {
			if (container is Stage) {
				container = [container.stageWidth,container.stageHeight];
			}else if (container is DisplayObject) {
				container = [container.width,container.height];
			}
			
			if (beObject is DisplayObject) {
				beObject = [beObject.width, beObject.height];
			}
			
			var a:Array = putOnContainer(container, beObject, space);
			
			return new Rectangle(a[2],a[3],a[0],a[1]);
		}
		
		////////////////////
		public static function maxOnContainer(cont:Array, pic:Array, space:Number = 0):Array {
			var cw:Number = cont[0] - space;
			var ch:Number = cont[1] - space;
			var pw:Number = pic[0];
			var ph:Number = pic[1];
			var cn:Number = cw / ch;
			var pn:Number = pw / ph;

			var tmpArr:Array;
			if (cn > pn){
				tmpArr = [cw, cw / pn];
			} else {
				tmpArr = [ch * pn, ch];
			}
			tmpArr.push((cont[0] - tmpArr[0]) / 2);
			tmpArr.push((cont[1] - tmpArr[1]) / 2);
			return tmpArr;
		}
		
		//上个函数的标准版
		public static function outContainer(container:Object, beObject:Object, space:Number = 0):Rectangle {
			var para1:Array, para2:Array;
			if (container is DisplayObject) {
				para1 = [container.width,container.height];
			}
			if (container is Stage) {
				para1 = [container.stageWidth,container.stage.stageHeight];
			}
			
			if (container is Array) {
				para1 = container as Array;
			}
			
			if (beObject is DisplayObject) {
				para2 = [beObject.width,beObject.height];
			}
			
			if (beObject is Array) {
				para2 = beObject as Array;
			}
			
			var a:Array=maxOnContainer(para1,para2,space);
			return new Rectangle(a[2],a[3],a[0],a[1]);
		}

		//使dobj发送str类型事件，并传替inf对象给侦听器
		public static function evtSend(dobj:EventDispatcher, str:String, inf:Object, flg:Boolean = true):void {
			var e:EasyEvent= new EasyEvent(str, inf, flg);
			dobj.dispatchEvent(e);
		}

		public static function sendEvent(dispather:EventDispatcher, type:String, info:Object = null, canFlwFlg:Boolean = false):void { //最后一个参数表示能不能跑到事件流
			evtSend(dispather, type, !info ? {} : info, canFlwFlg);
		}

		//如果已经在舞台上执行，如果没有，等加上去再执行
		public static function onStage(obj:DisplayObject, exec:Function):void {
			if (obj.stage)	exec(null);
			else	obj.addEventListener(Event.ADDED_TO_STAGE, exec);
		}
		
		//当stage大小不为0的时候，执行//如果flash在网页里运行异常，可以试用此方法代替
		public static function stageNot0(obj:DisplayObject, exec:Function):void { //
			onStage(obj, monit);
			function monit(e:Event):void{
				obj.addEventListener(Event.ENTER_FRAME, onFrm);
				function onFrm(e:Event):void{
					if (obj.stage.stageWidth != 0){
						exec(null);
						obj.removeEventListener(Event.ENTER_FRAME, onFrm);
					} //if
				} //func onFrm
			} //function monit
		} //func

	
		//当stage的尺寸发生变化的时候，执行的函数
		public static function reSize(obj:DisplayObject, exec:Function, freshTime:Number = 500):void {
			var sw:Number = obj.stage.stageWidth;
			var sh:Number = obj.stage.stage.stageHeight;
			var tm:myTimer = new myTimer(freshTime, onTimer);
			function onTimer(e:Event):void{
				try {
					if (sw != obj.stage.stageWidth || sh !== obj.stage.stageHeight){
						sw = obj.stage.stageWidth;
						sh = obj.stage.stageHeight;
						exec();
					}
				} catch (e:Error){
					trace(e);
					tm.stop();
				}
			}
		} //function
		

		//快速增加几个常用的鼠标事件
		public static function addMouseEvent(obj:DisplayObject, onMover:Function = null, onMout:Function = null, onClk:Function = null, mouseOverFlg:Boolean = false):void {
			if (mouseOverFlg){
				obj.addEventListener(MouseEvent.MOUSE_OVER, onMover);
				obj.addEventListener(MouseEvent.MOUSE_OUT, onMout);
			} else {
				obj.addEventListener(MouseEvent.ROLL_OVER, onMover);
				obj.addEventListener(MouseEvent.ROLL_OUT, onMout);
			}
			onClk && obj.addEventListener(MouseEvent.CLICK, onClk);
		}

		//通过对象获得所属的类名
		public static function getRootName(obj:DisplayObject):String {
			return getQualifiedClassName(obj.stage.getChildAt(0));
		}
		
		public static function getOuterSwfRootname(obj:DisplayObject):String {
			return getQualifiedClassName(obj.root);
		}

		//增加鼠标手形
		public static function setHandCursor(obj:DisplayObject, cursor:String = "button"):void{
			addMouseEvent(obj, mOver, mOut, function(e:MouseEvent):void{});
			
			function mOver(e:MouseEvent):void{
				Mouse.cursor = cursor;
			}
			function mOut(e:MouseEvent):void{
				Mouse.cursor = "arrow";
			}
		}

		public static function swfBgColor(obj:DisplayObject, col:uint = 0x000000):void{
			var s:Sprite = obj.stage.getChildAt(0) as Sprite;
			s.graphics.beginFill(col, 1);
			s.graphics.drawRect(0, 0, 5000, 3000);
			s.graphics.endFill();
		}

		public static function hd2jd(n:Number, flg:Boolean = true):Number {
			if (flg){
				return n * 180 / Math.PI;
			} else {
				return n * Math.PI / 180;
			}
		}

		public static function toUrl(s:String, newWindoflg:Boolean = true):void{
			navigateToURL(new URLRequest(s), newWindoflg?'_blank':'_self');
		}

		//强制垃圾回收，不建议使用
		public static function clearMemory():void {
			try {
				new LocalConnection().connect("jianren719");
				new LocalConnection().connect("jianren719");
			} catch (error:Error){
			}
		} //function

		//取掉字符串的前后空格
		public static function trim(returnString:String):String {
			for (; returnString.charCodeAt(0) == 0x20; returnString = returnString.substr(1)){}
			for (; returnString.charCodeAt(returnString.length - 1) == 0x20; returnString = returnString.substr(0, returnString.length - 1)){}
			return returnString;
		}

		//去掉字符串的前后回车
		public static function trimEnter(returnString:String):String {
			for (; returnString.substr(0, 1) == String.fromCharCode(13); returnString = returnString.substr(1)){}			for (; returnString.substr(returnString.length - 1, 1) == String.fromCharCode(13); returnString = returnString.substr(0, returnString.length - 1)){}
			return returnString;
		}

        //把ByteArray转换成String（）
		public static function ByteArray2ByteString(btArray:ByteArray):String {
			var ret:String = "";
			btArray.position = 0;
			while (btArray.bytesAvailable > 0){
				ret += btArray.readByte().toString(16) + " ";
			}
			return ret;
		}
		
		//父类树种是否存在某对象//不检测stage
		public static function hasParentChain(d:DisplayObject,container:DisplayObjectContainer):Boolean{
			if(d==null||container==null)
				return false;
			
			return container.contains(d);
			
			//以前是用循环遍历的方式寻找。后来发现api有这个方法
			/*
			return findParent(d);
			function findParent(dobj:DisplayObject):Boolean
			{
				if(dobj.parent!=null&&dobj.parent!=dobj.stage){
					if(dobj==container){
						return true;
					}
					//Mdg.tr(dobj.parent,"tool里面");
					//trace(dobj.parent);
					return findParent(dobj.parent);
				}else{
					return false;
				}
				
			}//func
			*/
		}
		
		//显示程序运行的时间
		private static var _initDate:Date = new Date;
		public static function traceWithTime(s:String='时间标签：'):void {
			trace(s,new Date().time-_initDate.time);
		}
		
		//重新设置起始时间，不设置就是程序开始时间为起始时间
		public static function initTraceWithTime():void {
			_initDate = new Date();
		}//
		
		
		public static function removeListener(ar:*):void {
			//arguments传入此局部变量
			if (ar != null && ar.length != 0 && ar[0] is Event) { 
				ar[0].currentTarget.removeEventListener(ar[0].type,ar.callee);
			}else {
				//trace('无侦听移除'); 
			}
		}
		
		//设置stage
		public static function setStageAlign(disobj:DisplayObject):void {
			if (disobj.stage) {
				disobj.stage.align = 'TL';
				disobj.stage.scaleMode = 'noScale';
			}else {
				disobj.addEventListener(Event.ADDED_TO_STAGE, function(e:Event):void {
					removeListener(arguments);
					disobj.stage.align = 'TL';
					disobj.stage.scaleMode = 'noScale';
				});
			}
		}
		
		//改进官方弱弱的globalToLoacl3D //容器  全局坐标  深度  相对于谁的 PerspectiveProjection   //z未输出，值不变
		//localContainer如果设置过rotationX rotationY z 等属性 次方法失效，falsh的bug  即使设置值为0依然不行
		public static function globalToLoacl3D(localContainer:DisplayObject,globalxy:Point,z:Number,PerspectiveProjectionHost:DisplayObjectContainer=null,newprojectionCenter:Point=null):Point {
			if (!localContainer.stage) {
				trace('globalToLoacl3D：容器未获得stage');
				return null;
			}
			
			var pers:PerspectiveProjection;
			if (!PerspectiveProjectionHost) 
				PerspectiveProjectionHost = localContainer.root as DisplayObjectContainer;
			
			pers = PerspectiveProjectionHost.transform.perspectiveProjection;
			if (!pers) {
				trace('PerspectiveProjectionHost设置不当');
				return null;
			}
			
			if (!newprojectionCenter) {
				newprojectionCenter = pers.projectionCenter;
			}
									
			var localPt:Point = localContainer.globalToLocal(
					new Point(
						globalxy.x + z * (globalxy.x - newprojectionCenter.x) / pers.focalLength,
						globalxy.y + z * (globalxy.y - newprojectionCenter.y) / pers.focalLength
					)
				);
			return localPt;//localContainer.globalToLocal(globalxy);
		}
		
		
		//从rootDot 的后代显示列表中找到第一名称为name的显示对象
		public static function getDescendantsByName(rootDot:DisplayObjectContainer,name:String):DisplayObject {
			return findInTree(rootDot, name);
			function findInTree(dio:DisplayObjectContainer, name:String):DisplayObject {
				var currentDio:DisplayObject;
				for (var i:int = 0; i < dio.numChildren; i++ ) {
					currentDio = dio.getChildAt(i);
					
					//找到了 返回对象
					if (currentDio && currentDio.name == name) {
						return currentDio;
					}
					
					//发现 容器，继续遍历
					if (currentDio as DisplayObjectContainer && (currentDio as DisplayObjectContainer).numChildren > 0) {
						var dis:DisplayObject = findInTree(currentDio  as DisplayObjectContainer, name);
						
						//遍历有结果，返回结果  无结果继续循环
						if (dis) {
							return dis;	
						}else {
							//此句可以不写
							continue;
						}
					}
				}
				
				//循环完还没找到 返回空
				return null;
			}
		}
		
		
		//快速画矩形的方法，如果指定inCenterFlag为true  x y的设定将失效
		//color  只接受String和int,String时候透明度用为百分率--'f9f9f9|50'表示颜色f9f9f9透明度是0.5
		public static function drawRectInSprite(sprite:Sprite, inCenterFlag:Boolean = false, width:Number = 10, height:Number = 10, x:Number = 0, y:Number = 0, color:Object = 0xf0f0f0):void {
			var gf:Graphics = sprite.graphics;
			
			if (color is int) {
				gf.beginFill(int(color),1);
			}else {
				var sc:String = color.toString();
				var ar:Array = sc.split('|');
				gf.beginFill(
					parseInt(ar[0], 16)
					,
					parseInt(ar[1])/100
				);
			}
			
			
			if (inCenterFlag) {
				x = -width / 2;
				y = -height / 2;
			}
			
			gf.drawRect(x, y, width, height);
		}
		
		//颜色参数提前
		public static function drawRectInSprite2(sprite:Sprite, color:Object = 0xf0f0f0, inCenterFlag:Boolean = false, width:Number = 10, height:Number = 10, x:Number = 0, y:Number = 0) {
			drawRectInSprite(sprite, inCenterFlag, width, height, x,y,color);
		}
		
		public static function getRequest(url:String,paras:Object=null,useGetMethod:Boolean=true):URLRequest {
			var ur:URLRequest = new URLRequest(url);
			
			var udata:URLVariables = new URLVariables;
			if (paras) for (var p:String in paras) udata[p] = paras[p];
			ur.data = udata;
			ur.method = useGetMethod?'GET':'POST';
			return ur;
		}
		
		//根据objec的属性值，获取属性名
		public static function getObjectKeyByValue(obj:Object,value:*) {
			for (var k:String in obj) {
				if (obj[k] == value)
					return k;
			}
			
			return null;
		}
		
		
		//得到一个安全的数组索引，超出的都会取模
		public static function safeIndex(nosafeindex:int,length:int):int {
			for (; nosafeindex < 0 ;nosafeindex += length ) {};
			return Math.abs(nosafeindex % length); 
		}
		
		//把对象序列数组，可以根据属性，方法（传参）//最后一个参数传入空数组，表示调用的是方法 //不能用于xml或者xmllist等代理对象
		public static function objectToArray(obj:Object,attr_func:Object=null,funcParas:Array = null):Array {
			var renturnArray:Array = [];
			for (var k:String in obj) {
				if (attr_func == null) {
					renturnArray.push(obj[k]);
				}else {
					if (funcParas) {
						renturnArray.push(obj[k][attr_func].apply(null, funcParas));
					}else {
						renturnArray.push(obj[k][attr_func]);
					}
				}
			}
			
			return renturnArray;
		}
	} //class
}
////////////////////////////////////////////////////////////////////////////////////////////////////////包外类

//////////////////////////////////////////////////////////////////////////////////////////////////////////