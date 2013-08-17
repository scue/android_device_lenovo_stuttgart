package com.cyanogenmod.settings.device;

import android.util.Log;
import java.io.DataInputStream;
import java.io.DataOutputStream;

/**
 * 
 * @author scue
 * for this program run a root command
 */
public class RootCmd
{
  @SuppressWarnings("deprecation")
public static String execRootCmdSilent(String paramString)
  {
    try
    {
      Log.i("RootCmd", paramString);
      /**
       * 执行Shell命令；
       */
      Process process = Runtime.getRuntime().exec("su");
      DataOutputStream dataOutputStream = new DataOutputStream(process.getOutputStream());
      dataOutputStream.writeBytes(paramString + "\n"); //执行命令
      dataOutputStream.flush();     //确保数据流完整地发送至目标
      dataOutputStream.writeBytes("exit\n"); //完成后退出
      dataOutputStream.flush();     //确保数据完整地发送目标
      process.waitFor();                     //等待操作的执行完成
      /**
       *    获取Shell命令标准输出；
       */
      DataInputStream dataInputStream = new DataInputStream(process.getInputStream()); 
      StringBuffer inputLine = new StringBuffer();
      String tmp; 
      while ((tmp = dataInputStream.readLine()) != null) {
          inputLine.append(tmp); //把信息写入至字符串缓冲区
      }
      String string = inputLine.toString(); //把缓冲区的数据写入至一个字符串，并返回
      return string;
    }
    catch (Exception localException)
    {
        localException.printStackTrace();
    }
    return null;
  }
}
