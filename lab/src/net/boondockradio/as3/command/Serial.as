package net.boondockradio.as3.command
{
	/**
	 * 1個ずつ実行する
	 * @author oki_nobuhide
	 */	
	public class Serial implements ICommandDelegate
	{
		//*********************************************************
		// VARIABLES
		//*********************************************************
		private var _commands:Array = [];
		private var _id:uint;
		private var _complete:Info;
		
		
		//*********************************************************
		// PUBLIC METHODS
		//*********************************************************
		/**
		 * constructor 
		 */		
		public function Serial()
		{
		}
		
		/**
		 * command 登録 
		 * @param command
		 * @return 
		 */		
		public function addCommand(command:ICommand):Serial
		{
			command.delegate = this;
			_commands.push(command);
			return this;
		}
		
		/**
		 * complete handler 設定 
		 * @param callback
		 * @param args
		 * @return 
		 */		
		public function onComplete(callback:Function, ...args):Serial
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
			
			var queue:ICommand = _commands.shift();
			queue.execute();
		}
		
		/**
		 * queue の complete 通知用 delegate method
		 */		
		public function complete():void
		{
			execute();
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