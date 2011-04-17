package Utils 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Scano
	 */
	public class MiscUtilities
	{
		/**
		 * Since Flash doesn't handle super/subscripts, this function will convert a text field into a group of textFields attached to a movie
		 * clip with the super scripts in the right place
		 * @param	pTextField - the text field to convert
		 * @param	superScriptChar - the String character that represents a superscript (ie: x^22 would be x with a superscript of 22)
		 * @return
		 */
		public static function SuperscriptTextField( pTextField:TextField, superScriptChar:String = "^"):MovieClip
		{
			//we'll use this to "tack" things onto
			var combinedClip:MovieClip = new MovieClip();
			
			//create a duplicate textfield so we preserve the old one
			var textField:TextField = new TextField();
			textField.defaultTextFormat = pTextField.defaultTextFormat;
			textField.text = pTextField.text;
			textField.filters = pTextField.filters;
			textField.width = pTextField.width;
			textField.height = pTextField.height;
			
			//add it to the base of our movieclip
			combinedClip.addChild(textField);
			
			//search for instances of the superScriptChar
			while ( textField.text.indexOf(superScriptChar) > -1 )
			{
				//get the x location of the character
				var charIndex:int = textField.text.indexOf(superScriptChar);
				
				//create a new text field for the superscript
				var newTextField:TextField = new TextField();
				//create the new format (have to set it all at once like filters, yay flash)
				var newFormat:TextFormat = textField.defaultTextFormat;
				newFormat.align = TextFormatAlign.LEFT; //align left to make sure it goes in the right place...
				newFormat.size = ((textField.defaultTextFormat.size as Number) - 4) as Object;
				newTextField.defaultTextFormat = newFormat;
				//preserve the filters
				newTextField.filters = textField.filters;
					
				//get the full number after the superscriptcharacter
				var lastIndex:int = textField.text.indexOf(" ", charIndex );
				var superscriptNumber:String = textField.text.slice(charIndex + 1, lastIndex);
				
				//remove old characters
				var newField:String = " "; //one for the carat
				for (var i:int = 0; i < superscriptNumber.length; i++) 
				{
					newField += " ";
				}
				textField.text = textField.text.replace( superScriptChar + superscriptNumber, newField );
				
				//set the text of the new field
				newTextField.text = superscriptNumber;
				
				//place the new textField slightly above where the superScriptChar was
				newTextField.x = textField.getCharBoundaries(charIndex).x + textField.x;
				newTextField.y = -10;
				
				//add the superscript field to our new field
				combinedClip.addChild(newTextField);
			}
			
			return combinedClip;
		}
		
		/**
		 * Shuffles the content of a basic array
		 * @param	target
		 * @return
		 */
		public static function ShuffleArray(target:Array):Array
		{
			var returnArray:Array = [];
			//copy the incoming array to preserve values
			var copyArray:Array = target.concat();
 
			while (copyArray.length > 0) 
			{
				returnArray.push(copyArray.splice(Math.round(Math.random() * (copyArray.length - 1)), 1)[0]);
			}

			
			return returnArray;
		}
		
	}

}