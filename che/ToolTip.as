/**
*使用之前，需要先给stage属性设置值，相当于初始化 
*Author: ATHER Shu 2008.7.15
* ToolTip类: 鼠标提示类
* 功能：
* 1.绑定某DisplayObject以显示鼠标提示 BindDO
* 2.去除某DisplayObject绑定 LooseDO
* 3.动态更改某DisplayObject鼠标提示信息 setDOInfo
* 4.测试某DisObject是否已经绑定 TestDOBinding
* 5.动态隐藏所有鼠标提示 hideToolTip
* 6.动态显示所有鼠标提示 showToolTip
* 7.清空所有鼠标提示 removeToolTip
* 8.设定全局鼠标提示样式 setTipProperty
* http://www.asarea.cn
* ATHER Shu(AS)
*/
package che
{
	import com.greensock.events.LoaderEvent;
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    public class ToolTip extends Sprite
    {
        static private var m_stage:Stage;//注，tooltip必须加到stage下 
        static private var m_ntxtcolor:uint=0x000000;
        static private var m_ntxtsize:int=12;
        static private var m_nbordercolor:uint=0x000000;
        static private var m_nbgcolor:uint=0xFFFFCC;
        static private var m_nmaxtxtwidth:Number = 200;
		static private var m_LRSpace:Number = 4;
		static private var m_fontFace:String;
		static private var m_juchi:Object = { };
        //
        static private var m_uniqueInstance:ToolTip;
        //
        private var m_arrDOTips:Array;
        private var m_tipTxt:TextField;
        //
        public function ToolTip()
        {
            super();
            m_arrDOTips = new Array();
        }
        //获取全局唯一实例
        private static function getInstance():ToolTip
        {
            if(m_uniqueInstance == null)
            {
                m_uniqueInstance = new ToolTip();
                m_uniqueInstance.visible = false;
                m_uniqueInstance.m_tipTxt = new TextField();
                m_uniqueInstance.m_tipTxt.autoSize = TextFieldAutoSize.LEFT;
                m_uniqueInstance.m_tipTxt.selectable = false;
                m_uniqueInstance.addChild(m_uniqueInstance.m_tipTxt);
                //
				m_uniqueInstance.mouseChildren = m_uniqueInstance.mouseEnabled = false;
                m_stage.addChild(m_uniqueInstance);
            }
            return m_uniqueInstance;
        }
        //清空tooltips，注：不是隐藏所有，而是彻底清空，如果要隐藏，某一时刻又显示出来的话，采用hide和show
        public static function removeToolTip():void
        {
            for(var i:int=0; i<getInstance().DOTips.length; i++)
            {
                getInstance().DOTips[i].DO.removeEventListener(MouseEvent.ROLL_OVER, showtip);
                getInstance().DOTips[i].DO.removeEventListener(MouseEvent.ROLL_OUT, hidetip);
                getInstance().DOTips[i].DO.removeEventListener(MouseEvent.MOUSE_MOVE, movetip);
                getInstance().DOTips[i] = null;
                m_stage.removeChild(getInstance());
                m_uniqueInstance = null;
            }
        }
        //暂时隐藏
        public static function hideToolTip():void
        {
            m_stage.removeChild(getInstance());
        }
        //再次show
        public static function showToolTip():void
        {
            m_stage.addChild(getInstance());
        }
		
		//ccwq 精简
		//增加 删除 修改绑定均用此函数
		//不存在 绑定，已存在修改，信息空删除 //无stage则增加stage
		public static function bind(dispalyObject:DisplayObject, infoString:String = null):void {
			if (!m_stage && dispalyObject.stage)
				m_stage = dispalyObject.stage;
			
			if (!m_stage) {
				trace('请设置 ToolTip.stage属性');
				return;
			}
				
			if (TestDOBinding(dispalyObject) == -1) {
				if (infoString == null)
					trace('che.ToolTip','无操作');
				else
					BindDO(dispalyObject, infoString);
			}else {
				if(infoString!=null)
					setDOInfo(dispalyObject, infoString);
				else {
					LooseDO(dispalyObject);
					hidetip(null);
				}
			} 	
		}
		
        //添加某DO的tip绑定
        public static function BindDO(DO:DisplayObject, info:String):void
        {
            //test if already been binded
            if(TestDOBinding(DO) == -1)
            {
                //add to array
                var dotip:Object = {DO:DO, info:info};
                getInstance().DOTips.push(dotip);
                //
                DO.addEventListener(MouseEvent.ROLL_OVER, showtip);
                DO.addEventListener(MouseEvent.ROLL_OUT, hidetip);
                DO.addEventListener(MouseEvent.MOUSE_MOVE, movetip);
            }
        }
        //去除某DO的tip绑定
        public static function LooseDO(DO:DisplayObject):void
        {
            if(TestDOBinding(DO) != -1)
            {
                for(var i:int=TestDOBinding(DO); i<getInstance().DOTips.length-1; i++)
                {
                    getInstance().DOTips[i] = getInstance().DOTips[i+1];
                }
                getInstance().DOTips.pop();
                DO.removeEventListener(MouseEvent.ROLL_OVER, showtip);
                DO.removeEventListener(MouseEvent.ROLL_OUT, hidetip);
                DO.removeEventListener(MouseEvent.MOUSE_MOVE, movetip);
            }
        }
        //更改某绑定DO的文字信息
        public static function setDOInfo(DO:DisplayObject, info:String):void
        {
            if(TestDOBinding(DO) == -1)
                BindDO(DO, info);
            else
                getInstance().DOTips[TestDOBinding(DO)].info = info;
        }
        //测试是否已经绑定，绑定则返回数组中的次序，否则返回-1
        public static function TestDOBinding(DO:DisplayObject):int
        {
            var flag:Boolean = false;
            for(var i:int=0; i<getInstance().DOTips.length; i++)
            {
                if(getInstance().DOTips[i].DO == DO)
                {
                    flag = true;
                    break;
                }
            }
            return (flag ? i : -1);
        }
        //
        private static function showtip(evt:MouseEvent):void
        {
           // getInstance().x = evt.stageX;
           // getInstance().y = evt.stageY + 20;//注，20是鼠标高度
			movetip(evt);
            getInstance().m_tipTxt.wordWrap = false;
            getInstance().m_tipTxt.text = getInstance().DOTips[TestDOBinding(evt.target as DisplayObject)].info;
            updatetip();
            getInstance().visible = true;
        }
        private static function hidetip(evt:MouseEvent):void
        {
			if(getInstance())
				getInstance().visible = false;
        }
        private static function movetip(evt:MouseEvent):void
        {
			var tarX:Number=evt.stageX;
			var tarY:Number=evt.stageY+20;
			if(tarX> m_stage.stageWidth-getInstance().width)
				tarX=evt.stageX-getInstance().width;
			if(tarX<0)
				tarX=0;
			
			if(tarY<0)
				tarY=0;
			if(tarY>m_stage.stageHeight-getInstance().height-20)
				tarY=evt.stageY-getInstance().height-5;
				
            getInstance().x = tarX;
            getInstance().y = tarY; 
        }
        private static function updatetip():void
        {
            getInstance().m_tipTxt.textColor = m_ntxtcolor;
            if(getInstance().m_tipTxt.width > m_nmaxtxtwidth)
            {
                getInstance().m_tipTxt.wordWrap = true;
                getInstance().m_tipTxt.width = m_nmaxtxtwidth;
            }
            var tf:TextFormat = new TextFormat();
            tf.size = m_ntxtsize;
			m_fontFace && (tf.font = m_fontFace);
			
            getInstance().m_tipTxt.setTextFormat(tf);
			
			//字体平滑设置
			if (m_juchi.shapeness != undefined) {
				getInstance().m_tipTxt.antiAliasType = "advanced";
				getInstance().m_tipTxt.sharpness = m_juchi.shapeness;
			}else {
				getInstance().m_tipTxt..antiAliasType = "normal";
				getInstance().m_tipTxt.sharpness = 0;
			}
			
            //
            var gp:Graphics = getInstance().graphics;
            gp.clear();
            gp.lineStyle(0, m_nbordercolor);
            gp.beginFill(m_nbgcolor);
            gp.drawRect(-m_LRSpace, 0, getInstance().m_tipTxt.width+m_LRSpace, getInstance().m_tipTxt.height);
            gp.endFill();
            //加阴影
            getInstance().filters =[new DropShadowFilter(2)]; 
        }
        //
        public static function set stage(stage:Stage):void
        {
            m_stage = stage;
        }
		
		public static function get stageIsNull():Boolean {
			if (m_stage)
				return false;
			else
				return true;
		}
        public static function setTipProperty(txtcolor:uint=0x000000, txtsize:int=12, maxtxtwidth:int=200, bordercolor:uint=0x000000, bgcolor:uint=0xFFFFCC,LRSpace:Number=4,fontFace:String=null):void
        {
            m_ntxtcolor = txtcolor;
            m_ntxtsize = txtsize;
            m_nmaxtxtwidth = maxtxtwidth;
            m_nbordercolor = bordercolor;
            m_nbgcolor = bgcolor;
			m_LRSpace = LRSpace;
			m_fontFace = fontFace;
        }
		
		public static function config(cfg:Object):void {
			if (!cfg)	return;
			m_ntxtcolor = cfg.txtcolor ||  m_ntxtcolor;
            m_ntxtsize = cfg.txtsize || m_ntxtsize;
            m_nmaxtxtwidth = cfg.maxtxtwidth || m_nmaxtxtwidth;
            m_nbordercolor = cfg.bordercolor || m_nbordercolor;
            m_nbgcolor = cfg.bgcolor || m_nbgcolor;
			m_LRSpace = cfg.LRSpace || m_LRSpace;
			m_fontFace = cfg.fontFace || m_fontFace;
			m_juchi = cfg.juchi || m_juchi;
			
		}
        //
        private function get DOTips():Array
        {
            return m_arrDOTips;
        }
    }
}