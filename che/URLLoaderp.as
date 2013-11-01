package che{
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class URLLoaderp extends URLLoader{
		private var _req:URLRequest;
		private var _ownerUrlrequest:URLRequest=new URLRequest;
		
		//可以携带一些信息
		public var info:*;
		public var isBusy:Boolean=false;
		public function URLLoaderp(req:URLRequest=null){
			super(req);
			_req=req;
		}
		
		public override function load(request:URLRequest):void{
			_req=request;
			super.load(request);
		}
		
		public override function close():void{
			super.close();
			isBusy=false;
		}
		
		public function loadp(para1:*):void{
			if(para1 is URLRequest){
				load(para1);
			}else if(para1 is String){
				_ownerUrlrequest.url=para1;
				super.load(_ownerUrlrequest);
			}
		}
		
		
		public function get urlRequest():URLRequest{
			return _req;
		}
		
		//加载完成时候清除req，标识状突，以为停止
		public function clearRequest():void{
			_req=null;
		}
	}//class
}