package che {

	import flash.display.Loader;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.EventDispatcher;
	import flash.system.LoaderContext;

	public class ClassLoader extends EventDispatcher {

		public var url:String;
		public var loader:Loader;

		//���캯��
		public function ClassLoader(obj:Object = null, lc:LoaderContext = null){
			if (obj != null){
				if (obj is ByteArray){
					loadBytes(obj as ByteArray, lc);
				} else if (obj is String){
					loadByUrl(obj as String, lc);
				} else {
					throw new Error("�������󣬹��캯����һ����ֻ����ByteArray��String");
				}
			}
		}

		//����
		public function loadByUrl(_url:String, lc:LoaderContext = null):void {
			load(new URLRequest(_url), lc);
		}
		
		//����
		public function load(_urlReq:URLRequest, lc:LoaderContext = null) {
			loader = new Loader;
			loader.load(_urlReq, lc);
			addEvent();
		}

		//�����ֽ�
		public function loadBytes(bytes:ByteArray, lc:LoaderContext = null):void {
			loader = new Loader;
			loader.loadBytes(bytes, lc);
			addEvent();
		}

		//��ʼ����
		private function addEvent():void {
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressFun);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeFun);
		}

		//��������
		private function delEvent():void {
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressFun);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeFun);
		}

		//���سɹ��������ɹ��¼�
		private function completeFun(e:Event):void {
			delEvent();
			dispatchEvent(e);
		}

		//���ع���
		private function progressFun(e:ProgressEvent):void {
			dispatchEvent(e);
		}

		//��ȡ����
		public function getClass(className:String):Class {
			return Class(loader.contentLoaderInfo.applicationDomain.getDefinition(className));
		}

		//�Ƿ��иö���
		public function hasClass(className:String):Boolean {
			return loader.contentLoaderInfo.applicationDomain.hasDefinition(className);
		}

		//���
		public function clear():void {
			loader.unload();
			loader = null;
		}
	}
}