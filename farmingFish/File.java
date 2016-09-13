package com.hfutwlw.service;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.Binder;
import android.os.IBinder;
import android.os.StrictMode;
import android.util.Log;
import android.widget.Toast;

import com.hfutwlw.domain.Fram;
import com.hfutwlw.domain.PoolInfo;
import com.hfutwlw.domain.ToSoA;
import com.hfutwlw.service.listener.DataReceiveListener;
import com.hfutwlw.sxpound.MyApplication;
import com.hfutwlw.tool.SavaFra;
import com.hfutwlw.tool.ToGet.DeviceType;
import com.hfutwlw.tool.ToGet.HSBody;
import com.hfutwlw.tool.ToGet.HSHead;
import com.hfutwlw.tool.ToGet.HSPackage;
import com.hfutwlw.tool.Utility;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NetService extends Service {
    
    /*服务器的IP地址和端口号*/
    private final static String ip = MyApplication.IP;
    private final static int port = 9101;
    
    public static Socket socket;
    
    private int lenhead = 23;
    private String customerNo;
    private boolean isContinueLis = true;
    private Context context;
    private List<PoolInfo> poolInfos;
    
    private Map<String, Fram> framHashMap = new HashMap<>();
    private HashMap<String, String> filterState = new HashMap<>();
    private HashMap<String, String> stateDev = new HashMap<>();
    private HashMap<String, String> stateHashMap = new HashMap<>();
    
    private List<DataReceiveListener> dataReceiveListeners = new ArrayList<>(); //监听者模式
    
    @Override
    public void onCreate() {
        super.onCreate();
        context = getApplicationContext();
    }
    
    public void initSocket(String ip, int port, String customerNo, List<PoolInfo> poolInfos) {
        //在mainThread上网络请求报错，这样可以在主线程请求网路数据
        StrictMode.setThreadPolicy(new StrictMode.ThreadPolicy.Builder()
                                   .detectDiskReads().detectDiskWrites().detectAll().penaltyLog().build());
        StrictMode.setVmPolicy(new StrictMode.VmPolicy.Builder().detectAll()
                               .penaltyLog().penaltyDeath().build());
        isContinueLis = true;
        try {
            socket = new Socket();
            socket.connect(new InetSocketAddress(ip, port));
            this.poolInfos = poolInfos;
            this.customerNo = customerNo;
            Toast.makeText(context, "连接服务器", Toast.LENGTH_SHORT).show();
            HSHead head = new HSHead((byte) 3, DeviceType.Android, customerNo,
                                     new byte[]{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, (short) 1, (byte) 0);
            HSBody body = new HSBody(new byte[0]);
            HSPackage hsPackage = new HSPackage(head, body);
            ReceHostData();
            sendMessage(hsPackage.GetBytes());
        } catch (Exception e) {
            e.printStackTrace();
            Toast.makeText(context, "连接服务器出错", Toast.LENGTH_SHORT).show();
        }
    }
    
    @Override
    public IBinder onBind(Intent arg0) {
        poolInfos = MyApplication.poolInfos;
        customerNo = MyApplication.customerNo;
        initSocket(ip, port, customerNo, poolInfos);
        return new MyBinder();
    }
    
    public void addDataReceiveListener(DataReceiveListener dataReceiveListener) {
        this.dataReceiveListeners.add(dataReceiveListener);
    }
    
    public class MyBinder extends Binder {
        public NetService getMyservice() {
            return NetService.this;
        }
    }
    
    public void sendMessage(final byte[] b) {
        try {
            OutputStream outputStream = socket.getOutputStream();
            outputStream.write(b);
            Log.i("发送数据", new String(b));
            outputStream.flush();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    public void ReceHostData() {
        new Thread() {
            private InputStream inputStream;
            
            public void run() {
                while (socket != null && socket.isConnected() && !socket.isClosed() && isContinueLis) {
                    try {
                        inputStream = socket.getInputStream();
                        byte bs[] = new byte[1024];
                        int contentLength = inputStream.read(bs);
                        if (contentLength == -1) {
                            Log.e("com.apmt.sxpound--error", "连接失败");
                            for (int i = 0; i < poolInfos.size(); i++) {
                                stateHashMap.put(poolInfos.get(i).getDeviceID(), "离线");
                            }
                            //socket断开时之位false，不在监听数据
                            isContinueLis = false;
                            for (DataReceiveListener dataReceiveListener : dataReceiveListeners) {
                                dataReceiveListener.framStateReceive(stateHashMap);
                                isContinueLis = false;
                            }
                        }
                        byte[] contentBytes = Arrays.copyOfRange(bs, 0, contentLength);
                        String contentStr = Utility.getHexString(contentBytes);
                        Log.e("hex", contentStr);
                        
                        //遍历接收到的字节数，取出每26个作为一组，构造成HSHead,然后将设备状态放入hashmap中
                        if (contentLength % 26 == 0 && (contentLength / 26) > 0) {// 可能会发多条
                            int start = 0;
                            int end = 23;
                            for (int i = 0; i < contentLength / 26; i++) {
                                byte[] childBytes = Arrays.copyOfRange(contentBytes, start, end);
                                start = start + 26;
                                end = end + 26;
                                HSHead hsHead = new HSHead(childBytes);
                                if (hsHead.GetBodyLength() == 0) {
                                    stateHashMap.put(hsHead.GetDeviceID(), (hsHead.GetOrderWord() + "").equals("-3") ? "离线" : "在线");
                                }
                            }
                        }
                        
                        //只取第一条
                        byte[] headBytes = Arrays.copyOfRange(contentBytes, 0, lenhead);// 只有一条时
                        HSHead hsHead = new HSHead(headBytes);// 解析
                        
                        
                        if ((hsHead.GetOrderWord() + "").equals("3")) {// 如果是内容的时候
                            MyApplication cApplicationontext = (MyApplication) context.getApplicationContext();
                            byte[] bodyBytes = Arrays.copyOfRange(contentBytes, lenhead, lenhead + 40);
                            String message = Utility.getHexString(bodyBytes);
                            //用于得到大气  数据
                            ToSoA toSoA = new ToSoA(message, context);
                            toSoA.getWay(hsHead.GetDeviceID());
                            Fram fram = SavaFra.getFram(hsHead.GetDeviceID());// 保持对象的多样
                            framHashMap.put(hsHead.GetDeviceID(), fram);
                            cApplicationontext.framHashMap = framHashMap;
                            for (DataReceiveListener dataReceiveListener : dataReceiveListeners) {
                                dataReceiveListener.framDataReceive(framHashMap);// 同样通接口回调，发广播
                                String d = Utility.getHexString((Arrays.copyOfRange(contentBytes, lenhead + 40, lenhead + 41)));
                                HashMap<String, Integer> map = cApplicationontext.getNowMap();
                                if (map.get(hsHead.GetDeviceID()) == null/*&&map.get(hsHead.GetDeviceID()) == 0*/) {
                                    if ("1e".equals(d)) {
                                        String receive = Utility.getHexString((Arrays.copyOfRange(contentBytes, lenhead + 41, lenhead + 45)));
                                        map.put(hsHead.GetDeviceID(), 2);
                                        stateDev.put(hsHead.GetDeviceID(), receive);
                                        dataReceiveListener.controlReceive(stateDev);
                                    }
                                }
                                
                            }
                        }
                        
                        //设置信息？
                        if ((hsHead.GetOrderWord() + "").equals("19")) {
                            filterState.put(hsHead.GetDeviceID(), "19");
                            for (DataReceiveListener dataReceiveListener : dataReceiveListeners) {
                                dataReceiveListener.setReceive(filterState);
                            }
                        }
                        
                        // 电机控制
                        if ((hsHead.GetOrderWord() + "").equals("15")) {
                            int getBodyLength = hsHead.GetBodyLength();
                            byte[] bodyBytes = Arrays.copyOfRange(contentBytes, lenhead, lenhead + getBodyLength);
                            String relBody = Utility.getHexString(bodyBytes);
                            Log.e("ju", relBody);
                            String sta = "";
                            for (int i = 0; i < relBody.length(); i++) {
                                if ((i + 1) % 4 == 0) {
                                    sta = sta + relBody.charAt(i);
                                }
                            }
                            stateDev.put(hsHead.GetDeviceID(), sta);
                            for (DataReceiveListener dataReceiveListener : dataReceiveListeners) {
                                dataReceiveListener.controlReceive(stateDev);
                            }
                        }
                        stateHashMap.put(hsHead.GetDeviceID(), (hsHead.GetOrderWord() + "").equals("-3") ? "离线" : "在线");
                        Log.e("sta", stateHashMap.toString());
                        if (dataReceiveListeners != null) {
                            for (DataReceiveListener dataReceiveListener : dataReceiveListeners) {
                                dataReceiveListener.framStateReceive(stateHashMap);// 状态
                            }
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                try {
                    sleep(1000 * 30);
                    ReceHostData();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }.start();
        keepLive();
    }
    
    public void keepLive() {
        new Thread() {
            public void run() {
                while (socket.isConnected() && !socket.isClosed()) {
                    HSHead head = new HSHead((byte) 2, DeviceType.Water, customerNo,
                                             new byte[]{0x12, 0x78, (byte) 0xA0, (byte) 0x9C,//协议
                                                 0x00, 0x00, 0x00, 0x00}, (short) 02, (byte) 0);
                    HSBody body = new HSBody(new byte[]{0});
                    HSPackage p = new HSPackage(head, body);
                    HSHead head1 = new HSHead((byte) 3, DeviceType.Android, customerNo,
                                              new byte[]{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, (short) 01, (byte) 0);
                    HSBody body1 = new HSBody(new byte[0]);
                    HSPackage p1 = new HSPackage(head1, body1);
                    sendMessage(p.GetBytes());
                    sendMessage(p1.GetBytes());
                    Log.e("log", "保持连接");
                    try {
                        Thread.sleep(15000);
                    } catch (Exception e) {
                        e.printStackTrace();
                        
                    }
                }
            }
        }.start();
    }
    
    public Socket getSocket() {
        return socket;
    }
}
