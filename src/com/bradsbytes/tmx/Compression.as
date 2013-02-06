package com.bradsbytes.tmx
{
	/**
	 * Specifies different compression types for tile data.
	 */
	public final class Compression
	{
		/**
		 * Indicates that GID data is uncompressed.
		 */
		public static const NONE : String = "";
		
		/**
		 * Indicates that GID data is compressed with zlib compression.
		 */ 
		public static const ZLIB : String = "zlib";
		
		/**
		 * Indicates that GID data is compressed with gzip compression.
		 */ 
		public static const GZIP : String = "gzip";
	}
}