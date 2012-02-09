package net.boondockradio.as3.command
{
	/**
	 * 同時に実行
	 * @author oki_nobuhide
	 */	
	public class ParallelCommand implements ICommandDelegate
	{
		//*********************************************************
		// VARIABLES
		//*********************************************************
		private var _commands:Array = [];
		private var _complete:Info;
		private var _count:uint;
		
		
		//*********************************************************
		// PUBLIC METHODS
		//*********************************************************
		/**
		 * constructor 
		 */
		public function ParallelCommand()
		{
		}
		
		/**
		 * command 登録 
		 * @param command
		 * @return 
		 */	
		public function addCommand(command:ICommand):ParallelCommand
		{
			_commands.push(command);
			return this;
		}
		
		/**
		 * complete handler 設定 
		 * @param callback
		 * @param args
		 * @return 
		 */	
		public function onComplete(callback:Function, ...args):ParallelCommand
		{
			_complete = new Info(callback, args);
			return this;
		}
		
		/**
		 * 実行 
		 */
		public function execute():void
		{
			if (_commands.length == 0)
			{
				finish();
				return;
			}
			
			var i:int;
			var len:int = _commands.length;
			var queue:ICommand;
			for (i = 0; i < len; i++) 
			{
				queue = _commands[i];
				queue.delegate = this;
				queue.execute();
			}
		}
		
		/**
		 * queue の complete 通知用 delegate method
		 */
		public function complete():void
		{
			_count++;
			
			if (_commands.length == _count)
				finish();
		}
		
		
		//*********************************************************
		// PRIVATE METHODS
		//*********************************************************
		/**
		 * 完了通知 
		 */	
		private function finish():void
		{
			if (_complete == null) return;
			
			_complete.callback.apply(null, _complete.args);
			_commands = [];
		}
	}
}

class Info
{
	public var callback:Function;
	public var args:Array;
	
	public function Info(callback:Function, args:Array = null)
	{
		this.callback = callback;
		this.args = args
	}
}