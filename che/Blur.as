package che{
	public class Blur {
		public var sprite;
		private var _mh:Number;
		private var _mhx:Number;
		private var _mhy:Number;
		public var qu:uint=3;
		public function Blur(s,ql:uint=3) {
			sprite=s;
			qu=ql;
		}
		
		////////////////
		public function set mh(v:Number) {
			_mh=v;
			tool.blurYou(sprite,_mh,qu);
		}
		public function get mh():Number {
			return _mh;
		}
		
		////////////////////
		public function set mhx(v:Number) {
			_mhx=v;
			tool.blurYou(sprite,_mhx,qu,true,0);
		}
		public function get mhx():Number {
			return _mhx;
		}
		
		////////////////////////
		public function set mhy(v:Number) {
			_mhy=v;
			tool.blurYou(sprite,0,qu,true,_mhy);
		}
		public function get mhy():Number {
			return _mhy;
		}
		
		public function mhxy(xx:Number=0,yy:Number=0){
			_mhx=xx;
			_mhy=yy;
			tool.blurYou(sprite,_mhx,qu,false,_mhy);
			}
	}//class

}