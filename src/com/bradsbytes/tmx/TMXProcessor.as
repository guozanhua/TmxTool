package com.bradsbytes.tmx
{
	/**
	 * A helper class that may be used for processing the TMX objects that were loaded by a TMXLoader.
	 * <p>
	 * To use:
	 * </p>
	 * <ol>
	 *  <li>Set the <code>onLayerCell</code> and <code>onObject</code> callbacks to appropriate functions.</li>
	 *  <li>Call the <code>process()</code> method.</li>
	 *  <li>Layer cells and objects are processed in the order that they appear within the TMX layers.</p></li>
	 * </ul>
	 * @author Brad Harms
	 * @see onLayerCell
	 * @see onObject
	 * @see process
	 */
	public class TMXProcessor 
	{
		/**
		 * Called once for each tile of each layer.
		 * <p>Expects a function of the form:</p>
		 * <p><code>function handleLayerCell( col : uint, row : uint, tile : TMXTile, layer : TMXLayer ) : void</code>
		 */
		public var onLayerCell : Function = null;
		
		/**
		 * Called once for each object.
		 * <p>Expects a function of the form:</p>
		 * <p><code>function handleObject(obj : TMXObject)</p>
		 */
		public var onObject : Function = null;
		
		public function TMXProcessor(onLayerCell_ : Function = null, onObject_ : Function = null) 
		{
			
		}
		
		/**
		 * This will process a TMX by iterating over every cell of every layer and every object of every object group and calling the appropriate callback.
		 * @param	tmx
		 */
		public function process(tmx:TMX) : void {
			for each (var layer : AbstractTMXLayer in tmx.layers) {
				if (layer is TMXTileLayer) {
					var tileLayer : TMXTileLayer = layer as TMXTileLayer;
					for (var row : uint = 0; row < layer.height; row++) {
						for (var col : uint = 0; col < layer.width; col++) {
							onLayerCell(col, row, tileLayer.getTile(col, row), tileLayer);
						}
					}
				}
				else if (layer is TMXObjectGroup) {
					var group : TMXObjectGroup = layer as TMXObjectGroup;
					for each (var obj : TMXObject in group) {
						onObject(obj);
					}
				}
			}
		}
		
	}

}