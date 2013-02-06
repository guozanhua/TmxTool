package com.bradsbytes.tmx
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	use namespace flash_proxy;
	
	/**
	 * Provides controlled access to the tilesets of a TMX object.
	 * <p>Not intended to be instantiated except by the TMX class in its construction.</p>
	 * <p>This can basically be treated like an Array. It supports indexing and both
	 * for .. in and for each .. in loops, and it has the usual methods and properties of
	 * an array such as length, push(), etc.</p>
	 * <p>The TMXTilesetsView gives a link back to its parent TMX as the tmx property, which
	 * is read-only. Think of the view as an extension of the TMX itself which deals
	 * specifically with tilesets.</p>
	 */
	public class TMXTilesetsView extends Proxy
	{
		
		protected var _tmx : TMX = null;
		protected var _tilesets : Vector.<TMXTileset>;
		
		public function TMXTilesetsView()
		{
			_tilesets = new Vector.<TMXTileset>;
		}
		
		/**
		 * The TMX to which this tilesets view belongs.
		 */
		public function get tmx() :  TMX {
			return _tmx;
		}
		
		internal function setTmx(tmx_ : TMX) : void {
			_tmx = tmx_;
		}
		
		/**
		 * Return the tileset with the given index or null if the index is out of range.
		 */
		public function getByIndex(index : int) : TMXTileset {
			if (index < 0 || index >= length)
				return null
			return _tilesets[index];
		}
		
		/**
		 * Return the first tileset with the given name or null if there is no tileset with the given name.
		 */
		public function getByName(tsname : String) : TMXTileset {
			for each (var tileset : TMXTileset in _tilesets) {	
				if (tileset.name == tsname)
					return tileset;
			}
			return null;
		}
		
		/**
		 * Returns the TMXTile with the given "global tile identifier," or "GID," which is used to
		 * represent the tile within tile layers. If 0 is given or if no tile can be found with the
		 * given id, null is returned.
		 */
		public function getByGid(gid:int) : TMXTile {
			var tile : TMXTile = null;
			if (gid < 0)
				return null;
			for each (var tileset : TMXTileset in _tilesets) {
				tile = tileset.getByGid(gid);
				if (tile !== null)
					return tile;
			}
			return null;
		}
		
		/**
		 * The total number of tilesets.
		 */
		public function get length() : uint {
			return _tilesets.length;
		}
		
		/**
		 * Add a new tileset.
		 * <p>The tileset's GID range must not conflict with the GID ranges of tilesets already in the TMX,
		 * and the tileset must not already be inside another TMX.  
		 */
		public function push(tileset : TMXTileset) : void {
			if (tileset.tmx === null) {
				for each (var oTileset : TMXTileset in this) {
					if (tileset.firstgid <= oTileset.lastgid && tileset.lastgid >= oTileset.firstgid)
						throw new ArgumentError("new tileset GID range conflicts with existing tileset.")
				}
				_tilesets.push(tileset);
				tileset.setTmx(this.tmx);
			}
			else {
				throw new ArgumentError("tileset is already in another TMX."); 
			}
		}
		
		override flash_proxy function nextNameIndex(index:int):int {
			if (index > _tilesets.length)
				return 0;
			return index + 1;
		}
		
		override flash_proxy function nextName(index:int):String {
			return String(index - 1);
		}
		
		override flash_proxy function nextValue(index:int):* {
			return _tilesets[index - 1];
		}
	}
}