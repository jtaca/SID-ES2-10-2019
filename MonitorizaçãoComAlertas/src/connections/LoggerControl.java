package connections;

import java.io.File;
import java.io.IOException;
import java.util.logging.FileHandler;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;

public class LoggerControl {

   public static Logger setFileSave(Logger logger) {
       FileHandler fh;

       try {
           File file = new File(System.getProperty("user.dir") + File.separator + "logs" + File.separator);
           if(!file.exists())
               if (!file.mkdirs())
                   logger.warning("Directories not created.");
           fh = new FileHandler(file.getAbsolutePath() + File.separator + "bda-" + logger.getName() + ".log");
           logger.addHandler(fh);
           SimpleFormatter formatter = new SimpleFormatter();
           fh.setFormatter(formatter);
       } catch (SecurityException | IOException e) {
           e.printStackTrace();
       }
       return logger;
   }

}