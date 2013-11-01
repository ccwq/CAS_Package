package che{
	import org.papervision3d.materials.BitmapFileMaterial;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.*;
	import flash.system.LoaderContext;
	
	import org.papervision3d.core.log.PaperLogger;
	public class BitmapFileMaterialCrossDomain extends BitmapFileMaterial {
		public function BitmapFileMaterialCrossDomain(f:String="", precise:Boolean=false) {
			super(f,precise);
		}
		override protected function loadNextBitmap():void {
			// Retrieve next filename in queue
			var file:String=_waitingBitmaps[0];

			var request:URLRequest=new URLRequest(file);
			bitmapLoader = new Loader();

			bitmapLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, loadBitmapProgressHandler );
			bitmapLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadBitmapCompleteHandler );
			bitmapLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, loadBitmapErrorHandler );

			try {
				// Load bitmap
				var loaderContext:LoaderContext=new LoaderContext(true);
				//loaderContext.checkPolicyFile=true;

				bitmapLoader.load( request, loaderContext);

				// Save original url
				_loaderUrls[bitmapLoader]=file;

				// Busy loading
				_loadingIdle=false;

				PaperLogger.info( "BitmapFileMaterial: Loading bitmap from " + file );
			} catch (error:Error) {
				// Remove from queue
				_waitingBitmaps.shift();

				// Loading finished
				_loadingIdle=true;

				PaperLogger.info( "[ERROR] BitmapFileMaterial: Unable to load file " + error.message );
			}
		}
	}
}