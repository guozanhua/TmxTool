package com.bradsbytes.tmx
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	use namespace flash_proxy;
	
	/**
	 * Provides controlled access to the layers of a TMX object.
	 * <p>Not intended to be instantiated except by the TMX class in its construction.</p>
	 * <p>This can basically be treated like an Array. It supports indexing and both
	 * for .. in and for each .. in loops, and it has the usual methods and properties of
	 * an array such as length, push(), etc.</p>
	 * <p>The TMXLayersView gives a link back to its parent TMX as the tmx property, which
	 * is read-only. Think of the view as an extension of the TMX itself which deals
	 * specifically with layers.</p>
	 */
	public class TMXLayersView extends Proxy
	{
		
		protected var _tmx : TMX = null;
		protected var _layers : Vector.<AbstractTMXLayer>;
		
		public function TMXLayersView()
		{
			_layers = new Vector.<AbstractTMXLayer>;
		}
		
		/**
		 * The TMX to which this layers view belongs.
		 */
		public function get tmx() :  TMX {
			return _tmx;
		}
		
		internal function setTmx(tmx_ : TMX) : void {
			_tmx = tmx_;
		}
		
		/**
		 * Return the first object among all object groups with the given name,
		 * or null if there is no object with the given name.
		 */
		public function getByName(oname : String) : TMXObject {
			for each (var layer : AbstractTMXLayer in _layers) {
				if (layer is TMXObjectGroup) {
					for each (var obj : TMXObject in layer as TMXObjectGroup) {
						if (obj.name == oname)
							return obj;
					}
				}
			}
			return null;
		}
		
		/**
		 * The total number of layers.
		 */
		public function get length() : uint {
			return _layers.length;
		}
		
		/**
		 * Add a new layer. The layer must not already be inside another TMX. The layer's tmx will become the current TMX object.
		 */
		public function push(layer : AbstractTMXLayer) : void {
			if (layer.tmx === null) {
				_layers.push(layer);
				layer.setTmx(this.tmx);
			}
			else {
				throw new ArgumentError("layer is already in another TMX."); 
			}
		}
		
		override flash_proxy function nextNameIndex(index:int):int {
			if (index > _layers.length)
				return 0;
			return index + 1;
		}
		
		override flash_proxy function nextName(index:int):String {
			return String(index - 1);
		}
		
		override flash_proxy function nextValue(index:int):* {
			return _layers[index - 1];
		}
	}
}