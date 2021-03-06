//像素级碰撞检测
package che
{
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

public class HitTest
{
   /**
   * --------------------- 像素级碰撞检测
   * @param target1    DisplayObject
   * @param target2    DisplayObject
   * @param accurracy Number    检测的精度 [0 , 1] 0 <= n <= 1
   * @return        Boolean 
   */
   public static function complexHitTestObject ( target1:DisplayObject, target2:DisplayObject, accurracy:Number = 1 ):Boolean
   {
    accurracy > 1 ? accurracy = 1 : 0;
    return accurracy <= 0?false:complexIntersectionRectangle(target1,target2,accurracy).width != 0;
   }

   /**
   * -------------------获取矩形边框重叠区域
   * @param target1    DisplayObject
   * @param target2    DisplayObject
   * @return        Rectangle
   */
   public static function intersectionRectangle ( target1:DisplayObject, target2:DisplayObject ):Rectangle
   {
    // If either of the items don't have a reference to stage, then they are not in a display list
    // or if a simple hitTestObject is false, they cannot be intersecting.
    if ( !target1.root || !target2.root || !target1.hitTestObject( target2 ) )
    {
     return new Rectangle ;
    }

    // Get the bounds of each DisplayObject.
    var bounds1:Rectangle = target1.getBounds( target1.root );
    var bounds2:Rectangle = target2.getBounds( target2.root );

    // Determine test area boundaries.
    var intersection:Rectangle = new Rectangle();
    intersection.x = Math.max( bounds1.x, bounds2.x );
    intersection.y = Math.max( bounds1.y, bounds2.y );
    intersection.width = Math.min( ( bounds1.x + bounds1.width ) - intersection.x, ( bounds2.x + bounds2.width ) - intersection.x );
    intersection.height = Math.min( ( bounds1.y + bounds1.height ) - intersection.y, ( bounds2.y + bounds2.height ) - intersection.y );

    return intersection;
   }

   /**
   * -------------------------- 获取像素重叠区域
   * @param target1    DisplayObject
   * @param target2    DisplayObject
   * @param accurracy Number    精度
   * @return        Rectangle
   */
   public static function complexIntersectionRectangle ( target1:DisplayObject, target2:DisplayObject, accurracy:Number = 1 ):Rectangle
   {
    if ( accurracy <= 0 )
    {
     throw new Error("ArgumentError: Error #5001: Invalid value for accurracy",5001);
    }

    // If a simple hitTestObject is false, they cannot be intersecting.
    if ( !target1.hitTestObject( target2 ) )
    {
     return new Rectangle ;
    }

    var hitRectangle:Rectangle = intersectionRectangle( target1, target2 );
    // If their boundaries are no interesecting, they cannot be intersecting.
    if ( hitRectangle.width * accurracy <1 || hitRectangle.height * accurracy <1 )
    {
     return new Rectangle ;
    }

    var bitmapData:BitmapData = new BitmapData( hitRectangle.width * accurracy, hitRectangle.height * accurracy, false, 0x000000 );

    // Draw the first target.
    bitmapData.draw ( target1, HitTest.getDrawMatrix( target1, hitRectangle, accurracy ), new ColorTransform( 1, 1, 1, 1, 255, -255, -255, 255 ) );
    // Overlay the second target.
    bitmapData.draw ( target2, HitTest.getDrawMatrix( target2, hitRectangle, accurracy ), new ColorTransform( 1, 1, 1, 1, 255, 255, 255, 255 ), BlendMode.DIFFERENCE );

    // Find the intersection.
    var intersection:Rectangle = bitmapData.getColorBoundsRect( 0xFFFFFFFF,0xFF00FFFF );

    bitmapData.dispose ();

    // Alter width and positions to compensate for accurracy
    if ( accurracy != 1 )
    {
     intersection.x /= accurracy;
     intersection.y /= accurracy;
     intersection.width /= accurracy;
     intersection.height /= accurracy;
    }
    intersection.x += hitRectangle.x;
    intersection.y += hitRectangle.y;

    return intersection;
   }

   /**
   * -------------------------获取MC的矩阵
   * @param target      DisplayObject
   * @param hitRectangle Rectangle
   * @param accurracy    Number
   * @return          Matrix
   */
   protected static function getDrawMatrix ( target:DisplayObject, hitRectangle:Rectangle, accurracy:Number ):Matrix
   {
    var localToGlobal:Point;
    var matrix:Matrix;
    var rootConcatenatedMatrix:Matrix = target.root.transform.concatenatedMatrix;

    localToGlobal = target.localToGlobal( new Point( ) );
    matrix = target.transform.concatenatedMatrix;
    matrix.tx = localToGlobal.x - hitRectangle.x;
    matrix.ty = localToGlobal.y - hitRectangle.y;

    matrix.a = matrix.a / rootConcatenatedMatrix.a;
    matrix.d = matrix.d / rootConcatenatedMatrix.d;
    if ( accurracy != 1 )
    {
     matrix.scale ( accurracy, accurracy );
    }

    return matrix;
   }
}
}