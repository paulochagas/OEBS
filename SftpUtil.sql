DROP JAVA SOURCE APPS."SftpUtil";

CREATE OR REPLACE AND RESOLVE JAVA SOURCE NAMED APPS."SftpUtil"
as import java.io.BufferedInputStream;
import java.util.Properties;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;

public class SftpUtil {

	static Channel channel = null;
	static Session sshSession = null;



    public static void main(String[] args) {

    	//listFileNames("icxvld2017", 22, "CXU2001.ext", "DAB$AxZ123", "/home/CXU2001.ext/getpaid/bin");
        //moveFile(args[0], args[1], args[2], args[3], args[4],args[5], args[5], args[6], args[6], args[7]);
    }

    private static ChannelSftp connectSFTP(String host, int port, String username, final String password) {

    	ChannelSftp sftp = null;

    	try {
    		JSch jsch = new JSch();
            jsch.getSession(username, host, port);
            sshSession = jsch.getSession(username, host, port);
            sshSession.setPassword(password);
            Properties sshConfig = new Properties();
            sshConfig.put("StrictHostKeyChecking", "no");
            sshSession.setConfig(sshConfig);
            sshSession.connect();
            channel = sshSession.openChannel("sftp");
            channel.connect();
            sftp = (ChannelSftp) channel;


    	}  catch (Exception e) {
            e.printStackTrace();
        }

    	return sftp;

    }


    public static void moveFile(String srchost, String srcport, String srcusername, final String srcpassword, String srcfile,String dsthost, String dstport, String dstusername, final String dstpassword, String dstfile) {

    	ChannelSftp sftpSource = null;
    	ChannelSftp sftpTarget = null;
    	int intsrcport = Integer.parseInt(srcport);
    	int intsdtport = Integer.parseInt(dstport);

    	try {

    		sftpSource = connectSFTP(srchost, intsrcport, srcusername, srcpassword);
    		sftpTarget = connectSFTP(dsthost, intsdtport, dstusername, dstpassword);


            BufferedInputStream bis = new BufferedInputStream(sftpSource.get(srcfile));
    		sftpTarget.put(bis, dstfile);

    	}  catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeChannel(sftpSource);
            closeChannel(channel);
            closeSession(sshSession);
        }
        System.out.println("SFTP.MoveFile: Completed with no errors...");
    }

    private static void closeChannel(Channel channel) {
        if (channel != null) {
            if (channel.isConnected()) {
                channel.disconnect();
            }
        }
    }

    private static void closeSession(Session session) {
        if (session != null) {
            if (session.isConnected()) {
                session.disconnect();
            }
        }
    }
}
/
