package che{//http://zmfkplj.javaeye.com/blog/599356
  
  public final class Random{
    
    public function Random(){
      throw new Error("����������߰��޷�ʵ������");
    }
    
    //��ȡһ������Ĳ���ֵ
    public static function get boolean():Boolean{
      return Math.random() < 0.5;
    }
    
    //��ȡһ����������ֵ
    public static function get wave():int{
      return boolean ? 1 : -1;
    }
    
    //��ȡһ������ķ�Χ����ֵ
    public static function integer(num:Number):int{
      return Math.floor(number(num));
    }
    
    //��ȡһ������ķ�ΧNumberֵ
    public static function number(num:Number):Number{
      return Math.random() * num;
    }
    
    //��һ����Χ�ڻ�ȡһ�����ֵ�����ؽ����Χ��num1 >= num > num2
    public static function range(num1:Number,num2:Number,isInt:Boolean = true):Number{
      var num:Number = number(num2 - num1) + num1;
      if(isInt) num = Math.floor(num);
      return num;
    }
    
    //�ڶ����Χ��ȡ���ֵ
    public static function ranges(...args):Number{
      var isInt:Boolean = args[args.length - 1] is Boolean ? args.pop() : true;
      var num:Number = randomRange(args);
      if(!isInt) num += Math.random();
      return num;
    }
    
    //��ȡһ������ַ���Ĭ�������ΧΪ����+��Сд��ĸ��Ҳ����ָ����Χ����ʽ��a-z,A-H,5-9
    public static function string(str:String = "0-9,A-Z,a-z"):String{
      return String.fromCharCode(randomRange(explain(str)));
    }
    
    //����ָ��λ��������ַ���
    public static function bit(num:int,str:String = "0-9,A-Z,a-z"):String{
      var reStr:String = "";
      for(var i:int = 0; i < num; i ++) reStr += string(str);
      return reStr;
    }
	
	//����ָ��λ��������ַ���
	public static function ranString(num:int, str:String = "0-9,A-Z,a-z"):String {
		return bit(num,str);
	}
    
    //��ȡһ���������ɫֵ
    public static function color(red:String = "0-255",green:String = "0-255",blue:String = "0-255"):uint{
      return Number("0x" + transform(randomRange(explain(red,false))) +
                 transform(randomRange(explain(green,false))) +
                 transform(randomRange(explain(blue,false))));
    }
    
    //��10���Ƶ�RGBɫת��Ϊ2λ��16����
    private static function transform(num:uint):String{
      var reStr:String = num.toString(16);
      if(reStr.length != 2) reStr = "0" + reStr;
      return reStr;
    }
    
    //�ַ�������
    private static function explain(str:String,isCodeAt:Boolean = true):Array{
      var argAr:Array = new Array;
      var tmpAr:Array = str.split(",");
      for(var i:int = 0; i < tmpAr.length; i ++){
        var ar:Array = tmpAr[i].split("-");
        if(ar.length == 2){
          var arPush0:String = ar[0];
          var arPush1:String = ar[1];
          if(isCodeAt){
            arPush0 = arPush0.charCodeAt().toString();
            arPush1 = arPush1.charCodeAt().toString();
          }
          //�˴��������1�����������ar[1]����ʾ�ַ��������Ҫ����1�������Χ���ǶԵ�
          argAr.push(Number(arPush0),Number(arPush1) + 1);
        }else if(ar.length == 1){
          var arPush:String = ar[0];
          if(isCodeAt) arPush = arPush.charCodeAt().toString();
          //�����Χ��1-2����ô��������ض���1������ó���һ�������󣬰ѷ�Χ���ڲ���+1��������øò����μ����
          argAr.push(Number(arPush),Number(arPush) + 1);
        }
        ar = null;
      }
      tmpAr = null;
      return argAr;
    }
    
    //��ȡ�����Χ
    private static function randomRange(ar:Array):Number{
      var tmpAr:Array = new Array;
      var length:int = ar.length;
      if(length % 2 != 0 || length == 0) throw new Error("���������޷���ȡָ����Χ��");
      //�����п��ܳ��ֵ�������������飬Ȼ��������
      for(var i:int = 0; i < length / 2; i ++){
        var i1:int = ar[i * 2];
        var i2:int = ar[i * 2 + 1];
        if(i1 > i2){
          var tmp:Number = i1;
          i1 = i2;
          i2 = tmp;
        }
        for(i1; i1 < i2; i1 ++) tmpAr.push(i1);
      }
      var num:Number = tmpAr[integer(tmpAr.length)];
      tmpAr = null;
      ar = null;
      return num;
    }
    
  }
  
}