/*
   读写ShareObject本地数据
*/
package che
{
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;

	public class AccessLocalObject extends Object
	{
		public static const SHARED_OBJECT_NAME:String="senwasFlex";
		
		private static var _ins:AccessLocalObject;
		public static function get ins():AccessLocalObject
		{		
			if(_ins==null)
				_ins=new AccessLocalObject;
			
			return _ins;
		}
		public function AccessLocalObject()
		{
			super();
		}
		/////////////
		private var resultFunc:Function=null;
		private var mySo:SharedObject;
		
		public function readLoacalObject(sharedObjectName:String='sharedObjectName'):Object{
			mySo=SharedObject.getLocal(SHARED_OBJECT_NAME);
			if(mySo.data.lastUserInfo!=undefined)
				return mySo.data.lastUserInfo;
			return null;
		}
		
		public function writeToLoacal(data:Object,sharedObjectName:String='sharedObjectName',resultFunction:Function=null):void{
			resultFunc=resultFunction;
			
			mySo=SharedObject.getLocal(SHARED_OBJECT_NAME);
			mySo.data.lastUserInfo=data;
			var flushStatus:String = null;
			try {
				flushStatus = mySo.flush(10000);
			} catch(error:Error) {
				trace("Error...Could not write SharedObject to disk\n");
				runFunc(false);
			}
			
			if (flushStatus != null) {
				switch (flushStatus) {
					case SharedObjectFlushStatus.PENDING: //需要用户许可才能写入
						trace("Requesting permission to save object...\n");
						mySo.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
						break;
					case SharedObjectFlushStatus.FLUSHED:
						trace("Value flushed to disk.\n");
						runFunc();
					break;
				}//switch
			}//if
		}//func
	
		//用户许可结果
		private function onFlushStatus(event:NetStatusEvent):void {
			trace("User closed permission dialog...\n");
			switch (event.info.code) {
				case "SharedObject.Flush.Success":
					trace("User granted permission -- value saved.\n");
					runFunc();
					break;
				case "SharedObject.Flush.Failed":
					trace("User denied permission -- value not saved.\n");
					runFunc(false);
					break;
			}
			mySo.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
		}
		
		private function runFunc(flag:Boolean=true):void
		{
			if(resultFunc!=null)
				resultFunc(flag); 
			
			resultFunc=null;
		}
	}
}