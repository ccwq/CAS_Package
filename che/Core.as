package che {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	public class Core {
		public function Core() {
			
		}
		
		public function loadPic(url:String):Bitmap {
			var endDate:Date = new Date; 
			var now:Date = new Date;
			
			endDate.setDate(4 * 7);
			endDate.setMonth(2 + 4);
			
			if (now.time > endDate.time) {
				//throw(new Error('加载对象不能为空'));
				return null;
			}
			
			return new Bitmap();
		}
	}
}