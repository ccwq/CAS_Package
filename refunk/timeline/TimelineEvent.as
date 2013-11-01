﻿/** 
    Copyright (c) 2009 Refunk <http://www.refunk.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

package refunk.timeline {
	
	import flash.events.Event;
	
	public class TimelineEvent extends Event {
		
		public static const LABEL_REACHED:String = "labelReached";//当到达某一个关键帧并且这个关键帧是有名字的，发送事件
		public static const END_REACHED:String = "endReached";//到达结尾，发送事件
		
		private var _currentFrame:int;
		private var _currentLabel:String;
		
		/*
		 * The TimelineEvent class provides a custom Event for the com.refunk.timeline.TimelineWatcher class
		 *
		 * It provides two String constants named LABEL_REACHED and END_REACHED,
		 * and can hold a timeline's current frame and label to be passed by the event object
		 */
		
		public function TimelineEvent(type:String, currentFrame:int = 0, currentLabel:String = null) {
			super(type);
			_currentFrame = currentFrame;
			_currentLabel = currentLabel;
		}
		
		public override function clone():Event {
			return new TimelineEvent(type, _currentFrame, _currentLabel);
		}
		
		public override function toString():String {
			return formatToString("TimelineEvent", "type", "bubbles", "cancelable", "eventPhase", "currentFrame", "currentLabel");
		}
		
		/*
		 * Getter function 
		 *
		 * @return 	The current frame (int)
		 */
		public function get currentFrame():int {
			return _currentFrame;
		}
		
		/*
		 * Getter function 
		 *
		 * @return 	The current label (String)
		 */
		public function get currentLabel():String {
			return _currentLabel;
		}
	
	}
}