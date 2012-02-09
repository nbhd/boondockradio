package net.boondockradio.as3.command
{
	public interface ICommand
	{
		function set delegate(value:ICommandDelegate):void;
		function execute():void;
	}
}