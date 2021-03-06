﻿package che {
	import com.greensock.events.LoaderEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	public class Cprite extends Sprite {
		public static var traceEnable:Boolean = true;
		private static function print(...res):void {
			traceEnable &&  trace.apply(null,res);
		}
		
		/*
		 *不用的时候记得析构
		 * */
		public function disposeme():void {
			//stage.removeEventListener(Event.RESIZE,stageResize);
		}
		
		
		public function Cprite() {
			for (var i:int = 0; i < this.numChildren; i++ ) {
				childsco.push(this.getChildAt(i));
			}
			_meco.push(this);
			
			if (stage) {
				hasStage();
				initial(null);
				gotStage();
			}else {
				addEventListener(Event.ADDED_TO_STAGE, function(e:Event):void {
					initial(e);
					gotStage(e);
					e.target.removeEventListener(e.type, arguments.callee);
					hasStage();
				});
			}
		}
		
		protected function hasStage():void {
			Squery.ins.init(stage);
		}
		
		//仅执行一次。以后再addToStage不执行
		public function set onstageFunc(init:Function):void {
			if (stage) {
				init();
			}else {
				addEventListener(Event.ADDED_TO_STAGE, function(e:Event):void {
					e.target.removeEventListener(e.type, arguments.callee);
					init();
				});
			}
		}

		
		/**
		 * 获得stage
		 * @param	e
		 */
		public function initial(e:Event):void {
			
		}
		
		/**
		 * 获得stage
		 * @param	e
		 */
		protected function gotStage(e:Event = null):void {
			
		}

		
		/**
		 * 获取sprite
		 * @param	nameOrIndex		可以根据name或者index
		 * @param	byIndexFlag
		 * @return
		 */
		public function getSpriteChild(nameOrIndex:*,byIndexFlag:Boolean=false):Sprite {
			if (byIndexFlag) {
				return getChildAt(nameOrIndex) as Sprite;
			}else {
				return getChildByName(nameOrIndex) as Sprite;
			}
		}
		
		public function getClipChild(nameOrIndex:*, byIndexFlag:Boolean = false):MovieClip {
			return getSpriteChild(nameOrIndex,byIndexFlag) as MovieClip;
		}
		
		public function getTxChild(textName:String):TextField {
			return getChildByName(textName) as TextField;
		}
		
		/**
		 * @param 要删除或要排除删除的子元素数组
		 * @param 指定是要删除数组里的子元素还是要排除删除
		 * @return 已经删除的子元素的列表
		 */
		public function removeChilds(childs:Array = null, excludeModeFlag:Boolean = false):Array {
			var returnArr:Array = [];
			var i:int;
			if (childs == null) {
				if (!excludeModeFlag) {//删除模式
					for (; numChildren > 0; ) {
						returnArr.push(removeChildAt(0));
					}
				}				
			}else {
				if (excludeModeFlag) {
					var initChildNum:int = numChildren;
					for (i = initChildNum-1; i >=0;i--) {
						if (childs.indexOf(getChildAt(i)) == -1) {
							returnArr.push(removeChildAt(i));
						}
					}
				}else {
					for (i = 0; i < childs.length; i++) {
						if (childs[i].parent == this) {
							removeChild(childs[i]);
						}else {
							returnArr.splice(returnArr.indexOf(childs[i]), 1);
							throw(new Error('要删除的对象至少应该该对象的子集吧'+'Cprite'));
						}
					}
					returnArr = childs;
				}
			}
			return returnArr;
		}
		
		
		public function addChilds(childs:Array):Array {
			for (var i:String in childs)	addChild(childs[i]);
			return childs;
		}
		
		public function setChildSpriteAttr(p:Object):void {
			for (var i:String in p) {
				for (var n:int = 0; n < numChildren; n++ ) {
					if (getChildAt(n) as Sprite)	Sprite(getChildAt(n))[i] = p[i];
				}
			}
		}
		
		public function set scale(n:Number):void {
			scaleX = scaleY = n;
		}
		
		public function get(attrObject:Object, findMode:Object = '=',rootContainer:DisplayObject=null,getOneMode:Boolean=false,flyMode:Boolean=false):Array {
			if(!rootContainer)	rootContainer=this;
			return Squery.ins.get(attrObject, rootContainer, findMode, getOneMode, flyMode);
		}
		
		public function fly(attrObject:Object, findMode:Object = '=', rootContainer:DisplayObject = null,  flyMode:Boolean = false):Array {
			if(!rootContainer)	rootContainer=this;
			return Squery.ins.getOne(attrObject, rootContainer, findMode, flyMode);
		}
		
		/**
		 * 在子树里查找符合条件的显示对象
		 * @param	attrObject
		 * @param	findMode
		 * @param	rootContainer
		 * @param	flyMode
		 * @return
		 */
		public function getOne(attrObject:Object,  findMode:Object = '=', rootContainer:DisplayObject = null, flyMode:Boolean = false):Array { 
			if(!rootContainer)	rootContainer=this;
			return Squery.ins.getOne(attrObject, rootContainer, findMode, flyMode);
		}
		
		/*
		 *计算相对于某父类的3d坐标，在旋转之后此方法用起来比较方便
		 * */
		public function getPosotionToAFathar(aparent:DisplayObjectContainer = null):Vector3D {
			if (aparent == null) aparent = stage;
			return transform.getRelativeMatrix3D(aparent).position;
		}
		
		
		public function sortChilds(sortFunc):void {
			
		}
		
		//链式操作
		public function listen(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):Cprite 
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			return this;
		}
		
		//12-11-15
		public function centerDisplayObject(dis:DisplayObject,offsetx:Number=0,offsety:Number=0):DisplayObject {
			
			//dis.x = -dis.width * 0.5 + offsetx; dis.y = -dis.height * 0.5 + offsety;
			setDisplayObjectPoistion(dis,0,0,offsetx,offsety);
			return dis;
		}
		
		/**
		 * 放置对象位置xpos,ypos取值为【-1,0,1】分别表示左中右（上中下）
		 * @param	dio
		 * @param	xpos
		 * @param	ypos
		 * @param	xoffset
		 * @param	yoffset
		 * @return
		 */
		public function setDisplayObjectPoistion(dio:DisplayObject,xpos:int = 0, ypos:int = 0,xoffset:Number=0,yoffset:Number=0):DisplayObject {
			dio.x = (xpos - 1) * 0.5 * dio.width + xoffset;
			dio.y = (ypos - 1) * 0.5 * dio.height + yoffset;
			return dio;
		}
		
		/**
		 * 包裹一个Sprite
		 * @param	dis
		 * @param	centerIt
		 * @return
		 */
		public function wrapSprite(dis:DisplayObject,centerIt:Boolean=false):Sprite {
			var s:Sprite = new Sprite;
			s.addChild(dis);
			if (centerIt) centerDisplayObject(dis);
			return s;
		}

		/**
		 * 发送一个che.EasyEvent事件类型对象
		 * @param	str		事件名称
		 * @param	inf		事件信息
		 * @param	flg		是否向上流动
		 */
		public function evtSend(str:String, inf:Object, flg:Boolean = true):void {
			var e:EasyEvent= new EasyEvent(str, inf, flg);
			this.dispatchEvent(e);
		}

		public function sendEvent(type:String, info:Object = null, canFlwFlg:Boolean = false):void { //最后一个参数表示能不能跑到事件流
			evtSend(type, !info ? {} : info, canFlwFlg);
		}
		
		
		private var _childsco:Co = new Co;
		public function get childsco():Co { return _childsco; };
		private var _meco:Co = new Co;
		public function get meco():Co { return _meco; }
		
		//覆盖
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			childsco.push(child);
			return super.addChild(child);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			childsco.addChildAt(child,index);
			return super.addChildAt(child, index);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject 
		{
			if (child.parent != this) {
				print("removeChild失败，提供的 DisplayObject 必须是调用者的子级");
				return child;
			}
			childsco.removeChild(child);
			return super.removeChild(child);
		}
		
		override public function removeChildAt(index:int):DisplayObject 
		{
			childsco.removeChildAt(index);
			return super.removeChildAt(index);
		}
		
		/**
		 * 重写，记录所增加的事件名称和处理函数绑定
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReference
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			var obj:Object = { };
			obj[type] = listener;
			meco.addRecord(obj);
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * 重写，删除已记录的事件和句柄关系
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			var obj:Object = { };
			obj[type] = listener;
			meco.removeRecord(obj);
			super.removeEventListener(type, listener, useCapture);
		}
		//--覆盖
		
		//增加一个背景，布局时候比较有用
		public static const HIDEBACKGROUND_POSITION_FU:int = -1;
		public static const HIDEBACKGROUND_POSITION_ZHENG:int = 1;
		public static const HIDEBACKGROUND_POSITION_LING:int = 0;
		
		public var _backGroundShape:Shape;
		private var _backGroundPosition_x:int = 1;
		private var _backGroundPosition_y:int = 1;
		private var _backGroundShapARGBColor:uint = 0xffffffff;
		
		public function setHiddenBackGround(sizeObject:Object, positionObject:Object = null):void {
			setBackGroundColor(0x00ffffff,sizeObject,positionObject);
		}
		
		/**
		 * 移除背景
		 */
		public function removeBackGroundShape():void {
			if (_backGroundShape && _backGroundShape.parent) removeChild(_backGroundShape);
		}
		
		/**
		 * 设置背景
		 * @param	aRGBColor		颜色形式为argb
		 * @param	positionObject	位置
		 * @param	sizeObject	尺寸
		 */
		public function setBackGroundColor(aRGBColor:Number=0xff00000000,positionObject:Object = null,sizeObject:Object = null):void { 
			if (!_backGroundShape) {
				_backGroundShape=new Shape;
				addChildAt(_backGroundShape, 0);
				var gf:Graphics = _backGroundShape.graphics;
				if (aRGBColor >= 0)	_backGroundShapARGBColor = aRGBColor;
				
				gf.beginFill(
					_backGroundShapARGBColor & 0x00ffffff, 
					_backGroundShapARGBColor >>> (4 * 6)
				);
				
				//trace(_backGroundShapARGBColor.toString(2));
				//trace(uint(_backGroundShapARGBColor >>> (4*6)).toString(2));
				
				gf.drawRect(0, 0, 100, 100);
				gf.endFill();
			}
			
			if (!_backGroundShape.parent) {
				addChild(_backGroundShape); 
			}
			
			if (positionObject == null) positionObject={x:1,y:1}
			
			if (positionObject is int) {
				_backGroundPosition_x = _backGroundPosition_y = int(positionObject);
			}else {
				if (positionObject.x != undefined) { _backGroundPosition_x = positionObject.x };
				if (positionObject.y != undefined) { _backGroundPosition_y = positionObject.y };
			}
			
			
			if (!sizeObject) sizeObject = 27;
			setBackGroundSize(sizeObject);
		}
		
		/**
		 * 设置背景尺寸
		 * @param	sizeObject_width {width:xx,height:xxx} 形式或者宽度数字
		 * @param	height
		 */
		public function setBackGroundSize(sizeObject_width:Object = 27, height:Number = -1):void { 
			if (!_backGroundShape)	return;
			
			if (sizeObject_width is Number) {
				_backGroundShape.width = Number(sizeObject_width); 
				if (height < 0)	height = _backGroundShape.width;
				
				_backGroundShape.height = height;
			}else {
				if (sizeObject_width.width != undefined) _backGroundShape.width = sizeObject_width.width;
				if (sizeObject_width.height != undefined) _backGroundShape.height = sizeObject_width.height;
			}
			
			setDisplayObjectPoistion(_backGroundShape, _backGroundPosition_x, _backGroundPosition_y);
			//_backGroundShape.x = (_backGroundPosition_x - 1) * 0.5 * _backGroundShape.width;
			//_backGroundShape.y = (_backGroundPosition_y - 1) * 0.5 * _backGroundShape.height;
		}
		//
		
		
		/**
		 * 设置stage对齐方式 noScale,TL
		 */
		public function setStageAlign():void {
			var disobj:DisplayObject = this;
			if (disobj.stage) {
				disobj.stage.align = 'TL';
				disobj.stage.scaleMode = 'noScale';
			}else {
				throw(new Error("stage为空，请先获取stage..."));
			}
		}

		/**
		 * 获取rootclass名，不包括包名
		 * @param isFullName 是否是全路径名
		 */
		public function getRootClassName(isFullName:Boolean = false):String {
			if (isFullName) {
				return getQualifiedClassName(this.root);
			}else {
				return getQualifiedClassName(this.root).split(":").pop();
			}
		}
		
		/**
		 * offsetX,offsetY和真实的x，y合成当前对象的位置
		 */
		private var _offsetX:Number = 0, _offsetY:Number = 0, _x:Number = 0, _y:Number = 0;
		
		/**
		 * x偏移
		 */
		public function get offsetX():Number 
		{
			return _offsetX;
		}
		
		public function set offsetX(value:Number):void 
		{
			_offsetX = value;
			super.x = offsetX + x;
		}
		
		/**
		 * y偏移
		 */
		public function get offsetY():Number 
		{
			return _offsetX;
		}
		
		public function set offsetY(value:Number):void 
		{
			_offsetX = value;
			super.y = offsetY + y;
		}
		
		/**
		 * 覆盖x
		 */
		override public function get x():Number 
		{
			return _x;
		}
		
		override public function set x(value:Number):void 
		{
			_x = value;
			super.x = offsetX + x;
		}
		
		/**
		 * 覆盖y
		 */
		override public function get y():Number 
		{
			return _y;
		}
		
		override public function set y(value:Number):void 
		{
			_y = value;
			super.y = offsetY + y;
		}
	}
}