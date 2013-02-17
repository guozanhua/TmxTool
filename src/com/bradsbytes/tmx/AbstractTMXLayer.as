package com.bradsbytes.tmx
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
//	import mx.events.PropertyChangeEvent;
//	import mx.utils.ObjectProxy;

	/**
	 * Implements the common parts of TMXTileLayer and TMXObjectGroup.
	 * <p>
	 * 	This class extends the Flash built-in Proxy class so that subclasses may be
	 *  used in for each .. in loops and such. (TMXObjectGroup does this, for example.)
	 * </p>
	 */
	public class AbstractTMXLayer extends Proxy
	{
		protected var _name : String;
		protected var _width : uint;
		protected var _height : uint;
		protected var _properties : Object;
		protected var _tmx : TMX = null;
		
		public function AbstractTMXLayer(name_ : String, width_ : uint, height_ : uint)
		{
			_name = name_;
			_width = width_;
			_height = height_;
			_properties = new Object;
//			_properties.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, handlePropertyChanged);
		}
		
		/**
		 * The TMX containing this layer.
		 */
		public function get tmx() : TMX {
			return _tmx;
		}
		
		/**
		 * @private
		 */
		internal function setTmx(tmx_:TMX):void {
			_tmx = tmx_;
		}
		
		/**
		 * The name of this layer. Should be unique among all layers in the TMX, but this is not enforced programatically.
		 */
		public function get name() : String {
			return _name;
		}
		
		/**
		 * @private
		 */
		public function set name(name_ : String) : void {
			_name = name_;
		}
		
		/**
		 * Width of the layer in tiles.
		 */
		public function get width() : uint {
			return _width;
		}
		
		/**
		 * Height of the layer in tiles.
		 */
		public function get height() : uint {
			return _height;
		}
		
		/**
		 * A proxy to the layer's properties.
		 * <p>
		 * 	Changes to this proxy will trigger calls to the protected method handlePropertyChanged().
		 * </p>
		 */
		public function get properties() : Object {
			return _properties;
		}
//		
//		/**
//		 * Handles changes to the layer's properties.
//		 * <p>
//		 * 	This does nothing by default, but subclasses may want to use it.
//		 * </p>
//		 */
//		public function handlePropertyChanged(e:PropertyChangeEvent) : void {
//			// Leave it to the subclasses!
//		}
	}
}