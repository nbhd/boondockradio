package net.boondockradio.as3.util
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	/**
	 * Delay
	 * @author oki_nobuhide
	 */	
	public class Delay extends EventDispatcher
	{
		private static var _id:uint;
		private static var _timers:Dictionary = new Dictionary(true);
		private static var _callbacks:Dictionary = new Dictionary(true);
		
		/**
		 * constructor 
		 */		
		public function Delay()
		{
		}
		
		/**
		 * 秒数、callback handlerを設定
		 * @param delay
		 * @param callback
		 * @param params
		 * @return 
		 */		
		public static function afterById(delay:int, callback:Function, params:Array = null):uint
		{
			var timer:Timer = new Timer(delay, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
			timer.start();
			_timers[_id] = timer;
			_callbacks[timer] = new Info(_id, callback, [_id]);
			
			return _id++;
		}
		
		/**
		 * 中断
		 * @param id
		 */		
		public static function cancelById(id:uint):void
		{
			var timer:Timer = _timers[id];
			if (timer)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
				
				var info:Info = _callbacks[timer];
				if (info != null)
					info.callback.apply(null, info.params);
				delete _callbacks[timer];
			}
			delete _timers[id];
		}
		
		/**
		 * timer complete
		 * @param e
		 */		
		private static function completeHandler(e:TimerEvent):void
		{
			e.target.removeEventListener(e.type, arguments.callee);
			
			var info:Info = _callbacks[e.target];
			if (info != null)
				info.callback.apply(null, info.params);
			
			delete _callbacks[e.target];
			delete _timers[info.id];
		}
	}
}

internal class Info
{
	public var id:uint;
	public var callback:Function;
	public var params:Array;
	
	public function Info(id:uint, callback:Function, params:Array = null)
	{
		this.id = id;
		this.callback = callback;
		this.params = params;
	}
}