package com.bradsbytes.tmx
{
	import com.zlibfromscratch.ZlibDecoder;
	import com.zlibfromscratch.ZlibDecoderError;
	import com.zlibfromscratch.ZlibUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.utils.Base64Decoder;

	/**
	 * Base class used to implement TMX loaders.
	 *
	 * <p>This class can not be instantiated and must be subclased to be used. It
	 * implements most of the TMXLoader interface, but subclasses must implement the
	 * rest.</p>
	 * 
	 * <p>The specific methods and properties that subclasses must implement are as follows:</p>
	 * <ul>
	 * 	<li><code>loadBitmapData(src : String) : BitmapData</code></ul>
	 * </ul>
	 * 
	 * @author Brad Harms
	 * 
	 * @see TMXLoader
	 * @see loadXML
	 */
	[Event(name="complete", type="flash.events.Event")]
	public class AbstractTMXLoader extends EventDispatcher
	{
		/**
		 * The internal variable that actually holds the TMX once its loaded.
		 */
		protected var tmxObject : TMX = null;
		
		public function AbstractTMXLoader () {
			if (!(this is TMXLoader))
				throw new TypeError("The AbstractTMXLoader class cannot be instantiated directly and must be subclassed by a class that implements the TMXLoader interface.");
		}
		
		/**
		 * The last loaded TMX.
		 * <p>This will be null before the TMX has been completely loaded. Use the <code>complete</code> event to determine when the TMX is ready to be used.</p> 
		 */
		public function get tmx():TMX {
			return tmxObject;
		}
		
		/**
		 * @private
		 */
		public function set tmx(tmx_:TMX):void {
			tmxObject = tmx_;
		}
		
		/**
		 * Load a TMX from a byte array containing a .tmx file.
		 * <p>This will create a new XML object and call loadXML on it, which will
		 * then dispatch the <code>complete</code> event.</p>
		 */
		public function loadBytes(bytes:ByteArray) : void {
			var str : String = bytes.readUTFBytes(bytes.length);
			var xml : XML = new XML(str);
			loadXML(xml);
		}
		
		/**
		 * Create a new TMX from an XML object.
		 * 
		 * <p>When the process is completed, the <code>Event.COMPLETE</code> event will be triggered.</p>
		 * 
		 * @param	xml
		 * @return
		 */
		public function loadXML(xml:XML) : void {
			var row : uint;
			var col : uint;
			var i : uint;
			var j : uint;
			var cols : uint;
			var rows : uint;
			
			// Create new empty map
			tmx = createTMX(xml);
			
			// Create and store the tilesets
			for each (var tilesetXML : XML in xml.tileset) {
				var tmxTileset : TMXTileset = createTileset(tilesetXML, xml);
				tmx.tilesets.push(tmxTileset);
			}
			
			// Get the layers
			for each (var layerXML : XML in xml.children()) {
				var tmxLayer : AbstractTMXLayer = null;
				var tagname : String = String(layerXML.localName());
				switch (tagname) {
					
					// Tile layers
					case "layer":
						tmxLayer = createTileLayer(layerXML, xml);
					break;
					
					// Object groups
					case "objectgroup":
						tmxLayer = createObjectGroup(layerXML, xml);
					break;
				}
				// Add the layer
				if (tmxLayer !== null)
					tmx.layers.push(tmxLayer);
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * Used by loadXML() to create the root TMX object.
		 * <p>
		 * 	This does not actually populate the TMX with its contained tilesets, layers, or object groups.
		 *  It only initializes it with basic values like width, height, tileWidth, and properties.
		 * </p>
		 * <p>
		 * 	Override this to change the process of creating the TMX object into which all other contents will go.
		 * </p>
		 */
		protected function createTMX(xml:XML) : TMX {
			var tmxObj : TMX = new TMX (
				uint(xml.@width),
				uint(xml.@height),
				uint(xml.@tilewidth),
				uint(xml.@tileheight)
			);
			
			// Get properties
			for each (var mapPropsXML : XML in tmxObj.properties.property) {
				tmxObj.properties[mapPropsXML.@name] = String(mapPropsXML.@value);
			}
			
			return tmxObj;
		}
		
		/**
		 * Used by loadXML() to create each TMXTileset to place into the TMX.
		 * <p>
		 * 	Note that it is the tileset itself that creates the individual tiles within a tileset.
		 * </p>
		 * <p>
		 * 	Override this to change the process of creating the TMXTileset objects that will be stored in the TMX.
		 * </p>
		 * 
		 * @param tilesetXML The XML corresponding to the current tileset.
		 * @param xml The XML for the root TMX object.
		 */
		protected function createTileset(tilesetXML : XML, xml:XML) : TMXTileset {
			// Get the source for the bitmap data
			var tmxTilesetSrc : String = String(tilesetXML.image.@source);
			
			// Load the bitmap data for the tileset
			var tmxTilesetBmp : BitmapData = (this as TMXLoader).loadBitmapData(tmxTilesetSrc);
			
			// Create tileset
			var tmxTileset : TMXTileset = new TMXTileset(
				String(tilesetXML.@name),
				uint(tilesetXML.@firstgid),
				uint(tilesetXML.@tilewidth),
				uint(tilesetXML.@tileheight),
				tmxTilesetSrc,
				tmxTilesetBmp
			);
			
			// Read and set properties for each tile
			for each (var tileXML : XML in tilesetXML.tile) {
				var tileIndex : int = uint(tileXML.@id);
				var tmxTile : TMXTile = tmxTileset[tileIndex];
				for each (var tilePropsXML : XML in tileXML.properties.property)
				tmxTile.properties[tilePropsXML.@name] = String(tilePropsXML.@value);
			}
			
			return tmxTileset;
		}
		
		/**
		 * Used by loadXML() to create TMXTileLayer objects.
		 * <p>
		 * 	The creation process may depend on the partially-created TMX object in the tmx property.
		 * </p>
		 * @param layerXML XML for the current tile layer.
		 * @param xml XML for the containing TMX.
		 */
		protected function createTileLayer(layerXML : XML, xml : XML) : AbstractTMXLayer {
			// Determine the correct size for this layer
			var tmxLayerWidth : uint = layerXML.hasOwnProperty('@width') ?
				int(layerXML.@width) : tmxLayerWidth = tmx.width;
			var tmxLayerHeight : uint = layerXML.hasOwnProperty('@height') ?
				int(layerXML.@height) : tmxLayerHeight = tmx.height;
			
			// Create the new layer
			var tmxLayer : TMXTileLayer = new TMXTileLayer(
				String(layerXML.@name),
				tmxLayerWidth,
				tmxLayerHeight
			);
			
			// Get layer properties
			for each (var layerPropXML : XML in tmxLayer.properties.property) {
				tmxLayer.properties[String(layerPropXML.@name)] = String(layerPropXML.@value);
			}
			
			// Populate the layer with tiles
			var data : Vector.<uint> = createTileLayerData(layerXML.data[0], layerXML, xml);
			var index : uint = 0;
			for (var row : uint = 0; row < tmxLayer.height; row++) {
				for (var col : uint = 0; col < tmxLayer.width; col++) {
					var tile : TMXTile = tmx.tilesets.getByGid(data[index]);
					tmxLayer.setTile(col, row, tile);
					index++;
				}
			}
			
			return tmxLayer;
		}
		
		/**
		 * Used by createTileLayer() to get a flat list of tile global IDs
		 */
		protected function createTileLayerData(dataXML : XML, layerXML : XML, xml : XML) : Vector.<uint> {
			var data : Vector.<uint> = new Vector.<uint>;
			
			// Determine the encoding for this layer
			var encoding : String = dataXML.hasOwnProperty('@encoding')
				? String(dataXML.@encoding) : Encoding.NONE;
			
			// Act on encoding first, then compression (if necessary)
			switch (encoding) {
				// The data is not encoded, so it must be XML.
				case Encoding.NONE:
					for each (var tileXML : XML in dataXML.tile)
					data.push(uint(tileXML.@gid));
				break;
				
				
				// The data is encoding using comma-seperated values.
				case Encoding.CSV:
					var gidsStrs : Array = String(dataXML.text()).split(",");
					for each (var gidStr : String in gidsStrs);
						data.push(uint(gidStr));
				break;
				
				// The data is encoded using base64.
				// (This means it is binary and may be compressed.)
				case Encoding.BASE64:
					
					// Get the decoded bytes
					var b64d : Base64Decoder = new Base64Decoder;
					b64d.decode(dataXML.text());
					var bytes : ByteArray = b64d.toByteArray();
					bytes.endian = Endian.LITTLE_ENDIAN;
					
					// Determine the compression type used
					var compression : String = dataXML.hasOwnProperty('@compression')
						? String(dataXML.@compression) : Compression.NONE;
					
					switch (compression) {
						
						case Compression.NONE:
							// No action needed
						break;
						
						// Zlib and GZip compression are both handled the same way
						case Compression.ZLIB:
						case Compression.GZIP:
							// Swap the current compressed bytes with a new array for
							// the decompressed bytes
							var bytesC : ByteArray = bytes;
							bytes = new ByteArray;
							bytes.endian = Endian.LITTLE_ENDIAN;
							
							// Use ZLib-From-Scratch to decompress the data
							var decomp : ZlibDecoder = new ZlibDecoder;
							var zlibDone : Boolean = false;
							
							// Keep reading messages until there are no more left
							while (!zlibDone) {
								var bytesUsed : uint = decomp.feed(bytesC, bytes);
								bytesC = ZlibUtil.removeBeginning(bytesC, bytesUsed);
								if (decomp.lastError == ZlibDecoderError.NoError)
									zlibDone = true;
								else if (decomp.lastError == ZlibDecoderError.NeedMoreData)
									continue;
								else
									throw new Error("Error occured while decompressing layer tile data. Ensure that the data is not invalid or corrupted.");
							}
						break;
						
						// Unknown compression type
						default:
							throw new ArgumentError("layer data uses an unsupported compression format.");
					}
					
					// Convert the BytesArray into a vector of uints
					bytes.position = 0;
					while (bytes.bytesAvailable > 0)
						data.push(bytes.readUnsignedInt());
				break;
			}
			
			return data;
		}
		
		/**
		 * Used by loadXML() to create TMXObjectGroup objects.
		 * <p>
		 * 	The creation process may depend on the partially-created TMX object in the tmx property.
		 * </p>
		 * @param layerXML XML for the current object group.
		 * @param xml XML for the containing TMX.
		 */
		protected function createObjectGroup(layerXML : XML, xml : XML) : AbstractTMXLayer {
			// Determine the correct size for this object group
			var tmxObjGroupWidth : uint = layerXML.hasOwnProperty('@width') ?
				int(layerXML.@width) : tmxObjGroupWidth = tmx.width;
			var tmxObjGroupHeight : uint = layerXML.hasOwnProperty('@height') ?
				int(layerXML.@height) : tmxObjGroupHeight = tmx.height;
			
			// Create the new object group
			var tmxObjGroup : TMXObjectGroup = new TMXObjectGroup(
				String(layerXML.@name),
				tmxObjGroupWidth,
				tmxObjGroupHeight
			);
			
			// Get object group properties
			for each (var ogroupPropXML : XML in layerXML.properties.property) {
				tmxObjGroup.properties[String(ogroupPropXML.@name)] = String(ogroupPropXML.@value);
				// TODO: Get tile data from XML and place it into the objects.
			}
			
			// Get objects of the group
			for each (var objectXML : XML in layerXML.object) {
				var tmxObj : TMXObject = createObject(objectXML, layerXML, xml);
				tmxObjGroup.push(tmxObj);
			}
			
			return tmxObjGroup;
		}
		
		/**
		 * Used by createObjectGroup() to create TMXObject objects.
		 * @param objectXML The XML for the current object.
		 * @param layerXML The XML for the object group of the current object.
		 * @param xml The XML for the TMX.
		 */
		protected function createObject(objectXML : XML, layerXML : XML, xml : XML) : TMXObject {
			// Create and store object
			var tmxObject : TMXObject = new TMXObject(
				String(objectXML.@name),
				String(objectXML.@type),
				new Rectangle(
					uint(objectXML.@x),
					uint(objectXML.@y),
					uint(objectXML.@width),
					uint(objectXML.@height)
				)	
			);
			
			// If the XML provides a tile GID, try to get a tile for the object.
			if (objectXML.hasOwnProperty('@gid')) {
				var gid : uint = uint(objectXML.@gid);
				var tile : TMXTile = tmx.tilesets.getByGid(gid);
				tmxObject.tile = tile;
			}
			
			// Get object properties
			for each (var objectPropsXML : XML in objectXML.properties.property) {
				tmxObject.properties[String(objectPropsXML.@name)] = String(objectPropsXML.@value);
			}
			
			return tmxObject;
		}
	}
}