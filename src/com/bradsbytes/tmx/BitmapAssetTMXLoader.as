package com.bradsbytes.tmx
{
	import flash.display.BitmapData;
	
	import mx.core.BitmapAsset;
	
	/**
	 * A loader that uses BitmapAsset classes for the image references contained in a TMX.
	 * <p>
	 * 	Before loading the TMX, you must first associate each of the image URL strings
	 *  contained within your target .tmx file(s) with BitmapAsset classes. This is done
	 *  by assigning an object to the imageAssets property, where the keys are the
	 *  image URL strings as they appear in the .tmx files and the values are BitmapAsset
	 *  classs.  
	 * </p>
	 * 
	 * @see addImageAsset
	 */
	public class BitmapAssetTMXLoader extends AbstractTMXLoader implements TMXLoader
	{
		protected var _imageAssets : Object;
		
		public function BitmapAssetTMXLoader()
		{
			super();
		}
		
		public function loadBitmapData(src:String):BitmapData
		{
			return (new (_imageAssets[src] as Class) as BitmapAsset).bitmapData;
		}
		
		public function get imageAssets () : Object {
			return _imageAssets;
		}
		
		public function set imageAssets (obj:Object) : void {
			_imageAssets = obj;
		}
	}
}