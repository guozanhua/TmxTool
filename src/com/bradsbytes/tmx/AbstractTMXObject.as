package com.bradsbytes.tmx
{
	import mx.events.PropertyChangeEvent;
	import mx.utils.ObjectProxy;

	public class AbstractTMXObject
	{
		private var _properties : ObjectProxy;
		
		public function AbstractTMXObject()
		{
			_properties = new ObjectProxy;
		}
		
		/**
		 * A proxy to the properties for this TMXObject.
		 * <p>
		 * 	Changes to this proxy will trigger the TMXObject's handlePropertyChanged() method/
		 * </p>
		 */
		public function get properties() : ObjectProxy {
			return _properties;
		}
		
		/**
		 * Fires whenever a change is made to one of the properties.
		 * <p>
		 * 	By default, this does nothing, but may be overridden for new behavior.
		 * </p>
		 */
		public function handlePropertyChanged(e:PropertyChangeEvent) : void {
			
		}
	}
}