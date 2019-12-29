package other
{
    import com.hurlant.crypto.Crypto;
    import com.hurlant.crypto.symmetric.ICipher;
    import com.hurlant.crypto.symmetric.IPad;
    import com.hurlant.crypto.symmetric.PKCS5;
    import com.hurlant.util.Base64;
    import com.hurlant.util.Hex;
    import flash.utils.ByteArray;
    
    public class Crypt
    {
        public static const key:String = 'SUPER_SAKURA_TAISEN';
        
        /**
         * ECBを利用して平文を暗号化させます。
         * @param txt 平文
         * @return 暗号化された文字
         */
        public static function encrypt(txt:String):String
        {
            var type:String = 'blowfish-ecb';
            var key_:ByteArray = Hex.toArray(Hex.fromString(key));
            var data:ByteArray = Hex.toArray(Hex.fromString(txt));
            var pad:IPad = new PKCS5;
            var cipher:ICipher = Crypto.getCipher(type, key_, pad);
            pad.setBlockSize(cipher.getBlockSize());
            try
            {
                cipher.encrypt(data);
                return Base64.encodeByteArray(data);
            }
            catch (error:Error)
            {
                trace(error);
            }
            return null;
        }
        
        /**
         * ECBを利用して暗号化された文字を復元させます。
         * @param txt 暗号化された文字
         * @return 平文
         */
        public static function decrypt(txt:String):String
        {
            var type:String = 'blowfish-ecb';
            var key_:ByteArray = Hex.toArray(Hex.fromString(key));
            var data:ByteArray = Base64.decodeToByteArray(txt);
            var pad:IPad = new PKCS5;
            var cipher:ICipher = Crypto.getCipher(type, key_, pad);
            pad.setBlockSize(cipher.getBlockSize());
            try
            {
                cipher.decrypt(data);
                return Hex.toString(Hex.fromArray(data));
            }
            catch (error:Error)
            {
                trace(error);
            }
            return null;
        }
    }
}