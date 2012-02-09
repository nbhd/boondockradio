package net.boondockradio.as3.command
{
	import net.boondockradio.as3.util.Delay;

	public class TestCommand implements ICommand
	{
		private var _delegate:ICommandDelegate;
		public function set delegate(value:ICommandDelegate):void
		{
			_delegate = value;
		}
		
		public function TestCommand()
		{
		}
		
		public function execute():void
		{
			Delay.afterById(1000, complete, ['foo']);
		}
		
		private function complete(str:String = null):void
		{
			trace(str);
			_delegate.complete();
			_delegate = null;
		}
	}
}