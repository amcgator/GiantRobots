package org.flixel 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
   
	public class FlxCamera
	{
			private const NOTHING:Number = 0;
			private const SIMPLE:Number = 1;
			private const TRAILSPRITE:Number = 2;
			private const TRAILPOINT:Number = 3;
		   
			public var mode:Number;
		   
			public var cameraTarget:FlxSprite = null;
		   
			// Default stuff
			private var _defaultOffsetX:Number;
			private var _defaultOffsetY:Number;
		   
			// General camera stuff
			public var cameraOffsetX:Number;
			public var cameraOffsetY:Number;
		   
			// Camera boundaries
			public var cameraMinX:Number;
			public var cameraMinY:Number;
			public var cameraMaxX:Number;
			public var cameraMaxY:Number;
		   
			// Trailing stuff
			public var trailX:Number;
			public var trailY:Number;
			public var trailSpeedX:Number;
			public var trailSpeedY:Number;
			public var trailMatchCallback:Function;
		   
			public var trailTargetPointX:Number;
			public var trailTargetPointY:Number;
		   
			public function FlxCamera()
			{
					_defaultOffsetX = FlxG.width / 2;
					_defaultOffsetY = FlxG.height / 2;
				   
					mode = NOTHING;
			}
		   
			public function adjustBounds(MinX:Number, MinY:Number, MaxX:Number, MaxY:Number):void
			{
					cameraMinX = MinX;
					cameraMinY = MinY;
					cameraMaxX = MaxX;
					cameraMaxY = MaxY;
			}
		   
			public function simpleFollowSprite(Target:FlxSprite, OffsetX:Number = -1, OffsetY:Number = -1):void
			{
					mode = SIMPLE;
				   
					cameraTarget = Target;
					if (OffsetX == -1)
							cameraOffsetX = _defaultOffsetX;
					else
							cameraOffsetX = OffsetX;
					if (OffsetY == -1)
							cameraOffsetY = _defaultOffsetY;
					else
							cameraOffsetY = OffsetY;
			}
		   
			public function trailFollowSprite(Target:FlxSprite, TrailSpeedX:Number, TrailSpeedY:Number, OffsetX:Number = -1, OffsetY:Number = -1, MatchCallback:Function = null):void
			{
					mode = TRAILSPRITE;
				   
					cameraTarget = Target;
					if (OffsetX == -1)
							cameraOffsetX = _defaultOffsetX;
					else
							cameraOffsetX = OffsetX;
					if (OffsetY == -1)
							cameraOffsetY = _defaultOffsetY;
					else
							cameraOffsetY = OffsetY;
				   
					trailX = x;
					trailY = y;
					trailSpeedX = TrailSpeedX;
					trailSpeedY = TrailSpeedY;
				   
					trailMatchCallback = MatchCallback;
			}
		   
			public function trailFollowPoint(StartX:Number, StartY:Number, TargetX:Number, TargetY:Number, TrailSpeedX:Number, TrailSpeedY:Number, OffsetX:Number = -1, OffsetY:Number = -1, MatchCallback:Function = null):void
			{
					mode = TRAILPOINT;
				   
					if (OffsetX == -1)
							cameraOffsetX = _defaultOffsetX;
					else
							cameraOffsetX = OffsetX;
					if (OffsetY == -1)
							cameraOffsetY = _defaultOffsetY;
					else
							cameraOffsetY = OffsetY;
				   
					trailX = StartX;
					trailY = StartY;
					trailTargetPointX = TargetX;
					trailTargetPointY = TargetY;
					trailSpeedX = TrailSpeedX;
					trailSpeedY = TrailSpeedY;
				   
					trailMatchCallback = MatchCallback;
			}              
		   
			public function update():void
			{
					if (cameraTarget != null)
					{
							var tx:Number = cameraTarget.x - cameraTarget.offset.x + cameraTarget.frameWidth / 2 - cameraOffsetX;
							var ty:Number = cameraTarget.y - cameraTarget.offset.y + cameraTarget.frameHeight / 2 - cameraOffsetY;
					}
				   
					switch(mode)
					{
							case SIMPLE:
									if (cameraTarget != null) lookAt(tx, ty);
									break;
							case TRAILSPRITE:
									if (cameraTarget != null) trailUpdate(tx, ty);
									break;
							case TRAILPOINT:
									trailUpdate(trailTargetPointX, trailTargetPointY);
									break;
					}
			}
		   
			public function lookAt(X:Number, Y:Number):void
			{
					FlxG.scroll.x = -X;
					FlxG.scroll.y = -Y;
					if ( -FlxG.scroll.x < cameraMinX)
							FlxG.scroll.x = -cameraMinX;
					if ( -FlxG.scroll.x + FlxG.width > cameraMaxX)
							FlxG.scroll.x = -(cameraMaxX - FlxG.width);
					if ( -FlxG.scroll.y < cameraMinY)
							FlxG.scroll.y = -cameraMinY;
					if ( -FlxG.scroll.y + FlxG.height > cameraMaxY)
							FlxG.scroll.y = -(cameraMaxY - FlxG.height);
			}
		   
			private function trailUpdate(TargetX:Number, TargetY:Number):void
			{
					if (trailX < TargetX)
					{
							trailX += FlxG.elapsed * trailSpeedX;
							if (trailX > TargetX) trailX = TargetX;
					}
					if (trailX > TargetX)
					{
							trailX -= FlxG.elapsed * trailSpeedX;
							if (trailX < TargetX) trailX = TargetX;
					}
					if (trailY < TargetY)
					{
							trailY += FlxG.elapsed * trailSpeedY;
							if (trailY > TargetY) trailY = TargetY;
					}
					if (trailY > TargetY)
					{
							trailY -= FlxG.elapsed * trailSpeedY;
							if (trailY < TargetY) trailY = TargetY;
					}
				   
					if (trailX == TargetX && trailY == TargetY && trailMatchCallback != null)
					{
							trailMatchCallback();
					}
				   
					lookAt(trailX, trailY);
			}
		   
			public function stop():void
			{
					mode = NOTHING;
			}
		   
			public function get x():Number
			{
					return -FlxG.scroll.x;
			}
		   
			public function get y():Number
			{
					return -FlxG.scroll.y;
			}
	}

}