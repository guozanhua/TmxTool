package com.bradsbytes.tmx
{
	/**
	 * Specifies different encoding types for tile data.
	 */
	public final class Encoding
	{
		/**
		 * Indicates that no encoding is used to store tile GIDs and that the data is stored as XML <tile> elements.
		 */
		public static const NONE : String = "";
		
		/**
		 * Indicates that Base64 encoding is used to store tile GIDs.
		 */
		public static const BASE64 : String = "base64";
		
		/**
		 * Indicates that comma-separated values are used to store tile GIDs.
		 */
		public static const CSV : String = "csv";
	}
}