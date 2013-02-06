package com.bradsbytes.tmx
{
	import flash.display.BitmapData;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;

	/**
	 * Interface for TMX file loaders.
	 * 
	 * <p>The TMXBaseLoader class can be used to implement most of this interface,
	 * but some methods must be implemented manually. Most notably, the
	 * loadBitmapData() method must be implemented by a subclass in order to be
	 * able to </p>
	 */
	public interface TMXLoader extends IEventDispatcher
	{
		function loadBytes(bytes : ByteArray) : void;
		function loadBitmapData(src :  String) : BitmapData;
	}
}