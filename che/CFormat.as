package che {
	public class CFormat {
		/**
		 * @param	s只接受形如"2012/08/15 15:8:08:12","2012/08/15"的字符串,月份1表示1月
		 */
		public static function getDate(s:String):Date {
			var date:Date = new Date;
			var a:Array = s.split(" ");
			var dateArray:Array = a[0].split("/");
			date.setFullYear( parseInt(dateArray.shift()));
			date.setMonth( parseInt(dateArray.shift()) - 1);
			date.setDate( parseInt(dateArray.shift()));
			
			if (!a[1])	return date;
			var timeArray:Array = a[1].split(":");
			date.setHours(
				parseInt(timeArray[0]),
				timeArray[1]?parseInt(timeArray[1]):0,
				timeArray[2]?parseInt(timeArray[2]):0,
				timeArray[3]?parseInt(timeArray[3]):0
			);
			return date;
		}
	} //class
}
////////////////////////////////////////////////////////////////////////////////////////////////////////包外类

//////////////////////////////////////////////////////////////////////////////////////////////////////////